import net.urllib
fn main() {
	for escaped in [
		"http%3A%2F%2Ffoo%20bar%2F",
		"google.com/search?q=%60Abdu%27l-Bah%C3%A1",
     ] {
		u := urllib.query_unescape(escaped)?
		println(u)
	}
}
