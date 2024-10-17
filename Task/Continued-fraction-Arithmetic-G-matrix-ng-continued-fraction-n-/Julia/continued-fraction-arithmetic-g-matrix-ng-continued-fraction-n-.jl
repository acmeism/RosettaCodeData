function r2cf(n1::Integer, n2::Integer)
    ret = Int[]
    while n2 != 0
        n1, (t1, n2) = n2, divrem(n1, n2)
        push!(ret, t1)
    end
    ret
end
r2cf(r::Rational) = r2cf(numerator(r), denominator(r))

function r2cf(n1, n2, maxiter=20)
    ret = Int[]
    while n2 != 0 && maxiter > 0
        n1, (t1, n2) = n2, divrem(n1, n2)
        push!(ret, t1)
        maxiter -= 1
    end
    ret
end

mutable struct NG
    a1::Int
    a::Int
    b1::Int
    b::Int
end

function ingress(ng, n)
    ng.a, ng.a1= ng.a1, ng.a + ng.a1 * n
    ng.b, ng.b1 = ng.b1, ng.b + ng.b1 * n
end

needterm(ng) = ng.b == 0 || ng.b1 == 0 || !(ng.a // ng.b == ng.a1 // ng.b1)

function egress(ng)
    n = ng.a // ng.b
    ng.a, ng.b = ng.b, ng.a - ng.b * n
    ng.a1, ng.b1 = ng.b1, ng.a1 - ng.b1 * n
    r2cf(n)
end

egress_done(ng) = (if needterm(ng) ng.a, ng.b = ng.a1, ng.b1 end; egress(ng))

done(ng) = ng.b == 0 && ng.b1 == 0

function testng()
    data = [["[1;5,2] + 1/2",      [2,1,0,2], [13,11]],
        ["[3;7] + 1/2",        [2,1,0,2], [22, 7]],
        ["[3;7] divided by 4", [1,0,0,4], [22, 7]],
        ["[1;1] divided by sqrt(2)", [0,1,1,0], [1,sqrt(2)]]]

    for d in data
        str, ng, r = d[1], NG(d[2]...), d[3]
        print(rpad(str, 25), "->")
        for n in r2cf(r...)
            if !needterm(ng)
                print(" $(egress(ng))")
            end
            ingress(ng, n)
        end
        while true
            print(" $(egress_done(ng))")
            if done(ng)
                println()
                break
            end
        end
    end
end

testng()
