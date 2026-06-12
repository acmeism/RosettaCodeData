#! python3

'''
    example

    $ python3 /tmp/integrate.py
    Simpson's integration of sine from 0.0 to 1.0 = 0.4596976941317858

    expected answer computed by j www.jsoftware.com

       1-&:(1&o.d._1)0
    0.459698


    translated from c
'''

import math

import collections
triple = collections.namedtuple('triple', 'm fm simp')

def _quad_simpsons_mem(f: callable, a: float , fa: float, b: float, fb: float)->tuple:
    '''
        Evaluates Simpson's Rule, also returning m and f(m) to reuse.
    '''
    m = a + (b - a) / 2
    fm = f(m)
    simp = abs(b - a) / 6 * (fa + 4*fm + fb)
    return triple(m, fm, simp,)

def _quad_asr(f: callable, a: float, fa: float, b: float, fb: float, eps: float, whole: float, m: float, fm: float)->float:
    '''
    	Efficient recursive implementation of adaptive Simpson's rule.
    	Function values at the start, middle, end of the intervals are retained.
    '''
    lt = _quad_simpsons_mem(f, a, fa, m, fm)
    rt = _quad_simpsons_mem(f, m, fm, b, fb)
    delta = lt.simp + rt.simp - whole
    return (lt.simp + rt.simp + delta/15
        if (abs(delta) <= eps * 15) else
            _quad_asr(f, a, fa, m, fm, eps/2, lt.simp, lt.m, lt.fm) +
            _quad_asr(f, m, fm, b, fb, eps/2, rt.simp, rt.m, rt.fm)
    )

def quad_asr(f: callable, a: float, b: float, eps: float)->float:
    '''
        Integrate f from a to b using ASR with max error of eps.
    '''
    fa = f(a)
    fb = f(b)
    t = _quad_simpsons_mem(f, a, fa, b, fb)
    return _quad_asr(f, a, fa, b, fb, eps, t.simp, t.m, t.fm)

def main():
    (a, b,) = (0.0, 1.0,)
    sinx = quad_asr(math.sin, a, b, 1e-09);
    print("Simpson's integration of sine from {} to {} = {}\n".format(a, b, sinx))

main()
