def gen_brackets [n: int] { 1..$in | each {["[" "]"]} | flatten | shuffle | str join }

def check_brackets [] {
	split chars | reduce --fold 0 {|x, d|
		if ($d < 0) {-1} else {
			$d + (if ($x == "[") {1} else {-1})
		}
	} | $in > -1
}


1..10 | each {gen_brackets $in | {brackets: $in, valid: ($in | check_brackets)}} | print
