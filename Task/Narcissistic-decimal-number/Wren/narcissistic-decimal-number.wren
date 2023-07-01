var narc = Fn.new { |n|
    var power = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    var limit = 10
    var result = []
    var x = 0
    while (result.count < n) {
        if (x >= limit) {
            for (i in 0..9) power[i] = power[i] * i
            limit = limit * 10
        }
        var sum = 0
        var xx = x
        while (xx > 0) {
            sum = sum + power[xx%10]
            xx = (xx/10).floor
        }
        if (sum == x) result.add(x)
        x = x + 1
    }
    return result
}

System.print(narc.call(25))
