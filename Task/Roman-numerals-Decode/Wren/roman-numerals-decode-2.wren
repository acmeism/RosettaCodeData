import "./roman" for Roman
import "./fmt" for Fmt

var romans = ["I", "III", "IV", "VIII", "XLIX", "CCII", "CDXXXIII", "MCMXC", "MMVIII", "MDCLXVI"]
for (r in romans) {
    Fmt.print("$-10s = $d", r, Roman.new(r).toInt)
}
