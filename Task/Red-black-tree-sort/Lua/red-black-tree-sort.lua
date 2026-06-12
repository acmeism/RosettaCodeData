-- Red-Black Tree implementation in Lua

-- Node class
local Node = {}
Node.__index = Node

function Node:new(val)
    local obj = {
        val = val,        -- Value of Node
        parent = nil,     -- Parent of Node
        left = nil,       -- Left Child of Node
        right = nil,      -- Right Child of Node
        color = 1         -- Red Node as new node is always inserted as Red Node (1=RED, 0=BLACK)
    }
    setmetatable(obj, Node)
    return obj
end

-- RBTree class
local RBTree = {}
RBTree.__index = RBTree

function RBTree:new()
    local obj = {
        NULL = Node:new(0),
        root = nil
    }
    setmetatable(obj, RBTree)

    obj.NULL.color = 0  -- BLACK
    obj.NULL.left = nil
    obj.NULL.right = nil
    obj.root = obj.NULL

    return obj
end

-- Insert New Node
function RBTree:insertNode(key)
    local node = Node:new(key)
    node.parent = nil
    node.val = key
    node.left = self.NULL
    node.right = self.NULL
    node.color = 1  -- Set root colour as Red

    local y = nil
    local x = self.root

    while x ~= self.NULL do  -- Find position for new node
        y = x
        if node.val < x.val then
            x = x.left
        else
            x = x.right
        end
    end

    node.parent = y  -- Set parent of Node as y

    if y == nil then  -- If parent is none then it is root node
        self.root = node
    elseif node.val < y.val then  -- Check if it is right Node or Left Node by checking the value
        y.left = node
    else
        y.right = node
    end

    if node.parent == nil then  -- Root node is always Black
        node.color = 0
        return
    end

    if node.parent.parent == nil then  -- If parent of node is Root Node
        return
    end

    self:fixInsert(node)  -- Else call for Fix Up
end

-- Find minimum node
function RBTree:minimum(node)
    while node.left ~= self.NULL do
        node = node.left
    end
    return node
end

-- Code for left rotate
function RBTree:LR(x)
    local y = x.right  -- Y = Right child of x
    x.right = y.left   -- Change right child of x to left child of y

    if y.left ~= self.NULL then
        y.left.parent = x
    end

    y.parent = x.parent  -- Change parent of y as parent of x

    if x.parent == nil then  -- If parent of x == None ie. root node
        self.root = y        -- Set y as root
    elseif x == x.parent.left then
        x.parent.left = y
    else
        x.parent.right = y
    end

    y.left = x
    x.parent = y
end

-- Code for right rotate
function RBTree:RR(x)
    local y = x.left   -- Y = Left child of x
    x.left = y.right   -- Change left child of x to right child of y

    if y.right ~= self.NULL then
        y.right.parent = x
    end

    y.parent = x.parent  -- Change parent of y as parent of x

    if x.parent == nil then  -- If x is root node
        self.root = y        -- Set y as root
    elseif x == x.parent.right then
        x.parent.right = y
    else
        x.parent.left = y
    end

    y.right = x
    x.parent = y
end

-- Fix Up Insertion
function RBTree:fixInsert(k)
    while k.parent.color == 1 do  -- While parent is red
        if k.parent == k.parent.parent.right then  -- if parent is right child of its parent
            local u = k.parent.parent.left  -- Left child of grandparent

            if u.color == 1 then  -- if color of left child of grandparent i.e, uncle node is red
                u.color = 0  -- Set both children of grandparent node as black
                k.parent.color = 0
                k.parent.parent.color = 1  -- Set grandparent node as Red
                k = k.parent.parent  -- Repeat the algo with Parent node to check conflicts
            else
                if k == k.parent.left then  -- If k is left child of it's parent
                    k = k.parent
                    self:RR(k)  -- Call for right rotation
                end
                k.parent.color = 0
                k.parent.parent.color = 1
                self:LR(k.parent.parent)
            end
        else  -- if parent is left child of its parent
            local u = k.parent.parent.right  -- Right child of grandparent

            if u.color == 1 then  -- if color of right child of grandparent i.e, uncle node is red
                u.color = 0  -- Set color of childs as black
                k.parent.color = 0
                k.parent.parent.color = 1  -- set color of grandparent as Red
                k = k.parent.parent  -- Repeat algo on grandparent to remove conflicts
            else
                if k == k.parent.right then  -- if k is right child of its parent
                    k = k.parent
                    self:LR(k)  -- Call left rotate on parent of k
                end
                k.parent.color = 0
                k.parent.parent.color = 1
                self:RR(k.parent.parent)  -- Call right rotate on grandparent
            end
        end

        if k == self.root then  -- If k reaches root then break
            break
        end
    end

    self.root.color = 0  -- Set color of root as black
end

-- Function to fix issues after deletion
function RBTree:fixDelete(x)
    while x ~= self.root and x.color == 0 do  -- Repeat until x reaches nodes and color of x is black
        if x == x.parent.left then  -- If x is left child of its parent
            local s = x.parent.right  -- Sibling of x

            if s.color == 1 then  -- if sibling is red
                s.color = 0  -- Set its color to black
                x.parent.color = 1  -- Make its parent red
                self:LR(x.parent)  -- Call for left rotate on parent of x
                s = x.parent.right
            end

            -- If both the child are black
            if s.left.color == 0 and s.right.color == 0 then
                s.color = 1  -- Set color of s as red
                x = x.parent
            else
                if s.right.color == 0 then  -- If right child of s is black
                    s.left.color = 0  -- set left child of s as black
                    s.color = 1       -- set color of s as red
                    self:RR(s)        -- call right rotation on x
                    s = x.parent.right
                end
                s.color = x.parent.color
                x.parent.color = 0  -- Set parent of x as black
                s.right.color = 0
                self:LR(x.parent)  -- call left rotation on parent of x
                x = self.root
            end
        else  -- If x is right child of its parent
            local s = x.parent.left  -- Sibling of x

            if s.color == 1 then  -- if sibling is red
                s.color = 0  -- Set its color to black
                x.parent.color = 1  -- Make its parent red
                self:RR(x.parent)  -- Call for right rotate on parent of x
                s = x.parent.left
            end

            if s.right.color == 0 and s.left.color == 0 then  -- Fixed: was s.right.color twice
                s.color = 1
                x = x.parent
            else
                if s.left.color == 0 then  -- If left child of s is black
                    s.right.color = 0  -- set right child of s as black
                    s.color = 1
                    self:LR(s)  -- call left rotation on x
                    s = x.parent.left
                end
                s.color = x.parent.color
                x.parent.color = 0
                s.left.color = 0
                self:RR(x.parent)
                x = self.root
            end
        end
    end

    x.color = 0
end

-- Function to transplant nodes
function RBTree:__rb_transplant(u, v)
    if u.parent == nil then
        self.root = v
    elseif u == u.parent.left then
        u.parent.left = v
    else
        u.parent.right = v
    end
    v.parent = u.parent
end

-- Function to handle deletions
function RBTree:delete_node_helper(node, key)
    local z = self.NULL

    while node ~= self.NULL do  -- Search for the node having that value/key and store it in 'z'
        if node.val == key then
            z = node
        end
        if node.val <= key then
            node = node.right
        else
            node = node.left
        end
    end

    if z == self.NULL then  -- If Key is not present then deletion not possible so return
        print("Value not present in Tree !!")
        return
    end

    local y = z
    local y_original_color = y.color  -- Store the color of z-node
    local x

    if z.left == self.NULL then  -- If left child of z is NULL
        x = z.right  -- Assign right child of z to x
        self:__rb_transplant(z, z.right)  -- Transplant Node to be deleted with x
    elseif z.right == self.NULL then  -- If right child of z is NULL
        x = z.left  -- Assign left child of z to x
        self:__rb_transplant(z, z.left)  -- Transplant Node to be deleted with x
    else  -- If z has both the child nodes
        y = self:minimum(z.right)  -- Find minimum of the right sub tree
        y_original_color = y.color  -- Store color of y
        x = y.right

        if y.parent == z then  -- If y is child of z
            x.parent = y  -- Set parent of x as y
        else
            self:__rb_transplant(y, y.right)
            y.right = z.right
            y.right.parent = y
        end

        self:__rb_transplant(z, y)
        y.left = z.left
        y.left.parent = y
        y.color = z.color
    end

    if y_original_color == 0 then  -- If color is black then fixing is needed
        self:fixDelete(x)
    end
end

-- Deletion of node
function RBTree:delete_node(val)
    self:delete_node_helper(self.root, val)  -- Call for deletion
end

-- Function to print
function RBTree:__printCall(node, indent, last)
    if node ~= self.NULL then
        io.write(indent)
        if last then
            io.write("R----")
            indent = indent .. "     "
        else
            io.write("L----")
            indent = indent .. "|    "
        end

        local s_color = (node.color == 1) and "RED" or "BLACK"
        print(node.val .. "(" .. s_color .. ")")
        self:__printCall(node.left, indent, false)
        self:__printCall(node.right, indent, true)
    end
end

-- Function to call print
function RBTree:print_tree()
    self:__printCall(self.root, "", true)
end

-- Main code
local bst = RBTree:new()

print("State of the tree after inserting the 30 keys:")
for x = 1, 29 do
    bst:insertNode(x)
end
bst:print_tree()

print("\nState of the tree after deleting the 15 keys:")
for x = 1, 14 do
    bst:delete_node(x)
end
bst:print_tree()
