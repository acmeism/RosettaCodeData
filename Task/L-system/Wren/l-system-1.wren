import "./lsystem" for LSystem, Rule
import "./fmt" for Fmt

var lsys = LSystem.new(
    ["I", "M"],             //  variables
    [],                     //  constants
    "I",                    //  axiom
    [                       //  rules
        Rule.new("I", "M"),
        Rule.new("M", "MI")
    ]
)

System.print("Step  String")
System.print("---- --------")
var steps = lsys.listSteps(5)
for (i in 0..5) Fmt.print("$-4d $8m", i, steps[i])
