def rosetta := setupProbabilisticChoice(entropy, def probTable := [
    "aleph"  => 1/5,
    "beth"   => 1/6.0,
    "gimel"  => 1/7.0,
    "daleth" => 1/8.0,
    "he"     => 1/9.0,
    "waw"    => 1/10.0,
    "zayin"  => 1/11.0,
    "heth"   => 0.063455988455988432,
])

var trials := 1000000
var timesFound := [].asMap()
for i in 1..trials {
    if (i % 1000 == 0) { print(`${i//1000} `) }
    def value := rosetta()
    timesFound with= (value, timesFound.fetch(value, fn { 0 }) + 1)
}
stdout.println()
for item in probTable.domain() {
    stdout.print(item, "\t", timesFound[item] / trials, "\t", probTable[item], "\n")
}
