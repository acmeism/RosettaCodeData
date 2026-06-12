import "./seq" for Lst

var found = []
for (l in 1..497) {
    for (w in 1..l) {
        var lw = l * w
        if (lw >= 498) break
        for (h in 1..w) {
            var sa = (lw + w*h + h*l) * 2
            if (sa < 1000) found.add(sa) else break
        }
    }
}
var allEven = (6..998).where { |i| i%2 == 0 }.toList
System.print("All known O'Halloran numbers:")
System.print(Lst.except(allEven, found))
