import core.stdc.stdio: printf;
import core.stdc.stdlib: atoi;

__gshared ulong[] g_pnCountNH;
__gshared uint[] g_pnFieldCheck, g_pnFieldCheckR;
__gshared uint g_nFieldSize, g_nFieldWidth;
__gshared uint[4] g_anLinkData;
__gshared uint[8] g_anRotationOffset, g_anRotationX, g_anRotationY;

void countMain(in uint n) nothrow {
    g_nFieldWidth = n * 2 - 2;
    g_nFieldSize = (n - 1) * (n - 1) * 2 + 1;
    g_pnCountNH = new ulong[n + 1];

    auto pnField = new uint[g_nFieldSize];
    auto pnPutList = new uint[g_nFieldSize];
    g_pnFieldCheck = new uint[n ^^ 2];
    g_pnFieldCheckR = new uint[n ^^ 2];
    g_anLinkData[0] = 1;
    g_anLinkData[1] = g_nFieldWidth;
    g_anLinkData[2] = -1;
    g_anLinkData[3] = -g_nFieldWidth;

    initOffset(n);

    countSub(n, 0, pnField, pnPutList, 0, 1);
}

void countSub(in uint n, in uint lv, uint[] field, uint[] putlist,
              in uint putno, in uint putlast) nothrow @nogc {
    check(field, n, lv);
    if (n == lv) {
        return;
    }

    foreach (immutable uint i; putno .. putlast) {
        immutable pos = putlist[i];
        field[pos] |= 1;
        uint k = 0;
        foreach (immutable uint j; 0 .. 4) {
            immutable pos2 = pos + g_anLinkData[j];
            if (0 <= pos2 && pos2 < g_nFieldSize && !field[pos2]) {
                field[pos2] = 2;
                putlist[putlast + k] = pos2;
                k++;
            }
        }
        countSub(n, lv + 1, field, putlist, i + 1, putlast + k);
        foreach (immutable uint j; 0 .. k)
            field[putlist[putlast + j]] = 0;
        field[pos] = 2;
    }

    foreach (immutable uint i; putno .. putlast) {
        immutable pos = putlist[i];
        field[pos] &= -2;
    }
}

void initOffset(in uint n) nothrow @nogc {
    g_anRotationOffset[0] = 0;
    g_anRotationX[0] = 1;
    g_anRotationY[0] = n;
    // 90
    g_anRotationOffset[1] = n - 1;
    g_anRotationX[1] = n;
    g_anRotationY[1] = -1;
    // 180
    g_anRotationOffset[2] = n ^^ 2 - 1;
    g_anRotationX[2] = -1;
    g_anRotationY[2] = -n;
    // 270
    g_anRotationOffset[3] = n ^^ 2 - n;
    g_anRotationX[3] = -n;
    g_anRotationY[3] = 1;

    g_anRotationOffset[4] = n - 1;
    g_anRotationX[4] = -1;
    g_anRotationY[4] = n;
    // 90
    g_anRotationOffset[5] = 0;
    g_anRotationX[5] = n;
    g_anRotationY[5] = 1;
    // 180
    g_anRotationOffset[6] = n ^^ 2 - n;
    g_anRotationX[6] = 1;
    g_anRotationY[6] = -n;
    // 270
    g_anRotationOffset[7] = n ^^ 2 - 1;
    g_anRotationX[7] = -n;
    g_anRotationY[7] = -1;
}

void check(in uint[] field, in uint n, in uint lv) nothrow @nogc {
    g_pnFieldCheck[0 .. n ^^ 2] = 0;

    uint x, y;
    outer:
    for (x = n; x < n * 2 - 2; x++)
        for (y = 0; y + x < g_nFieldSize; y += g_nFieldWidth)
            if (field[x + y] & 1)
                break outer;

    immutable uint x2 = n - x;
    foreach (immutable uint i; 0 .. g_nFieldSize) {
        x = (i + n - 2) % g_nFieldWidth;
        y = (i + n - 2) / g_nFieldWidth * n;
        if (field[i] & 1)
            g_pnFieldCheck[x + x2 + y] = 1;
    }

    uint of1;
    for (of1 = 0; of1 < g_pnFieldCheck.length && !g_pnFieldCheck[of1]; of1++) {}

    bool c = true;
    for (uint r = 1; r < 8 && c; r++) {
        for (x = 0; x < n; x++) {
            for (y = 0; y < n; y++) {
                immutable pos = g_anRotationOffset[r] +
                                g_anRotationX[r] * x + g_anRotationY[r] * y;
                g_pnFieldCheckR[pos] = g_pnFieldCheck[x + y * n];
            }
        }

        uint of2;
        for (of2 = 0; of2 < g_pnFieldCheckR.length && !g_pnFieldCheckR[of2]; of2++) {}
        of2 -= of1;
        immutable ed = (of2 > 0) ? (n ^^ 2 - of2) : (n ^^ 2);

        foreach (immutable uint i; of1 .. ed) {
            if (g_pnFieldCheck[i] > g_pnFieldCheckR[i + of2])
                break;
            if (g_pnFieldCheck[i] < g_pnFieldCheckR[i + of2]) {
                c = false;
                break;
            }
        }
    }

    if (c) {
        uint parity;
        if (!(lv & 1)) {
            parity = (lv & 2) >> 1;
            for (x = 0; x < n; x++)
                for (y = 0; y < n; y++)
                    parity ^= (x + y) & g_pnFieldCheck[x + y * n];
            parity &= 1;
        } else
            parity = 0;

        g_pnCountNH[lv]++;
    }
}

int main(in string[] args) {
    immutable n = (args.length == 2) ? (args[1] ~ '\0').ptr.atoi : 11;
    if (n < 1)
        return 1;

    if (n == 1)
        countMain(2);
    else
        countMain(n);

    foreach (immutable i; 1 .. n + 1)
        printf("%llu\n", g_pnCountNH[i]);

    return 0;
}
