"""
    struct ConvexRealSet
Convex real set (similar to a line segment).
Parameters: lower bound, upper bound: floating point numbers
            includelower, includeupper: boolean true or false to indicate whether
            the set has a closed boundary (set to true) or open (set to false).
"""
mutable struct ConvexRealSet
    lower::Float64
    includelower::Bool
    upper::Float64
    includeupper::Bool
    function ConvexRealSet(lo, up, incllo, inclup)
       this = new()
       this.upper = Float64(up)
       this.lower = Float64(lo)
       this.includelower = incllo
       this.includeupper = inclup
       this
    end
end


function ∈(s, xelem)
    x = Float64(xelem)
    if(x == s.lower)
        if(s.includelower)
            return true
        else
            return false
        end
    elseif(x == s.upper)
        if(s.includeupper)
            return true
        else
            return false
        end
    end
    s.lower < x && x < s.upper
end


⋃(aset, bset, x) = (∈(aset, x) || ∈(bset, x))

⋂(aset, bset, x) = (∈(aset, x) && ∈(bset, x))

-(aset, bset, x) = (∈(aset, x) && !∈(bset, x))

isempty(s::ConvexRealSet) = (s.lower > s.upper) ||
                           ((s.lower == s.upper) && !s.includeupper && !s.includelower)


const s1 = ConvexRealSet(0.0, 1.0, false, true)
const s2 = ConvexRealSet(0.0, 2.0, true, false)
const s3 = ConvexRealSet(1.0, 2.0, false, true)
const s4 = ConvexRealSet(0.0, 3.0, true, false)
const s5 = ConvexRealSet(0.0, 1.0, false, false)
const s6 = ConvexRealSet(0.0, 1.0, true, true)
const sempty = ConvexRealSet(0.0, -1.0, true, true)
const testlist = [0, 1, 2]


function testconvexrealset()
    for i in testlist
        println("Testing with x = $i.\nResults:")
        println("    (0, 1] ∪ [0, 2): $(⋃(s1, s2, i))")
        println("    [0, 2) ∩ (1, 2]: $(⋂(s2, s3, i))")
        println("    [0, 3) − (0, 1): $(-(s4, s5, i))")
        println("    [0, 3) − [0, 1]: $(-(s4, s6, i))\n")
    end
    print("The set sempty is ")
    println(isempty(sempty) ? "empty." : "not empty.")
end


testconvexrealset()
