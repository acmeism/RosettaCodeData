import os

enum State {
    ready
    waiting
    exit
    dispense
    refunding
}

struct VendingMachine {
mut:
    state State = .ready
}

fn (mut vm VendingMachine) fsm() {
    println("Please enter your option when prompted")
    println("(any characters after the first will be ignored)")
    for {
        match vm.state {
            .ready {
                mut trans := ""
                for {
                    print("\n(D)ispense or (Q)uit : ")
                    input := os.input("").to_lower()
                    if input.len > 0 { trans = input[0].ascii_str() }
                    if trans == "d" || trans == "q" { break }
                }
                vm.state = if trans == "d" { .waiting } else { .exit }
            }
            .waiting {
                println("OK, put your money in the slot")
                mut trans := ""
                for {
                    print("(S)elect product or choose a (R)efund : ")
                    input := os.input("").to_lower()
                    if input.len > 0 { trans = input[0].ascii_str() }
                    if trans == "s" || trans == "r" { break }
                }
                vm.state = if trans == "s" { .dispense } else { .refunding }
            }
            .dispense {
                mut trans := ""
                for {
                    print("(R)emove product : ")
                    input := os.input("").to_lower()
                    if input.len > 0 { trans = input[0].ascii_str() }
                    if trans == "r" { break }
                }
                vm.state = .ready
            }
            .refunding {
                println("OK, refunding your money")
                vm.state = .ready
            }
            .exit {
                println("OK, quitting")
                return
            }
        }
    }
}

fn main() {
    mut vm := VendingMachine{}
    vm.fsm()
}
