import net.http
import net.html

fn main() {
	resp := http.get("https://www.utctime.net") or {println(err) exit(-1)}
	html_doc := html.parse(resp.body)
	utc := html_doc.get_tag("table").str().split("UTC</td><td>")[1].split("</td>")[0]
	rfc_850 := html_doc.get_tag("table").str().split("RFC 850</td><td>")[1].split("</td>")[0]
	println(utc)
	println(rfc_850)
}
