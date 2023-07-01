#!/usr/bin/awk -f
{
    N = length
    for (i = 1; i <= N; ++i)
        ++H[substr($0, i, 1)]
}

END {
    for (i in H)
        S += H[i] * log(H[i])
    print (log(N) - S / N) / log(2)
}
