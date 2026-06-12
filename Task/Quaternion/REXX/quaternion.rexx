-- 21 Feb 2026
include Setting

say 'QUATERNION TYPE'
say version
say
i = '0 1'; j = '0 0 1'; k = '0 0 0 1'
q = '1 2 3 4'; q1 = '2 3 4 5'; q2 = '3 4 5 6'; r = 7
say 'VALUES'
say 'i  =' Quat2form(i)
say 'j  =' Quat2form(j)
say 'k  =' Quat2form(k)
say 'q  =' Quat2form(q)
say 'q1 =' Quat2form(q1)
say 'q2 =' Quat2form(q2)
say 'r  =' Quat2form(r)
say
say 'BASICS'
say 'i*i   =' Quat2form(SquareH(i))
say 'j*j   =' Quat2form(SquareH(j))
say 'k*k   =' Quat2form(SquareH(k))
say 'i*j   =' Quat2form(MulH(i,j))
say '||q|| =' Std(NormH(q))
say '-q    =' Quat2form(NegH(q))
say 'q*    =' Quat2form(ConjH(q))
say 'q+r   =' Quat2form(AddH(q,r))
say 'r+q   =' Quat2form(AddH(r,q))
say 'q1+q2 =' Quat2form(AddH(q1,q2))
say 'q2+q1 =' Quat2form(AddH(q2,q1))
say 'q*r   =' Quat2form(MulH(q,r))
say 'r*q   =' Quat2form(MulH(r,q))
say 'q1*q2 =' Quat2form(MulH(q1,q2)) 'does not'
say 'q2*q1 =' Quat2form(MulH(q2,q1)) 'commute!'
say
say 'BONUS'
say '1/q   =' Quat2form(InvH(q))
say 'q1/q2 =' Quat2form(DivLeftH(q1,q2)) 'left division'
say 'q1/q2 =' Quat2form(DivRightH(q1,q2)) 'right division'
exit
-- Quat2form; AddH; SubH; MulH; InvH; DivleftH; DivrightH; NegH; ConjH; Std; NormH; SquareH
include Math
