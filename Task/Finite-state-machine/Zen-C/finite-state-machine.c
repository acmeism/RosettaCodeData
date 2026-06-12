import "ctype.h"

def READY     = 0;
def WAITING   = 1;
def EXIT      = 2;
def DISPENSE  = 3;
def REFUNDING = 4;

fn fsm() {
    println "Please enter your option when prompted";
    println "(any characters after the first will be ignored)";
    let state = READY;
    let input: char[10];
    let trans: int;
    loop {
        match state {
            READY => {
                do {
                    ? "\n(D)ispense or (Q)uit : " (input);
                    trans = tolower(input[0]);
                } while trans != 'd' && trans != 'q';
                state = (trans == 'd') ? WAITING : EXIT;
            },
            WAITING => {
                println "OK, put your money in the slot";
                do {
                    ? "(S)elect product or choose a (R)efund : " (input);
                    trans = tolower(input[0]);
                } while trans != 's' && trans != 'r';
                state = (trans == 's') ? DISPENSE : REFUNDING ;
            },
            DISPENSE => {
                do {
                    ? "(R)emove product : " (input);
                    trans = tolower(input[0]);
                } while trans != 'r' ;
                state = READY;
            },
            REFUNDING => {
                // No transitions defined.
                println "OK, refunding your money";
                state = READY;
            },
            EXIT => {
                println "OK, quitting";
                return;
            }
        }
    }
}

fn main() {
    fsm();
}
