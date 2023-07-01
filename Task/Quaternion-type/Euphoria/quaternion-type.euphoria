function norm(sequence q)
    return sqrt(power(q[1],2)+power(q[2],2)+power(q[3],2)+power(q[4],2))
end function

function conj(sequence q)
    q[2..4] = -q[2..4]
    return q
end function

function add(object q1, object q2)
    if atom(q1) != atom(q2) then
        if atom(q1) then
            q1 = {q1,0,0,0}
        else
            q2 = {q2,0,0,0}
        end if
    end if
    return q1+q2
end function

function mul(object q1, object q2)
    if sequence(q1) and sequence(q2) then
        return { q1[1]*q2[1] - q1[2]*q2[2] - q1[3]*q2[3] - q1[4]*q2[4],
                 q1[1]*q2[2] + q1[2]*q2[1] + q1[3]*q2[4] - q1[4]*q2[3],
                 q1[1]*q2[3] - q1[2]*q2[4] + q1[3]*q2[1] + q1[4]*q2[2],
                 q1[1]*q2[4] + q1[2]*q2[3] - q1[3]*q2[2] + q1[4]*q2[1] }
    else
        return q1*q2
    end if
end function

function quats(sequence q)
    return sprintf("%g + %gi + %gj + %gk",q)
end function

constant
    q  = {1, 2, 3, 4},
    q1 = {2, 3, 4, 5},
    q2 = {5, 6, 7, 8},
    r  = 7

printf(1, "norm(q) = %g\n", norm(q))
printf(1, "-q = %s\n", {quats(-q)})
printf(1, "conj(q) = %s\n", {quats(conj(q))})
printf(1, "q + r = %s\n", {quats(add(q,r))})
printf(1, "q1 + q2 = %s\n", {quats(add(q1,q2))})
printf(1, "q1 * q2 = %s\n", {quats(mul(q1,q2))})
printf(1, "q2 * q1 = %s\n", {quats(mul(q2,q1))})
