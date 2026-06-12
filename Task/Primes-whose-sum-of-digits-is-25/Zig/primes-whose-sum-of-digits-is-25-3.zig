fn digitSum(n_: u64) u16 {
    var n = n_; // parameters are immutable, copy to var
    var sum: u16 = 0;
    while (n != 0) {
        sum += @truncate(n % 10);
        n /= 10;
    }
    return sum;
}
