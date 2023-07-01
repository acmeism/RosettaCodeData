{
    ("echo -n " $0 " | sha256sum") | getline sha;
    gsub(/[^0-9a-zA-Z]/, "", sha);
    print sha;
}
