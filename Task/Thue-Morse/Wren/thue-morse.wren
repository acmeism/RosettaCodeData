var thueMorse = Fn.new { |n|
    var sb0 = "0"
    var sb1 = "1"
    (0...n).each { |i|
        var tmp = sb0
        sb0 = sb0 + sb1
        sb1 = sb1 + tmp
    }
    return sb0
}

for (i in 0..6) System.print("%(i) : %(thueMorse.call(i))")
