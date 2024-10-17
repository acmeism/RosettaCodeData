function move(sequence s, integer amount, integer src, integer dest)
    if src < 1 or src > length(s) or dest < 1 or dest > length(s) or amount < 0 then
        return -1
    else
        if src != dest and amount then
            if amount > s[src] then
                amount = s[src]
            end if
            s[src] -= amount
            s[dest] += amount
        end if
        return s
    end if
end function

sequence buckets
buckets = repeat(100,10)

procedure equalize()
    integer i, j, diff
    while 1 do
        i = rand(length(buckets))
        j = rand(length(buckets))
        diff = buckets[i] - buckets[j]
        if  diff >= 2 then
            buckets = move(buckets, floor(diff / 2), i, j)
        elsif diff <= -2 then
            buckets = move(buckets, -floor(diff / 2), j, i)
        end if
        task_yield()
    end while
end procedure

procedure redistribute()
    integer i, j
    while 1 do
        i = rand(length(buckets))
        j = rand(length(buckets))
        if buckets[i] then
            buckets = move(buckets, rand(buckets[i]), i, j)
        end if
        task_yield()
    end while
end procedure

function sum(sequence s)
    integer sum
    sum = 0
    for i = 1 to length(s) do
        sum += s[i]
    end for
    return sum
end function

atom task

task = task_create(routine_id("equalize"), {})
task_schedule(task, 1)

task = task_create(routine_id("redistribute"), {})
task_schedule(task, 1)

task_schedule(0, {0.5, 0.5})

for i = 1 to 24 do
    print(1,buckets)
    printf(1," sum: %d\n", {sum(buckets)})
    task_yield()
end for
