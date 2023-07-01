import net.http

fn main() {
	resp := http.get("http://rosettacode.org/robots.txt") or {println(err) exit(-1)}
	println(resp.body.str())
}
