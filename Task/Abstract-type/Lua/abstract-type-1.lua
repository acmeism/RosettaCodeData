BaseClass = {}

function class ( baseClass )
    local new_class = {}
    local class_mt = { __index = new_class }

    function new_class:new()
        local newinst = {}
        setmetatable( newinst, class_mt )
        return newinst
    end

    if not baseClass then baseClass = BaseClass end
        setmetatable( new_class, { __index = baseClass } )

    return new_class
end

function abstractClass ( self )
    local new_class = {}
    local class_mt = { __index = new_class }

    function new_class:new()
        error("Abstract classes cannot be instantiated")
    end

    if not baseClass then baseClass = BaseClass end
        setmetatable( new_class, { __index = baseClass } )

    return new_class
end

BaseClass.class = class
BaseClass.abstractClass = abstractClass
