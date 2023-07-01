import "/fmt" for Fmt

var data = [85, 88, 75, 66, 25, 29, 83, 39, 97, 68, 41, 10, 49, 16, 65, 32, 92, 28, 98]

var pick // recursive
pick = Fn.new { |at, remain, accu, treat|
    if (remain == 0) return (accu > treat) ? 1 : 0
    return pick.call(at-1, remain-1, accu + data[at-1], treat) +
           ((at > remain) ? pick.call(at-1, remain, accu, treat) : 0)
}

var treat = 0
var total = 1
for (i in 0..8)   treat = treat + data[i]
for (i in 19..11) total = total * i
for (i in 9..1)   total = total / i
var gt = pick.call(19, 9, 0, treat)
var le = (total - gt).truncate
Fmt.print("<= : $f\%  $d", 100 * le / total, le)
Fmt.print(" > : $f\%  $d", 100 * gt / total, gt)
