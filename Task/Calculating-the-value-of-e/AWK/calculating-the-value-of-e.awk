BEGIN {
    for (e = n = rfact = 1; rfact >= 1e-15; rfact /= ++n)
        e += rfact
    printf "e = %.15f\n", e
}
