constant table = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
function random_generation(integer len)
    sequence s
    s = rand(repeat(length(table),len))
    for i = 1 to len do
        s[i] = table[s[i]]
    end for
    return s
end function

function mutate(sequence s, integer n)
    for i = 1 to length(s) do
        if rand(n) = 1 then
            s[i] = table[rand(length(table))]
        end if
    end for
    return s
end function

function fitness(sequence probe, sequence target)
    atom sum
    sum = 0
    for i = 1 to length(target) do
        sum += power(find(target[i], table) - find(probe[i], table), 2)
    end for
    return sqrt(sum/length(target))
end function

constant target = "METHINKS IT IS LIKE A WEASEL", C = 30, MUTATE = 15
sequence parent, specimen
integer iter, best
atom fit, best_fit
parent = random_generation(length(target))
iter = 0
while not equal(parent,target) do
    best_fit = fitness(parent, target)
    printf(1,"Iteration: %3d, \"%s\", deviation %g\n", {iter, parent, best_fit})
    specimen = repeat(parent,C+1)
    best = C+1
    for i = 1 to C do
        specimen[i] = mutate(specimen[i], MUTATE)
        fit = fitness(specimen[i], target)
        if fit < best_fit then
            best_fit = fit
            best = i
        end if
    end for
    parent = specimen[best]
    iter += 1
end while
printf(1,"Finally, \"%s\"\n",{parent})
