local typedefs = require "kong.db.schema.typedefs"

return {
  name = "kong-logger",
  fields = {
    { config = {
        type = "record",
        fields = {
          { masks = {
              type = "set",
              required = false,
              elements ={
                type = "string"
              },
            },
          }, 
          { path_filters = {
              type = "set",
              required = false,
              elements ={
                type = "string"
              },
            },
          },
          { filter_body_on_limit = {
            type = "number",
            required = false,
          },
        }, 
        }
      }
    }
  }
}
