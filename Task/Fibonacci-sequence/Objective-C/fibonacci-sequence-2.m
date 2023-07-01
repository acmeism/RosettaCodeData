+(long)fibonacci:(int)index {
    long beforeLast = 0, last = 1;
    while (index > 0) {
        last += beforeLast;
        beforeLast = last - beforeLast;
        --index;
    }
    return last;
}
