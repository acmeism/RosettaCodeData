import "std/vec.zc"

struct Lady {
    name: string;
}

struct Sailor {
    name: string;
}

fn digit_sum(n: int) -> int {
    let sum = 0;
    while n > 0 {
        sum += n % 10;
        n /= 10;
    }
    return sum
}

fn digital_root(n: int) -> int {
    while n > 9 { n = digit_sum(n); }
    return n;
}

fn sum_bytes(s: string) -> int {
    let sum = 0;
    for i in 0..strlen(s) { sum += s[i]; }
    return sum;
}

fn btos(b: bool) -> string {
    return b ? "true" : "false";
}

impl Lady {
    // Sum the ASCII values of the characters in the ladies' names
    // and find the digital root. If it's more than 4, they're 'nice'.
    fn is_nice(self) -> bool {
        let sum = sum_bytes(self.name);
        return digital_root(sum) > 4;
    }

    // Sum the ASCII values of the characters in the ladies' names.
    // If it's odd, they're 'lovable'.
    fn is_lovable(self) -> bool {
        let sum = sum_bytes(self.name);
        return sum & 1;
    }

    fn loves(self, _: Sailor) -> bool {
        return self.is_nice();
    }
}

impl Sailor {
    fn loves(self, l: Lady) -> bool {
        return l.is_lovable();
    }
}

fn main() {
    let names = ["Ada", "Crystal", "Elena", "Euphoria", "Janet", "Julia", "Lily", "Miranda", "Perl", "Ruby"];
    let ladies = Vec<Lady>::new();
    for name in names { ladies.push(Lady{name: name}); }
    let sailor = Sailor{name: "Pascal"};
    let eligibles = Vec<Lady>::new();
    let format = "%-10s  %-12s  %s\n";
    printf(format, "lady", "loves sailor", "lovable");
    printf(format, "----", "------------", "-------");
    for lady in ladies {
        let loves_sailor = lady.loves(sailor);
        if loves_sailor { eligibles.push(lady); }
        printf(format, lady.name, btos(loves_sailor), btos(lady.is_lovable()));
    }
    println "\nBased on this analysis:";
    println "\nThe dating agency should suggest the following ladies:";
    for eligible in eligibles { print "{eligible.name}, "; }
    println "\b\b ";
    println "\nand {sailor.name} should offer to date these ones:";
    for eligible in eligibles {
        if sailor.loves(eligible) { print "{eligible.name}, "; }
    }
    println "\b\b ";
}
