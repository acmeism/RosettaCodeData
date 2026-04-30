import regex

fn main() {
	mut r1 := regex.regex_opt("^.*string$")!
	mut r2 := regex.regex_opt("original")!
	s1 := "I am the original string"
    s3 := "replacement"
	s2 := r2.replace(s1, s3)		
	if r1.matches_string(s1) {println("`${s1}` matches `${r1.query}`")} else {println("Failed!")}
	if s2 != s1 {println("`${s2}` replaces `${r2.query}` with `${s3}`")}
}
