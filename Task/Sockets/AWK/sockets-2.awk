BEGIN {
    s="/inet/tcp/0/localhost/256"
    s |& getline
    print $0
    close(s)
}
