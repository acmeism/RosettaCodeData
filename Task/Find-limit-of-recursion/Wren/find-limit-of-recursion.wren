var f
f = Fn.new { |n|
    if (n%500 == 0) System.print(n)  // print progress after every 500 calls
    System.write("") // required to fix a VM recursion bug
    f.call(n + 1)
}
f.call(1)
