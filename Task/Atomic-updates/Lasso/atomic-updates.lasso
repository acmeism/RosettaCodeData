define atomic => thread {
    data
        private buckets = staticarray_join(10, void),
        private lock = 0

    public onCreate => {
        loop(.buckets->size) => {
            .`buckets`->get(loop_count) = math_random(0, 1000)
        }
    }

    public buckets => .`buckets`

    public bucket(index::integer) => .`buckets`->get(#index)

    public transfer(source::integer, dest::integer, amount::integer) => {
        #source == #dest
            ? return

        #amount = math_min(#amount, .`buckets`->get(#source))
        .`buckets`->get(#source) -= #amount
        .`buckets`->get(#dest)   += #amount
    }

    public numBuckets => .`buckets`->size

    public lock => {
        .`lock` == 1
            ? return false

        .`lock` = 1
        return true
    }
    public unlock => {
        .`lock` = 0
    }
}

local(initial_total) = (with b in atomic->buckets sum #b)
local(total) = #initial_total

// Make 2 buckets close to equal
local(_) = split_thread => {
    local(bucket1) = math_random(1, atomic->numBuckets)
    local(bucket2) = math_random(1, atomic->numBuckets)
    local(value1)  = atomic->bucket(#bucket1)
    local(value2)  = atomic->bucket(#bucket2)

    if(#value1 >= #value2) => {
        atomic->transfer(#bucket1, #bucket2, (#value1 - #value2) / 2)
    else
        atomic->transfer(#bucket2, #bucket1, (#value2 - #value1) / 2)
    }

    currentCapture->restart
}

// Randomly distribute 2 buckets
local(_) = split_thread => {
    local(bucket1) = math_random(1, atomic->numBuckets)
    local(bucket2) = math_random(1, atomic->numBuckets)
    local(value1)  = atomic->bucket(#bucket1)

    atomic->transfer(#bucket1, #bucket2, math_random(1, #value1))

    currentCapture->restart
}

local(buckets)
while(#initial_total == #total) => {
    sleep(2000)
    #buckets = atomic->buckets
    #total   = with b in #buckets sum #b
    stdoutnl(#buckets->asString + " -- total: " + #total)
}
stdoutnl(`ERROR: totals no longer match: ` + #initial_total + ', ' + #total)
