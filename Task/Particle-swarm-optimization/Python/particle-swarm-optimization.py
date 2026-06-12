import math
import random

INFINITY = 1 << 127
MAX_INT = 1 << 31

class Parameters:
    def __init__(self, omega, phip, phig):
        self.omega = omega
        self.phip = phip
        self.phig = phig

class State:
    def __init__(self, iter, gbpos, gbval, min, max, parameters, pos, vel, bpos, bval, nParticles, nDims):
        self.iter = iter
        self.gbpos = gbpos
        self.gbval = gbval
        self.min = min
        self.max = max
        self.parameters = parameters
        self.pos = pos
        self.vel = vel
        self.bpos = bpos
        self.bval = bval
        self.nParticles = nParticles
        self.nDims = nDims

    def report(self, testfunc):
        print("Test Function :", testfunc)
        print("Iterations    :", self.iter)
        print("Global Best Position :", self.gbpos)
        print("Global Best Value    : %.16f" % self.gbval)

def uniform01():
    v = random.random()
    assert 0.0 <= v and v < 1.0
    return v

def psoInit(min, max, parameters, nParticles):
    nDims = len(min)
    pos = [min[:]] * nParticles
    vel = [[0.0] * nDims] * nParticles
    bpos = [min[:]] * nParticles
    bval = [INFINITY] * nParticles
    iter = 0
    gbpos = [INFINITY] * nDims
    gbval = INFINITY
    return State(iter, gbpos, gbval, min, max, parameters, pos, vel, bpos, bval, nParticles, nDims);

def pso(fn, y):
    p = y.parameters
    v = [0.0] * (y.nParticles)
    bpos = [y.min[:]] * (y.nParticles)
    bval = [0.0] * (y.nParticles)
    gbpos = [0.0] * (y.nDims)
    gbval = INFINITY
    for j in range(y.nParticles):
        # evaluate
        v[j] = fn(y.pos[j])
        # update
        if v[j] < y.bval[j]:
            bpos[j] = y.pos[j][:]
            bval[j] = v[j]
        else:
            bpos[j] = y.bpos[j][:]
            bval[j] = y.bval[j]
        if bval[j] < gbval:
            gbval = bval[j]
            gbpos = bpos[j][:]
    rg = uniform01()
    pos = [[None] * (y.nDims)] * (y.nParticles)
    vel = [[None] * (y.nDims)] * (y.nParticles)
    for j in range(y.nParticles):
        # migrate
        rp = uniform01()
        ok = True
        vel[j] = [0.0] * (len(vel[j]))
        pos[j] = [0.0] * (len(pos[j]))
        for k in range(y.nDims):
            vel[j][k] = p.omega * y.vel[j][k] \
                      + p.phip * rp * (bpos[j][k] - y.pos[j][k]) \
                      + p.phig * rg * (gbpos[k] - y.pos[j][k])
            pos[j][k] = y.pos[j][k] + vel[j][k]
            ok = ok and y.min[k] < pos[j][k] and y.max[k] > pos[j][k]
        if not ok:
            for k in range(y.nDims):
                pos[j][k] = y.min[k] + (y.max[k] - y.min[k]) * uniform01()
    iter = 1 + y.iter
    return State(iter, gbpos, gbval, y.min, y.max, y.parameters, pos, vel, bpos, bval, y.nParticles, y.nDims);

def iterate(fn, n, y):
    r = y
    old = y
    if n == MAX_INT:
        while True:
            r = pso(fn, r)
            if r == old:
                break
            old = r
    else:
        for _ in range(n):
            r = pso(fn, r)
    return r

def mccormick(x):
    (a, b) = x
    return math.sin(a + b) + (a - b) * (a - b) + 1.0 + 2.5 * b - 1.5 * a

def michalewicz(x):
    m = 10
    d = len(x)
    sum = 0.0
    for i in range(1, d):
        j = x[i - 1]
        k = math.sin(i * j * j / math.pi)
        sum += math.sin(j) * k ** (2.0 * m)
    return -sum

def main():
    state = psoInit([-1.5, -3.0], [4.0, 4.0], Parameters(0.0, 0.6, 0.3), 100)
    state = iterate(mccormick, 40, state)
    state.report("McCormick")
    print("f(-.54719, -1.54719) : %.16f" % (mccormick([-.54719, -1.54719])))

    print()

    state = psoInit([0.0, 0.0], [math.pi, math.pi], Parameters(0.3, 0.3, 0.3), 1000)
    state = iterate(michalewicz, 30, state)
    state.report("Michalewicz (2D)")
    print("f(2.20, 1.57)        : %.16f" % (michalewicz([2.2, 1.57])))

main()
