using Random: seed!
seed!(1234) # for reproducibility

dice5() = rand(1:5)

function dice7()
    while true
        a = dice5()
        b = dice5()
        c = a + 5(b - 1)
        if c <= 21
            return mod1(c, 7)
        end
    end
end

rolls = (dice7() for i in 1:100000)
roll_counts = Dict{Int,Int}()
for roll in rolls
    roll_counts[roll] = get(roll_counts, roll, 0) + 1
end
foreach(println, sort(roll_counts))
