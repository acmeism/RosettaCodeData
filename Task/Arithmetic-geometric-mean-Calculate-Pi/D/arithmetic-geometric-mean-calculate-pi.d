import std.bigint;
import std.conv;
import std.math;
import std.stdio;

BigInt IntSqRoot(BigInt value, BigInt guess) {
    BigInt term;
    do {
        term = value / guess;
        auto temp = term - guess;
        if (temp < 0) {
            temp = -temp;
        }
        if (temp <= 1) {
            break;
        }
        guess += term;
        guess >>= 1;
        term = value / guess;
    } while (true);
    return guess;
}

BigInt ISR(BigInt term, BigInt guess) {
    BigInt value = term * guess;
    do {
        auto temp = term - guess;
        if (temp < 0) {
            temp = -temp;
        }
        if (temp <= 1) {
            break;
        }
        guess += term;
        guess >>= 1;
        term = value / guess;
    } while (true);
    return guess;
}

BigInt CalcAGM(BigInt lam, BigInt gm, ref BigInt z, BigInt ep) {
    BigInt am, zi;
    ulong n = 1;
    do {
        am = (lam + gm) >> 1;
        gm = ISR(lam, gm);
        BigInt v = am - lam;
        if ((zi = v * v * n) < ep) {
            break;
        }
        z -= zi;
        n <<= 1;
        lam = am;
    } while(true);
    return am;
}

BigInt BIP(int exp, ulong man = 1) {
    BigInt rv = BigInt(10) ^^ exp;
    return man == 1 ? rv : man * rv;
}

void main() {
    int d = 25000;
    // ignore setting d from commandline for now
    BigInt am = BIP(d);
    BigInt gm = IntSqRoot(BIP(d + d - 1, 5), BIP(d - 15, cast(ulong)(sqrt(0.5) * 1e15)));
    BigInt z = BIP(d + d - 2, 25);
    BigInt agm = CalcAGM(am, gm, z, BIP(d + 1));
    BigInt pi = agm * agm * BIP(d - 2) / z;

    string piStr = to!string(pi);
    writeln(piStr[0], '.', piStr[1..$]);
}
