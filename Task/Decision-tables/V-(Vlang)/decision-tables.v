import os

struct Condition {
    description string
    pattern     string
}

struct Action {
    description string
    pattern     string
}

fn main() {
    conditions := [
        Condition{"Printer prints", "NNNNYYYY"},
        Condition{"A red light is flashing", "YYNNYYNN"},
        Condition{"Printer is recognized by computer", "NYNYNYNY"},
    ]
    actions := [
        Action{"Check the power cable", "NNYNNNNN"},
        Action{"Check the printer-computer cable", "YNYNNNNN"},
        Action{"Ensure printer software is installed", "YNYNYNYN"},
        Action{"Check/replace ink", "YYNNNYNN"},
        Action{"Check for paper jam", "NYNYNNNN"},
    ]
    nc := conditions.len
    na := actions.len
    nr := conditions[0].pattern.len  // number of rules
    np := 7  // index of "no problem" rule
    println("Please answer the following questions with a y or n:")
    mut answers := []bool{len: nc}
    for cal in 0 .. nc {
        mut input := ""
        for {
            print("  ${conditions[cal].description} ? ")
            input = os.get_line().to_upper()
            if input == "Y" || input == "N" { break }
        }
        answers[cal] = input == "Y"
    }
    println("\nRecommended action(s):")
    outer:
	for ral in 0 .. nr {
        for cal in 0 .. nc {
            yn := if answers[cal] { `Y` } else { `N` }
            if conditions[cal].pattern[ral] != yn { continue outer }
        }
        if ral == np { println("  None (no problem detected)") }
		else {
            for val in 0 .. na {
                if actions[val].pattern[ral] == `Y` { println("  ${actions[val].description}") }
            }
        }
        return
    }
}
