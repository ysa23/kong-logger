local typedefs = require "kong.db.schema.typedefs"

return {
  name = "kong-logger",
  fields = {
    { config = {
        type = "record",
        fields = {
          { masks = {
              type = "set",
              elements ={
                type = "string"
              },
            },
          },
        }
      }
    }
  }
}
