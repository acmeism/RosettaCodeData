-- 19 May 2025
include Settings

say 'QUATERNION TYPE'
say version
say
i = '0 1'; j = '0 0 1'; k = '0 0 0 1'
q = '1 2 3 4'; q1 = '2 3 4 5'; q2 = '3 4 5 6'; r = 7
say 'VALUES'
say 'i  =' Hlst2Form(i)
say 'j  =' Hlst2Form(j)
say 'k  =' Hlst2Form(k)
say 'q  =' Hlst2Form(q)
say 'q1 =' Hlst2Form(q1)
say 'q2 =' Hlst2Form(q2)
say 'r  =' Hlst2Form(r)
say
say 'BASICS'
say 'i*i   =' Hlst2Form(Hsquare(i))
say 'j*j   =' Hlst2Form(Hsquare(j))
say 'k*k   =' Hlst2Form(Hsquare(k))
say 'i*j*k =' Hlst2Form(Hmul(i,j,k))
say '||q|| =' Std(Hnorm(q))
say '-q    =' Hlst2Form(Hneg(q))
say 'q*    =' Hlst2Form(Hconj(q))
say 'q+r   =' Hlst2Form(Hadd(q,r))
say 'r+q   =' Hlst2Form(Hadd(r,q))
say 'q1+q2 =' Hlst2Form(Hadd(q1,q2))
say 'q2+q1 =' Hlst2Form(Hadd(q2,q1))
say 'q*r   =' Hlst2Form(Hmul(q,r))
say 'r*q   =' Hlst2Form(Hmul(r,q))
say 'q1*q2 =' Hlst2Form(Hmul(q1,q2))
say 'q2*q1 =' Hlst2Form(Hmul(q2,q1))
say
say 'BONUS'
say 'q/r   =' Hlst2Form(Hdiv(q,r))
say '1/q   =' Hlst2Form(Hinv(q))
exit

include Quaternion
include Functions
include Abend
