-- Use socket.gettime() for benchmark measurements
-- since it has millisecond precision on most systems
local socket = require("socket")

n = 10000000 -- number of tasks added (10^7)
m = 1000     -- number different priorities

local pq = PriorityQueue()

print(string.format("Adding %d tasks with random priority 1-%d ...", n, m))
start = socket.gettime()

for i = 1, n do
    pq:put(math.random(m), i)
end

print(string.format("Elapsed: %.3f ms.", (socket.gettime() - start) * 1000))

print("Retrieving all tasks in order...")
start = socket.gettime()

local pp = 0
local pv = 0

for i = 1, n do
    local p, task = pq:pop()

    -- check that tasks are popped in ascending priority
    assert(p >= pp)

    if pp == p then
        -- check that tasks within one priority maintain the insertion order
        assert(task > pt)
    end

    pp = p
    pt = task
end

print(string.format("Elapsed: %.3f ms.", (socket.gettime() - start) * 1000))
