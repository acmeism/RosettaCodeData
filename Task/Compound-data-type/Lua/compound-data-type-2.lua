cPoint = {}                                           -- metatable (behaviour table)
function newPoint(x, y)                               -- constructor
    local pointPrototype = {}                         -- prototype declaration
    function pointPrototype:getX() return x end       -- public method
    function pointPrototype:getY() return y end       -- public method
    function pointPrototype:getXY() return x, y end   -- public method
    function pointPrototype:type() return "point" end -- public method
    return setmetatable(pointPrototype, cPoint)       -- set behaviour and return the pointPrototype
end--newPoint
