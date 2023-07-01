proc num2bin num {
    # Convert to _fixed width_ big-endian 32-bit binary
    binary scan [binary format "I" $num] "B*" binval
    # Strip useless leading zeros by reinterpreting as a big decimal integer
    scan $binval "%lld"
}
