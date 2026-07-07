-- Define a local module table to export functions
local _Module = {}

-- Creates a read-only (constant) proxy table.
-- Any attempt to modify the returned table will result in an error.
--
-- Args:
--     valueTable (table): The original table containing the values.
--
-- Returns:
--     A proxy table that allows reading but prevents writing.
function _Module.makeConstantTable(valueTable)
    -- Create an empty proxy table that the user will interact with
    local proxy = {}

    -- Define the metatable that controls access to the proxy table
    local mt = {
        -- When reading a value, fetch it directly from the original valueTable
        __index = valueTable,

        -- When attempting to write or create a new key, intercept and throw an error
        __newindex = function(t, key, value)
            error("Cannot modify value of "..tostring(key))
        end
    }

    -- Attach the metatable to the proxy table
    setmetatable(proxy, mt)

    -- Return the read-only proxy
    return proxy
end

-- Export the module
return _Module
