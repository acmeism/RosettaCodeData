-- Start of helper functions section --

local function stringToTable(str)
    local t = {}
    for i = 1, #str do
        t[i] = str:sub(i, i)
    end
    return t
end

local function tableEmpty(t)
    return #t == 0
end

local function popLeft(t)
    local value = t[1]
    for i = 1, #t - 1 do
        t[i] = t[i+1]
    end
    t[#t] = nil
    return value
end

local function tableWithDupl(value, n)
    local out = {}
    for i = 1, n do
        out[i] = value
    end
    return out
end

-- End of helper functions section --

-- Node definition
local Node = {}
Node.__index = Node

function Node.new()
    local self = setmetatable({}, Node)

    self.son = {}
    for i = 1, 26 do
        self.son[i] = 0
    end
    self.ans = 0
    self.fail = 0
    self.du = 0
    self.idx = 0

    return self
end

-- Automaton definition
local Automaton = {}
Automaton.__index = Automaton

function Automaton.new(maxNodes)
    local self = setmetatable({}, Automaton)

    -- Preallocate self.tr with dummy values.
    -- We use 0-indexed node IDs; however, nodes are stored in self.tr[u+1].
    self.tr = tableWithDupl(0, maxNodes)
    self.tr[1] = Node.new()  -- root node, with id = 0
    self.tot = 0             -- number of new nodes allocated (excluding root)
    self.finalAnswer = {}
    self.pidx = 0            -- used to assign an id to pattern endpoints

    return self
end

function Automaton:reset()
    self.tr = tableWithDupl(0, #self.tr)
    self.tr[1] = Node.new()
    self.tot = 0
    self.finalAnswer = {}
    self.pidx = 0
end

function Automaton:insert(pattern)
    local u = 0  -- using 0-index for nodes; stored in self.tr[u+1]
    for i, char in ipairs(stringToTable(pattern)) do
        local charCode = string.byte(char) - string.byte("a") + 1  -- map 'a'-'z' to 1-26
        if self.tr[u+1].son[charCode] == 0 then
            self.tot = self.tot + 1
            self.tr[u+1].son[charCode] = self.tot
            self.tr[self.tot+1] = Node.new()  -- allocate new node at index tot
        end
        u = self.tr[u+1].son[charCode]
    end
    if self.tr[u+1].idx == 0 then
        self.pidx = self.pidx + 1
        self.tr[u+1].idx = self.pidx
    end
    return self.tr[u+1].idx
end

function Automaton:build()
    local queue = {}

    -- Initialise the queue with direct children of the root node.
    for i = 1, 26 do
        if self.tr[1].son[i] ~= 0 then
            table.insert(queue, self.tr[1].son[i])
        else
            -- Set missing transitions at root to point back to root (node 0)
            self.tr[1].son[i] = 0
        end
    end

    while not tableEmpty(queue) do
        local u = popLeft(queue)
        for i = 1, 26 do
            local sonNodeIndex = self.tr[u+1].son[i]
            local failNodeIndex = self.tr[u+1].fail
            if sonNodeIndex ~= 0 then
                self.tr[sonNodeIndex+1].fail = self.tr[failNodeIndex+1].son[i]
                self.tr[self.tr[sonNodeIndex+1].fail+1].du = self.tr[self.tr[sonNodeIndex+1].fail+1].du + 1
                table.insert(queue, sonNodeIndex)
            else
                self.tr[u+1].son[i] = self.tr[failNodeIndex+1].son[i]
            end
        end
    end
end

function Automaton:query(text)
    local u = 0
    for i, char in ipairs(stringToTable(text)) do
        local charCode = string.byte(char) - string.byte("a") + 1  -- adjust for 1-indexing
        u = self.tr[u+1].son[charCode]
        self.tr[u+1].ans = self.tr[u+1].ans + 1
    end
end

function Automaton:calculateFinalAnswers()
    self.finalAnswer = tableWithDupl(0, self.pidx+1)
    local queue = {}

    -- Iterate over all nodes: nodes are 0-indexed; stored at self.tr[u+1] for u = 0...tot
    for u = 0, self.tot do
        if self.tr[u+1].du == 0 then
            table.insert(queue, u)
        end
    end

    while not tableEmpty(queue) do
        local u = popLeft(queue)
        local nodeIndex = self.tr[u+1].idx
        if nodeIndex ~= 0 then
            self.finalAnswer[nodeIndex+1] = self.tr[u+1].ans
        end
        local v = self.tr[u+1].fail
        self.tr[v+1].ans = self.tr[v+1].ans + self.tr[u+1].ans
        self.tr[v+1].du = self.tr[v+1].du - 1
        if self.tr[v+1].du == 0 then
            table.insert(queue, v)
        end
    end
end

-- main code --

local MAX_NODES = 200000 + 6
local ac = Automaton.new(MAX_NODES)
local n = 5

local patternEndNoteIds = tableWithDupl(0, n+1)
local sampleInput = {"a", "bb", "aa", "abaa", "abaaa", "abaaabaa"}
local text = "abaaabaa"

for i = 1, n do
    local pattern = sampleInput[i]
    patternEndNoteIds[i+1] = ac:insert(pattern)
end

ac:build()
ac:query(text)
ac:calculateFinalAnswers()

for i = 1, n do
    local uniqueId = patternEndNoteIds[i+1]
    print(ac.finalAnswer[uniqueId+1])
end
