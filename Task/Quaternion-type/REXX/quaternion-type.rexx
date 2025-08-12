-- 28 Jul 2025
include Settings

say 'QUATERNION TYPE'
say version
say
i = '0 1'; j = '0 0 1'; k = '0 0 0 1'
q = '1 2 3 4'; q1 = '2 3 4 5'; q2 = '3 4 5 6'; r = 7
say 'VALUES'
say 'i  =' Lst2FormH(i)
say 'j  =' Lst2FormH(j)
say 'k  =' Lst2FormH(k)
say 'q  =' Lst2FormH(q)
say 'q1 =' Lst2FormH(q1)
say 'q2 =' Lst2FormH(q2)
say 'r  =' Lst2FormH(r)
say
say 'BASICS'
say 'i*i   =' Lst2FormH(SquareH(i))
say 'j*j   =' Lst2FormH(SquareH(j))
say 'k*k   =' Lst2FormH(SquareH(k))
say 'i*j*k =' Lst2FormH(MulH(i,j,k))
say '||q|| =' Std(NormH(q))
say '-q    =' Lst2FormH(NegH(q))
say 'q*    =' Lst2FormH(ConjH(q))
say 'q+r   =' Lst2FormH(AddH(q,r))
say 'r+q   =' Lst2FormH(AddH(r,q))
say 'q1+q2 =' Lst2FormH(AddH(q1,q2))
say 'q2+q1 =' Lst2FormH(AddH(q2,q1))
say 'q*r   =' Lst2FormH(MulH(q,r))
say 'r*q   =' Lst2FormH(MulH(r,q))
say 'q1*q2 =' Lst2FormH(MulH(q1,q2)) 'does not'
say 'q2*q1 =' Lst2FormH(MulH(q2,q1)) 'commute!'
say
say 'BONUS'
say '1/q   =' Lst2FormH(InvH(q))
say 'q1/q2 =' Lst2FormH(DivLeftH(q1,q2)) 'left division'
say 'q1/q2 =' Lst2FormH(DivRightH(q1,q2)) 'right division'
exit

include Math
