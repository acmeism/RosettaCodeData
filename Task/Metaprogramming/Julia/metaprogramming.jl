macro dowhile(condition, block)
    quote
        while true
            $(esc(block))
            if !$(esc(condition))
                break
            end
        end
    end
end

macro dountil(condition, block)
    quote
        while true
            $(esc(block))
            if $(esc(condition))
                break
            end
        end
    end
end

using Primes

arr = [7, 31]

@dowhile (!isprime(arr[1]) && !isprime(arr[2])) begin
    println(arr)
    arr .+= 1
end
println("Done.")

@dountil (isprime(arr[1]) || isprime(arr[2])) begin
    println(arr)
    arr .+= 1
end
println("Done.")
