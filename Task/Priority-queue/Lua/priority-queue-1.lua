PriorityQueue = {
    __index = {
        put = function(self, p, v)
            local q = self[p]
            if not q then
                q = {first = 1, last = 0}
                self[p] = q
            end
            q.last = q.last + 1
            q[q.last] = v
        end,
        pop = function(self)
            for p, q in pairs(self) do
                if q.first <= q.last then
                    local v = q[q.first]
                    q[q.first] = nil
                    q.first = q.first + 1
                    return p, v
                else
                    self[p] = nil
                end
            end
        end
    },
    __call = function(cls)
        return setmetatable({}, cls)
    end
}

setmetatable(PriorityQueue, PriorityQueue)

-- Usage:
pq = PriorityQueue()

tasks = {
    {3, 'Clear drains'},
    {4, 'Feed cat'},
    {5, 'Make tea'},
    {1, 'Solve RC tasks'},
    {2, 'Tax return'}
}

for _, task in ipairs(tasks) do
    print(string.format("Putting: %d - %s", unpack(task)))
    pq:put(unpack(task))
end

for prio, task in pq.pop, pq do
    print(string.format("Popped: %d - %s", prio, task))
end
