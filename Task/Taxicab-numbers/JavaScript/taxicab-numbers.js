var n3s = [],
    s3s = {}
for (var n = 1, e = 1200; n < e; n += 1) n3s[n] = n * n * n
for (var a = 1; a < e - 1; a += 1) {
    var a3 = n3s[a]
    for (var b = a; b < e; b += 1) {
        var b3 = n3s[b]
        var s3 = a3 + b3,
            abs = s3s[s3]
        if (!abs) s3s[s3] = abs = []
        abs.push([a, b])
    }
}

var i = 0
for (var s3 in s3s) {
    var abs = s3s[s3]
    if (abs.length < 2) continue
    i += 1
    if (abs.length == 2 && i > 25 && i < 2000) continue
    if (i > 2006) break
    document.write(i, ': ', s3)
    for (var ab of abs) {
        document.write(' = ', ab[0], '<sup>3</sup>+', ab[1], '<sup>3</sup>')
    }
    document.write('<br>')
}
