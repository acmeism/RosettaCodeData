import regex

const (
    inc = [
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
        [0, 2, 4, 6, 8, 1, 3, 5, 7, 9],
    ]
)

fn valid_isin(n string) bool {
    mut r,_,_ := regex.regex_base('^[A-Z]{2}[A-Z0-9]{9}\d$')
    if !r.matches_string(n) {
        return false
    }
    mut sum := 0
    mut p := 0
    for i := 10; i >= 0; i-- {
        p = 1 - p
        mut d := n[i..i+1].int()
        if d < 'A'.int() {
            sum += inc[p][d-'0'.int()]
        } else {
            d -= 'A'.int()
            sum += inc[p][d%10]
            p = 1 - p
            sum += inc[p][d/10+1]
        }
    }
    sum += n[11..12].int() - '0'.int()
    return sum%10 == 0
}

struct Testcases {
    isin string
    valid bool
}

fn main(){
    testcases := [
        Testcases{"US0378331005", true},
        Testcases{"US0373831005", false},
        Testcases{"U50378331005", false},
        Testcases{"US03378331005", false},
        Testcases{"AU0000XVGZA3", true},
        Testcases{"AU0000VXGZA3", true},
        Testcases{"FR0000988040", true},
    ]

    for testcase in testcases {
        actual := valid_isin(testcase.isin)
        if actual != testcase.valid {
            println("expected ${testcase.valid} for ${testcase.isin}, got $actual")
        }
    }
}
