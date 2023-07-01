var cps = []
for (c in ["a", "π", "字", "🐘"]) {
    var cp = c.codePoints[0]
    cps.add(cp)
    System.print("%(c) = %(cp)")
}
System.print()
for (i in cps) {
    var c = String.fromCodePoint(i)
    System.print("%(i) = %(c)")
}
