import "/pattern" for Pattern
import "/fmt" for Fmt

var input = "a!===b=!=c"
var p = Pattern.new("[/=/=|!/=|/=]")
var separators = p.findAll(input)
System.print("The separators matched and their starting/ending indices are:")
for (sep in separators) {
    System.print("  %(Fmt.s(-4, Fmt.q(sep.text))) between %(sep.span)")
}
var parts = p.splitAll(input)
System.print("\nThe substrings between the separators are:")
System.print(parts.map { |p| (p != "") ? Fmt.q(p) : "empty string" }.toList)
