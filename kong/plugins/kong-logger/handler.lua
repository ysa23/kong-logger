local cjson = require "cjson"

local kong = kong
local timer_at = ngx.timer.at

local LoggerHandler = {
  PRIORITY = 6,
  VERSION = "0.1.3",
}

function LoggerHandler:access(conf) 
  -- get_body is only available at the access stage. So we extract the body and save it in the request's context
  local body = kong.request.get_body()
  ngx.ctx.logger = {
    req_body = body
  }
end

function LoggerHandler:log(conf)
  local message = kong.log.serialize()
  local dto = {
    latencies = message.latencies,
    consumer = message.consumer,
    request = message.request,
    client_ip = message.client_ip,
    response = message.response,
  }

  if ngx.ctx.logger ~= nil and ngx.ctx.logger.req_body ~= nil then
    dto.request.body = ngx.ctx.logger.req_body
  end

  local masks = {}

  if conf.masks ~= nil then
    for _, mask in pairs(conf.masks) do
      masks[mask] = true
    end
  end

  local function shouldBeMasked(key)
    return masks[key] ~= nil
  end

  local function sanitize (input)
    if type(input) ~= "table" then
      return
    end

    for key, value in pairs(input) do
      if shouldBeMasked(key) then
        input[key] = "******"
      elseif (key == "url" or key == "uri") and type(input[key]) == "string" then
        local indexOfQuery = string.find(input[key], "?")
        if indexOfQuery ~= nil then
          input[key] = string.sub(input[key], 0, indexOfQuery - 1)
        end   
      else
        sanitize(input[key])
      end
    end
  end

  local function shouldFilterRequest (input)
    if not conf.path_filters or #conf.path_filters == 0 then
      return false
    end

    for _,filter in pairs(conf.path_filters) do
      if string.find(input.uri, filter) then
        return true
      end
    end

    return false
  end
  
  local print_request = function()
    -- dto - which contains the request data - is captured by the closure for printing
    if shouldFilterRequest(dto.request) then
      return
    end

    sanitize(dto.request)
    sanitize(dto.response)
    local asJson = cjson.encode(dto)
    -- Due to limits of error logs, we filter the request body, under the assumption that the body is the cause of the large payload
    local limit = conf.filter_body_on_limit
    if limit ~= nil and string.len(asJson) > limit then
      if dto.request ~= nil and dto.request.body ~= nil then
        dto.request.body = nil
        asJson = cjson.encode(dto)
      end
    end
    kong.log.err("[kong-logger]" .. asJson .. "[/kong-logger]")
  end

  -- Serialize to json and print our of the scope of the user's request - to reduce lateney
  local ok, err = timer_at(0, print_request)
  if not ok then
    kong.log.err("failed to create timer: ", err)
  end
end


return LoggerHandler