using Primes, Printf

function ispenta(n)
    all(0:4) do i
        isprime(n^i + n + 1)
    end
end

function firstpenta(m, T=BigInt)
    nums = Iterators.countfrom(T(1))
    pentas = Iterators.filter(ispenta, nums)
    firstn = Iterators.take(pentas, m)
    return collect(firstn)
end

function table_display(nums, num_columns)
    num_elements = length(nums)
    num_rows = div(num_elements, num_columns)
    remaining_elements = num_elements % num_columns

    for i in 1:num_rows
        for j in 1:num_columns
            index = (i - 1) * num_columns + j
            print(nums[index], "\t")
        end
        println()
    end

    for i in 1:remaining_elements
        index = num_rows * num_columns + i
        print(nums[index], "\t")
    end
    println()
end

function stretch_penta(goal, T=BigInt)
    nums = Iterators.countfrom(T(1))
    pentas = Iterators.filter(ispenta, nums)
    firstn = Iterators.takewhile(<=(goal), pentas)
    return collect(firstn)
end

function run_rosetta()
    fp = firstpenta(30)
    println("First 30 Penta power prime seeds:")
    table_display(fp, 10)

    sp = stretch_penta(20000000)
    milestones = 1000000 .* (1:10)
    for milestone in milestones
        index = findfirst(>(milestone), sp)
        @printf "First element over %9i: %9i, index:%4i\n" milestone sp[index] index
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_rosetta()
end
