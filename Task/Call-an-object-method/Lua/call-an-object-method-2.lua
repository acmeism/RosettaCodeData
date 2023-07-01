local methods = { }
function methods:func () -- if a function is declared using :, it is given an implicit 'self' parameter
    print(self.name)
end

local object = setmetatable({ name = "foo" }, { __index = methods })

object:func() -- with : sugar
methods.func(object) -- without : sugar
