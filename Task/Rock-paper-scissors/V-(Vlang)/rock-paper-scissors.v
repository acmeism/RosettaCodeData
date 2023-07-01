import rand
import os

const (
	rps = 'rps'
	msg = [
    'Rock breaks scissors',s
    'Paper covers rock',
    'Scissors cut paper'
	]
)

fn main() {
    println("Rock Paper Scissors")
    println("Enter r, p, or s as your play.  Anything else ends the game.")
    println("Running score shown as <your wins>:<my wins>")
    mut pi :='' // player input
    mut a_score, mut p_score  := 0, 0
    mut pcf := []int{len: 2, init: 0} // pcf = player choice frequency
    mut a_choice := rand.intn(3) or {0} // ai choice for first play is completely random	
    for _ in 0..6 {
		// get player choice
		pi = os.input('Play: ').str()
		if typeof(pi).name != 'string' || pi.len != 1 {break}
        p_choice := rps.index_any(pi)
        if p_choice < 0 {break}
        pcf << p_choice
        // show result of play
        println('My play: ' + rps[a_choice].ascii_str())
        match (a_choice - p_choice + 3) % 3 {
            0 {println("Tie.")}
            1 {println('My point.\n' + msg[a_choice]) a_score++}
            2 {println('Your point.\n' + msg[p_choice]) p_score++}
            else {break}
        }
        // show score
        println('$p_score : $a_score')
        // compute ai choice for next play
		rn := rand.intn(3) or {0}
		match true {
				rn < pcf[0] {a_choice = 2}
				rn < pcf[0] + pcf[1] {a_choice = 0}
				else {a_choice = rand.intn(3) or {0}}
		}
    }	
}
