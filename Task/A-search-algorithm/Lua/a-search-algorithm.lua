-- QUEUE -----------------------------------------------------------------------
Queue = {}
function Queue:new()
    local q = {}
    self.__index = self
    return setmetatable( q, self )
end
function Queue:push( v )
    table.insert( self, v )
end
function Queue:pop()
    return table.remove( self, 1 )
end
function Queue:getSmallestF()
    local s, i = nil, 2
    while( self[i] ~= nil and self[1] ~= nil ) do
        if self[i]:F() < self[1]:F() then
            s = self[1]
            self[1] = self[i]
            self[i] = s
        end
        i = i + 1
    end
    return self:pop()
end

-- LIST ------------------------------------------------------------------------
List = {}
function List:new()
    local l = {}
    self.__index = self
    return setmetatable( l, self )
end
function List:push( v )
  table.insert( self, v )
end
function List:pop()
    return table.remove( self )
end

-- POINT -----------------------------------------------------------------------
Point = {}
function Point:new()
    local p = { y = 0, x = 0 }
    self.__index = self
    return setmetatable( p, self )
end
function Point:set( x, y )
    self.x, self.y = x, y
end
function Point:equals( o )
    return (o.x == self.x and o.y == self.y)
end
function Point:print()
    print( self.x, self.y )
end

-- NODE ------------------------------------------------------------------------
Node = {}
function Node:new()
    local n = { pos = Point:new(), parent = Point:new(), dist = 0, cost = 0 }
    self.__index = self
    return setmetatable( n, self )
end
function Node:set( pt, parent, dist, cost )
    self.pos = pt
    self.parent = parent
    self.dist = dist
    self.cost = cost
end
function Node:F()
    return ( self.dist + self.cost )
end

-- A-STAR ----------------------------------------------------------------------
local nbours = {
    {  1,  0, 1 }, {  0,  1, 1 }, {  1,  1, 1.4 }, {  1, -1, 1.4 },
    { -1, -1, 1.4 }, { -1,  1, 1.4 }, {  0, -1, 1 }, { -1,  0, 1 }
}
local map = {
        1,1,1,1,1,1,1,1,1,1,
        1,0,0,0,0,0,0,0,0,1,
        1,0,0,0,0,0,0,0,0,1,
        1,0,0,0,0,1,1,1,0,1,
        1,0,0,1,0,0,0,1,0,1,
        1,0,0,1,0,0,0,1,0,1,
        1,0,0,1,1,1,1,1,0,1,
        1,0,0,0,0,0,0,0,0,1,
        1,0,0,0,0,0,0,0,0,1,
        1,1,1,1,1,1,1,1,1,1
}
local open, closed, start, goal,
      mapW, mapH = Queue:new(), List:new(), Point:new(), Point:new(), 10, 10
start:set( 2, 2 ); goal:set( 9, 9 )

function hasNode( arr, pos )
    for nx, val in ipairs( arr ) do
        if val.pos:equals( pos ) then
            return nx
        end
    end
    return -1
end
function isValid( pos )
    return pos.x > 0 and pos.x <= mapW
           and pos.y > 0 and pos.y <= mapH
           and map[pos.x + mapW * pos.y - mapW] == 0
end
function calcDist( p1 )
    local x, y = goal.x - p1.x, goal.y - p1.y
    return math.abs( x ) + math.abs( y )
end
function addToOpen( node )
    local nx
    for n = 1, 8 do
        nNode = Node:new()
        nNode.parent:set( node.pos.x, node.pos.y )
        nNode.pos:set( node.pos.x + nbours[n][1], node.pos.y + nbours[n][2] )
        nNode.cost = node.cost + nbours[n][3]
        nNode.dist = calcDist( nNode.pos )

        if isValid( nNode.pos ) then
            if nNode.pos:equals( goal ) then
                closed:push( nNode )
                return true
            end
            nx = hasNode( closed, nNode.pos )
            if nx < 0 then
                nx = hasNode( open, nNode.pos )
                if( nx < 0 ) or ( nx > 0 and nNode:F() < open[nx]:F() ) then
                    if( nx > 0 ) then
                        table.remove( open, nx )
                    end
                    open:push( nNode )
                else
                    nNode = nil
                end
            end
        end
    end
    return false
end
function makePath()
    local i, l = #closed, List:new()
    local node, parent = closed[i], nil

    l:push( node.pos )
    parent = node.parent
    while( i > 0 ) do
        i = i - 1
        node = closed[i]
        if node ~= nil and node.pos:equals( parent ) then
            l:push( node.pos )
            parent = node.parent
        end
    end
    print( string.format( "Cost: %d", #l - 1 ) )
    io.write( "Path: " )
    for i = #l, 1, -1 do
        map[l[i].x + mapW * l[i].y - mapW] = 2
        io.write( string.format( "(%d, %d) ", l[i].x, l[i].y ) )
    end
    print( "" )
end
function aStar()
    local n = Node:new()
    n.dist = calcDist( start )
    n.pos:set( start.x, start.y )
    open:push( n )
    while( true ) do
        local node = open:getSmallestF()
        if node == nil then break end
        closed:push( node )
        if addToOpen( node ) == true then
            makePath()
            return true
        end
    end
    return false
end
-- ENTRY POINT -----------------------------------------------------------------
if true == aStar() then
    local m
    for j = 1, mapH do
        for i = 1, mapW do
            m = map[i + mapW * j - mapW]
            if m == 0 then
                io.write( "." )
            elseif m == 1 then
                io.write( string.char(0xdb) )
            else
                io.write( "x" )
            end
        end
        io.write( "\n" )
    end
else
    print( "can not find a path!" )
end
