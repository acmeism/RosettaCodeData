def analytic_fibonacci91(m):
   """
   Binet's algebraic formula for the nth Fibonacci number.
   Good for up to n=91
   Uses numpy longdoubles:

   See: https://artofproblemsolving.com/wiki/index.php/Binet%27s_Formula
   """

    import numpy as np
    assert isinstance(m,int), "parameter must be an integer."
    assert 0<=m<=91 , "n must be in the range 0 .. 91 due to double precision floating point precision limitations."
    if m < 2: return m
    # Make sure that nothing causes conversion to single
    n=np.longdouble(m)
    C1=np.longdouble(1)
    C2=np.longdouble(2)
    C5=np.longdouble(5)
    Chalf=C1/C2
    Cfifth=C1/C5
    root5=C5**Chalf
    t1=(C1+root5)/C2
    t2=(C1-root5)/C2
    f=(t1**n-t2**n)/root5
    return int(f+0.1)

# Usage
print(f:=[[i,analytic_fibonacci91(i)] for i in range(92)])
