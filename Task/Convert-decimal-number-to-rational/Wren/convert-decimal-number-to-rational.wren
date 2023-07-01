import "/rat" for Rat
import "/fmt" for Fmt

var tests = [0.9054054, 0.518518, 0.75]
for (test in tests) {
    var r = Rat.fromFloat(test)
    System.print("%(Fmt.s(-9, test)) -> %(r)")
}
