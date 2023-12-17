var F = Fn.new { |n|
    if (n%500 == 0) System.print(n)  // print progress after every 500 calls
    F.call(n + 1)
}
F.call(1)
