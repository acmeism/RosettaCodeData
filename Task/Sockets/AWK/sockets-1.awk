BEGIN {
    s="/inet/tcp/256/0/0"
    print strftime() |& s
    close(s)
}
