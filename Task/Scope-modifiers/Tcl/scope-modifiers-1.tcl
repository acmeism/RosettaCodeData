set globalVar "This is a global variable"
namespace eval nsA {
    variable varInA "This is a variable in nsA"
}
namespace eval nsB {
    variable varInB "This is a variable in nsB"
    proc showOff {varname} {
        set localVar "This is a local variable"
        global globalVar
        variable varInB
        namespace upvar ::nsA varInA varInA
        puts "variable $varname holds \"[set $varname]\""
    }
}
nsB::showOff globalVar
nsB::showOff varInA
nsB::showOff varInB
nsB::showOff localVar
