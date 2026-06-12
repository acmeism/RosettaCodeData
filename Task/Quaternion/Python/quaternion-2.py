>>> q
Quaternion(real=1.0, i=2.0, j=3.0, k=4.0)
>>> q1
Quaternion(real=2.0, i=3.0, j=4.0, k=5.0)
>>> q2
Quaternion(real=3.0, i=4.0, j=5.0, k=6.0)
>>> r
7
>>> q.norm()
5.477225575051661
>>> q1.norm()
7.3484692283495345
>>> q2.norm()
9.273618495495704
>>> -q
Quaternion(real=-1.0, i=-2.0, j=-3.0, k=-4.0)
>>> q.conjugate()
Quaternion(real=1.0, i=-2.0, j=-3.0, k=-4.0)
>>> r + q
Quaternion(real=8.0, i=2.0, j=3.0, k=4.0)
>>> q + r
Quaternion(real=8.0, i=2.0, j=3.0, k=4.0)
>>> q1 + q2
Quaternion(real=5.0, i=7.0, j=9.0, k=11.0)
>>> q2 + q1
Quaternion(real=5.0, i=7.0, j=9.0, k=11.0)
>>> q * r
Quaternion(real=7.0, i=14.0, j=21.0, k=28.0)
>>> r * q
Quaternion(real=7.0, i=14.0, j=21.0, k=28.0)
>>> q1 * q2
Quaternion(real=-56.0, i=16.0, j=24.0, k=26.0)
>>> q2 * q1
Quaternion(real=-56.0, i=18.0, j=20.0, k=28.0)
>>> assert q1 * q2 != q2 * q1
>>>
>>> i, j, k = Q(0,1,0,0), Q(0,0,1,0), Q(0,0,0,1)
>>> i*i
Quaternion(real=-1.0, i=0.0, j=0.0, k=0.0)
>>> j*j
Quaternion(real=-1.0, i=0.0, j=0.0, k=0.0)
>>> k*k
Quaternion(real=-1.0, i=0.0, j=0.0, k=0.0)
>>> i*j*k
Quaternion(real=-1.0, i=0.0, j=0.0, k=0.0)
>>> q1 / q2
Quaternion(real=0.7906976744186047, i=0.023255813953488358, j=-2.7755575615628914e-17, k=0.046511627906976744)
>>> q1 / q2 * q2
Quaternion(real=2.0000000000000004, i=3.0000000000000004, j=4.000000000000001, k=5.000000000000001)
>>> q2 * q1 / q2
Quaternion(real=2.0, i=3.465116279069768, j=3.906976744186047, k=4.767441860465116)
>>> q1.reciprocal() * q1
Quaternion(real=0.9999999999999999, i=0.0, j=0.0, k=0.0)
>>> q1 * q1.reciprocal()
Quaternion(real=0.9999999999999999, i=0.0, j=0.0, k=0.0)
>>>
