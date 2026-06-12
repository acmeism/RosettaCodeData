# rosettacode.org/wiki/Shuffle_groups

using Format

const BASE = 10
const MAX_LMT = 1402857
const GBL_INC_COUNT = Ref(0) # Global counter for IncDigits calls

""" Struct to hold the digit group information for an integer """
mutable struct DigitsOfNumber
    digit::Vector{UInt8}
    countofdigit::Vector{UInt8}
    num::Int
    witness::Set{Int}
    countdDigits::UInt8
    witnesscount::UInt8
    DigitsOfNumber() = new(zeros(UInt8, 22), zeros(UInt8, BASE), 0, Set{Int}(), 0, 0)
end

""" Struct to hold the witness information for a number """
struct Witness
    num::Int
    witness::Set{Int}
    witnesscount::UInt8
end

""" Format number with commas per US convention"""
commatize(n::Integer) = format(n, commas = true)

""" Print the occurrence of witness counts up to a limit """
function printfirstn(solutions::Vector{Witness}, lim::Int)
    println("For the first $(lim+1) shuffle groups, there are:")
    wco = zeros(Int, BASE)

    for i in 1:(lim+1)
        wco[solutions[i].witnesscount+1] += 1
    end

    println(" FacCnt  found witnesses")
    for i in 1:(BASE-1)
        cnt = wco[i+1]
        if cnt != 0
            println(lpad(commatize(i), 7), lpad(commatize(cnt), 9))
        end
    end
    println()
end

""" Output a Witness struct in formatted form """
function outwitness(n::Witness, idx::Int = 0)
    if idx > 0
        print(lpad(commatize(idx), 7))
    end
    print(lpad(commatize(n.witnesscount), 7))
    print(lpad(commatize(n.num), 14), "  ")

    for i in 2:(BASE-1)
        if i in n.witness
            print(" |x", i, lpad(commatize(i * n.num), 14))
        end
    end
    println()
end

""" Write the header for output """
writehead() = println("    idx    cnt           num   fac")

""" Print the first n solutions from the solutions vector """
function firstnsol(solutions::Vector{Witness}, cnt::Int)
    actualcount = min(cnt, length(solutions))
    println()
    println("First $actualcount shuffle groups:")
    writehead()

    for i in 1:actualcount
        outwitness(solutions[i], i)
    end
    println()
end

""" Print the first solution with more than 4 witnesses """
function firstnsolgr4(solutions::Vector{Witness})
    println("First with more than 4 witnesses:")
    writehead()

    idx = findfirst(s -> s.witnesscount > 4, solutions)

    if idx !== nothing
        outwitness(solutions[idx], idx)
    else
        println("Not found lim ", length(solutions))
    end
    println()
end

""" Print the first solution with exactly `n` witnesses """
function firstsolwithexact(solutions::Vector{Witness}, n::Int, lim::Int)
    println("First shuffle group with exactly $n witnesses")
    writehead()

    idx = findfirst(s -> s.witnesscount == n, solutions[1:min(lim+1, length(solutions))])
    if idx !== nothing
        outwitness(solutions[idx], idx)
        println()
        return idx - 1
    else
        println("Not found lim $lim")
        println()
        return 0
    end
end

""" True if two DigitsOfNumber have the same digit counts """
samendigits(a::DigitsOfNumber, b::DigitsOfNumber) = a.countofdigit == b.countofdigit

""" Populate the DigitsOfNumber struct for a given integer n """
function getdigits!(n::Integer, dignum::DigitsOfNumber)
    fill!(dignum.digit, 0)
    fill!(dignum.countofdigit, 0)
    dignum.num = n
    dignum.witness = Set{Int}()
    dignum.witnesscount = 0

    cnt = 0
    while n > 0
        n, dgt = divrem(n, BASE)
        dignum.digit[cnt+1] = dgt
        dignum.countofdigit[dgt+1] += 1
        cnt += 1
    end
    dignum.countdDigits = cnt
end

""" Update all DigitsOfNumber structs for the next digit count """
function nextdgtcnt!(test::Vector{DigitsOfNumber})
    i = test[1].num * 2 - 1
    for fac in 1:(BASE-1)
        getdigits!(fac * i, test[fac])
    end
    return BASE - 1
end

""" Increment the digits of DigitsOfNumber struct by a carry value """
function incdigits!(dignum::DigitsOfNumber, carry::Int = 1)
    dignum.num += carry
    idx = 1

    while carry != 0 && idx <= dignum.countdDigits
        dgt = dignum.digit[idx]
        dignum.countofdigit[dgt+1] -= 1

        dgt += carry
        carry = dgt >= BASE ? 1 : 0
        dgt = dgt >= BASE ? dgt - BASE : dgt

        dignum.digit[idx] = dgt
        dignum.countofdigit[dgt+1] += 1
        idx += 1
    end

    if carry != 0
        dignum.digit[idx] = carry
        dignum.countofdigit[carry+1] += 1
        dignum.countdDigits += 1
    end

    GBL_INC_COUNT[] += 1
    dignum.witness = Set{Int}()
    dignum.witnesscount = 0
end

function main()
    solutions = Vector{Witness}()
    sizehint!(solutions, 126853)

    test = [DigitsOfNumber() for _ in 1:(BASE-1)]

    total_count = 0

    # Initialize
    getdigits!(0, test[1])
    for fac in 2:(BASE-1)
        test[fac] = DigitsOfNumber()
        getdigits!(0, test[fac])
    end

    max_fac = BASE - 1

    while true
        # Increment all numbers
        for fac in 1:max_fac
            incdigits!(test[fac], fac)
        end

        # Skip numbers starting with 0
        if test[1].digit[1] == 0
            continue
        end

        # Check if we need to recalculate
        if test[1].digit[test[1].countdDigits] == BASE ÷ 2
            max_fac = nextdgtcnt!(test)
        end

        # Check if multiples share same digits
        for fac in 2:max_fac
            if test[1].countdDigits != test[fac].countdDigits
                max_fac -= 1
            end

            if samendigits(test[1], test[fac])
                push!(test[1].witness, fac)
                test[1].witnesscount += 1
            end
        end

        if test[1].witnesscount != 0
            push!(solutions, Witness(test[1].num, copy(test[1].witness), test[1].witnesscount))
            total_count += 1
        end

        if total_count > 126853 || test[1].witnesscount == 4
            break
        end
    end

    println("Use of IncDigits ", lpad(commatize(GBL_INC_COUNT[]), 16))
    println("Found solutions  ", lpad(commatize(total_count), 16))

    firstnsol(solutions, 20)
    firstnsolgr4(solutions)
    fac = firstsolwithexact(solutions, 3, total_count)
    printfirstn(solutions, fac)
    fac = firstsolwithexact(solutions, 4, total_count)
    printfirstn(solutions, fac)
end

@time main()
