def gcd
gcd = { m, n -> m = m.abs(); n = n.abs(); n == 0 ? m : m%n == 0 ? n : gcd(n, m % n) }

def lcd = { m, n -> Math.abs(m * n) / gcd(m, n) }

[[m: 12, n: 18, l: 36],
 [m: -6, n: 14, l: 42],
 [m: 35, n: 0, l: 0]].each { t ->
    println "LCD of $t.m, $t.n is $t.l"
    assert lcd(t.m, t.n) == t.l
}
