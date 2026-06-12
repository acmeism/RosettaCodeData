"""
Copyright (c) 2005 Robert Dick <dickrp@ece.northwestern.edu>.
All rights reserved.

1. This LICENSE AGREEMENT is between Robert Dick ("AUTHOR"), and the
Individual or Organization ("Licensee") accessing and otherwise using this
software in source or binary form and its associated documentation.

2. Subject to the terms and conditions of this License Agreement, AUTHOR
hereby grants Licensee a nonexclusive, royalty-free, world-wide license to
reproduce, analyze, test, perform and/or display publicly, prepare derivative
works, distribute, and otherwise use this software alone or in any derivative
version, provided, however, that AUTHOR's License Agreement and AUTHOR's
notice of copyright, i.e., "Copyright (c) 2005 Robert Dick; All Rights
Reserved" are retained with this software, alone, or in any derivative
version prepared by Licensee.

3. In the event Licensee prepares a derivative work that is based on or
incorporates this software or any part thereof, and wants to make the
derivative work available to others as provided herein, then Licensee hereby
agrees to include in any such work a brief summary of the changes made to
this work.

4. AUTHOR is making this software available to Licensee on an "AS IS" basis.
AUTHOR MAKES NO REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED.  BY WAY OF
EXAMPLE, BUT NOT LIMITATION, AUTHOR MAKES NO AND DISCLAIMS ANY REPRESENTATION
OR WARRANTY OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE OR THAT
THE USE OF THIS SOFTWARE WILL NOT INFRINGE ANY THIRD PARTY RIGHTS.

5. AUTHOR SHALL NOT BE LIABLE TO LICENSEE OR ANY OTHER USERS OF THIS SOFTWARE
FOR ANY INCIDENTAL, SPECIAL, OR CONSEQUENTIAL DAMAGES OR LOSS AS A RESULT OF
MODIFYING, DISTRIBUTING, OR OTHERWISE USING THIS SOFTWARE, OR ANY DERIVATIVE
THEREOF, EVEN IF ADVISED OF THE POSSIBILITY THEREOF.

6. This License Agreement will automatically terminate upon a material breach
of its terms and conditions.

7. Nothing in this License Agreement shall be deemed to create any
relationship of agency, partnership, or joint venture between AUTHOR and
Licensee.  This License Agreement does not grant permission to use AUTHOR
trademarks or trade name in a trademark sense to endorse or promote products
or services of Licensee, or any third party.

8. By copying, installing or otherwise using this software, Licensee agrees
to be bound by the terms and conditions of this License Agreement.
"""

mutable struct SetType
    items::Vector{String}
    SetType() = new(String[])
end

function b2s(i::Int, vars::Int)::String
    s = ""
    for _ in 1:vars
        s = ((i & 1) == 1 ? "1" : "0") * s
        i >>= 1
    end
    return s
end

bit_count(s::String) = count(==('1'), s)

function merge(i::String, j::String)::String
    len = min(length(i), length(j))
    dif_cnt = 0
    s = ""
    for k in 1:len
        a, b = i[k], j[k]
        if a == 'X' || b == 'X'
            if a != b
                return ""
            end
            s *= a
        elseif a != b
            dif_cnt += 1
            if dif_cnt > 1
                return ""
            end
            s *= 'X'
        else
            s *= a
        end
    end
    return s
end

add_to_set!(s::SetType, item::String) = item ∉ s.items && push!(s.items, item)

in_set(s::SetType, item::String)::Bool = item ∈ s.items

union_sets!(dest::SetType, src::SetType) = for item in src.items add_to_set!(dest, item) end

function compute_primes!(cubes::SetType, vars::Int, primes::SetType)
    sigma = [SetType() for _ in 0:vars]
    sigma_count = 0

    for j in 0:vars
        for cube in cubes.items
            if bit_count(cube) == j
                add_to_set!(sigma[j+1], cube)
            end
        end
        if !isempty(sigma[j+1].items)
            sigma_count = j + 1
        end
    end

    empty!(primes.items)

    while sigma_count > 0
        nsigma = [SetType() for _ in 1:(sigma_count-1)]
        redundant = SetType()

        for i in 1:(sigma_count-1)
            c1 = sigma[i]
            c2 = sigma[i+1]
            nc = SetType()

            for a in c1.items
                for b in c2.items
                    m = merge(a, b)
                    if m != ""
                        add_to_set!(nc, m)
                        add_to_set!(redundant, a)
                        add_to_set!(redundant, b)
                    end
                end
            end
            nsigma[i] = nc
        end

        for i in 1:sigma_count
            for cube in sigma[i].items
                if !in_set(redundant, cube)
                    add_to_set!(primes, cube)
                end
            end
        end

        sigma_count = length(nsigma)
        if sigma_count > 0
            resize!(sigma, sigma_count)
            for i in 1:sigma_count
                sigma[i] = nsigma[i]
            end
        end
    end
end

function active_primes!(cubesel::Int, primes::SetType, result::SetType)
    empty!(result.items)
    s = b2s(cubesel, length(primes.items))
    for i in 1:length(primes.items)
        if s[i] == '1'
            add_to_set!(result, primes.items[i])
        end
    end
end


function is_cover(prime::String, one::String)::Bool
    len = min(length(prime), length(one))
    for i in 1:len
        p, o = prime[i], one[i]
        if p != 'X' && p != o
            return false
        end
    end
    return true
end

function is_full_cover(all_primes::SetType, ones::SetType)::Bool
    for one in ones.items
        covered = false
        for prime in all_primes.items
            if is_cover(prime, one)
                covered = true
                break
            end
        end
        if !covered
            return false
        end
    end
    return true
end

function unate_cover!(primes::SetType, ones::SetType, result::SetType)
    min_count = 1000
    min_sel = -1
    active = SetType()

    total = 1 << length(primes.items)
    for cubesel in 0:(total-1)
        active_primes!(cubesel, primes, active)
        if is_full_cover(active, ones)
            cnt = count(c -> c == '1', b2s(cubesel, length(primes.items)))
            if cnt < min_count
                min_count = cnt
                min_sel = cubesel
            end
        end
    end

    if min_sel != -1
        active_primes!(min_sel, primes, result)
    else
        empty!(result.items)
    end
end

""" Quine-McCluskey algorithm for logic minimization """
function qm(ones::Vector{Int}, zeros::Vector{Int}, dc::Vector{Int})::SetType
    result = SetType()

    if isempty(ones) && isempty(zeros) && isempty(dc)
        return result
    end

    max_val = maximum([maximum(ones; init=0), maximum(zeros; init=0), maximum(dc; init=0)])

    numvars = max_val == 0 ? 1 : ceil(Int, log2(max_val + 1))

    ones_set = SetType()
    zeros_set = SetType()
    dc_set = SetType()

    for val in ones
        add_to_set!(ones_set, b2s(val, numvars))
    end
    for val in zeros
        add_to_set!(zeros_set, b2s(val, numvars))
    end
    for val in dc
        add_to_set!(dc_set, b2s(val, numvars))
    end

    cubes = SetType()
    union_sets!(cubes, ones_set)
    union_sets!(cubes, dc_set)

    primes = SetType()
    compute_primes!(cubes, numvars, primes)

    unate_cover!(primes, ones_set, result)
    return result
end

function testqm()
    ones = [1, 2, 5]
    zeros = Int[]
    dc = [0, 7]

    result = qm(ones, zeros, dc)
    println(join(result.items, " "))
end

testqm()
