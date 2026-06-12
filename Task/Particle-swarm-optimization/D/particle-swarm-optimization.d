import std.math;
import std.random;
import std.stdio;

alias Func = double function(double[]);

struct Parameters {
    double omega, phip, phig;
}

struct State {
    int iter;
    double[] gbpos;
    double gbval;
    double[] min;
    double[] max;
    Parameters parameters;
    double[][] pos;
    double[][] vel;
    double[][] bpos;
    double[] bval;
    ulong nParticles;
    ulong nDims;

    void report(string testfunc) {
        writeln("Test Function        : ", testfunc);
        writeln("Iterations           : ", iter);
        writefln("Global Best Position : [%(%.16f, %)]", gbpos);
        writefln("Global Best Value    : %.16f", gbval);
    }
}

State psoInit(double[] min, double[] max, Parameters parameters, ulong nParticles) {
    auto nDims = min.length;
    double[][] pos;
    pos.length = nParticles;
    pos[] = min;
    double[][] vel;
    vel.length = nParticles;
    for (int i; i<nParticles; i++) vel[i].length = nDims;
    double[][] bpos;
    bpos.length = nParticles;
    bpos[] = min;
    double[] bval;
    bval.length = nParticles;
    bval[] = double.infinity;
    auto iter = 0;
    double[] gbpos;
    gbpos.length = nDims;
    gbpos[] = double.infinity;
    auto gbval = double.infinity;
    return State(iter, gbpos, gbval, min, max, parameters, pos, vel, bpos, bval, nParticles, nDims);
}

State pso(Func fn, State y) {
    auto p = y.parameters;
    double[] v;
    v.length = y.nParticles;
    double[][] bpos;
    bpos.length = y.nParticles;
    bpos[] = y.min;
    double[] bval;
    bval.length = y.nParticles;
    double[] gbpos;
    gbpos.length = y.nDims;
    auto gbval = double.infinity;
    foreach (j; 0..y.nParticles) {
        // evaluate
        v[j] = fn(y.pos[j]);
        // update
        if (v[j] < y.bval[j]) {
            bpos[j] = y.pos[j];
            bval[j] = v[j];
        } else {
            bpos[j] = y.bpos[j];
            bval[j] = y.bval[j];
        }
        if (bval[j] < gbval) {
            gbval = bval[j];
            gbpos = bpos[j];
        }
    }
    auto rg = uniform01();
    double[][] pos;
    pos.length = y.nParticles;
    for (int i; i<pos.length; i++) pos[i].length = y.nDims;
    double[][] vel;
    vel.length = y.nParticles;
    for (int i; i<vel.length; i++) vel[i].length = y.nDims;
    foreach (j; 0..y.nParticles) {
        // migrate
        auto rp = uniform01();
        bool ok = true;
        vel[j][] = 0;
        pos[j][] = 0;
        foreach (k; 0..y.nDims) {
            vel[j][k] = p.omega * y.vel[j][k] +
                        p.phip * rp * (bpos[j][k] - y.pos[j][k]) +
                        p.phig * rg * (gbpos[k] - y.pos[j][k]);
            pos[j][k] = y.pos[j][k] + vel[j][k];
            ok = ok && y.min[k] < pos[j][k] && y.max[k] > pos[j][k];
        }
        if (!ok) {
            foreach (k; 0..y.nDims) {
                pos[j][k] = y.min[k] + (y.max[k] - y.min[k]) * uniform01();
            }
        }
    }
    auto iter = 1 + y.iter;
    return State(iter, gbpos, gbval, y.min, y.max, y.parameters, pos, vel, bpos, bval, y.nParticles, y.nDims);
}

State iterate(Func fn, int n, State y) {
    auto r = y;
    auto old = y;
    if (n == int.max) {
        while (true) {
            r = pso(fn, r);
            if (r == old) break;
            old = r;
        }
    } else {
        foreach (_; 0..n) r = pso(fn, r);
    }
    return r;
}

double mccormick(double[] x) {
    auto a = x[0];
    auto b = x[1];
    return sin(a + b) + (a - b) * (a - b) + 1.0 + 2.5 * b - 1.5 * a;
}

double michalewicz(double[] x) {
    auto m = 10;
    auto d = x.length;
    auto sum = 0.0;
    foreach (i; 1..d) {
        auto j = x[i - 1];
        auto k = sin(i * j * j / PI);
        sum += sin(j) * k^^(2.0*m);
    }
    return -sum;
}

void main() {
    auto state = psoInit(
        [-1.5, -3.0],
        [4.0, 4.0],
        Parameters(0.0, 0.6, 0.3),
        100
    );
    state = iterate(&mccormick, 40, state);
    state.report("McCormick");
    writefln("f(-.54719, -1.54719) : %.16f", mccormick([-.54719, -1.54719]));
    writeln;
    state = psoInit(
        [0.0, 0.0],
        [PI, PI],
        Parameters(0.3, 0.3, 0.3),
        1000
    );
    state = iterate(&michalewicz, 30, state);
    state.report("Michalewicz (2D)");
    writefln("f(2.20, 1.57)        : %.16f", michalewicz([2.2, 1.57]));
}
