import "./math" for Int, Nums
import "./fmt" for Fmt

class Lady {
    construct new(name) {
        _name = name
    }

    name { _name }

    // Sum the ASCII values of the characters in the ladies' names and find the digital root.
    // If it's more than 4, they're 'nice'.
    nice {
        var sum = Nums.sum(_name.bytes)
        return Int.digitalRoot(sum)[0] > 4
    }

    // Sum the ASCII values of the characters in the ladies' names.
    // If it's odd, they're 'lovable'.
    lovable {
        var sum = Nums.sum(_name.bytes)
        return sum % 2 == 1
    }

    love(s) {
        if (!(s is Sailor)) return null // indeterminate
        return nice
    }

    toString { _name }
}

class Sailor {
    construct new(name) {
        _name = name
    }

    name { _name }

    love(l) {
        if (!(l is Lady)) return null // indeterminate
        return l.lovable
    }

    toString { _name }
}

var names = ["Ada", "Crystal", "Elena", "Euphoria", "Janet", "Julia", "Lily", "Miranda", "Perl", "Ruby"]
var ladies = names.map { |n| Lady.new(n) }.toList
var sailor = Sailor.new("Pascal")
var eligibles = []
var format = "$-10s  $-12s  $s"
Fmt.print(format, "lady", "loves sailor", "lovable")
Fmt.print(format, "----", "------------", "-------")
for (lady in ladies) {
    var lovesSailor = lady.love(sailor)
    if (lovesSailor) eligibles.add(lady)
    Fmt.print(format, lady, lovesSailor, lady.lovable)
}
System.print("\nBased on this analysis:")
System.print("\nThe dating agency should suggest the following ladies:")
System.print(eligibles)
System.print("\nand %(sailor) should offer to date these ones:")
System.print(eligibles.where { |e| sailor.love(e) }.toList)
