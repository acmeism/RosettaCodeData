use url::Url;

fn print_fields(url: Url) -> () {
    println!("scheme: {}", url.scheme());
    println!("username: {}", url.username());

    if let Some(password) = url.password() {
        println!("password: {}", password);
    }

    if let Some(domain) = url.domain() {
        println!("domain: {}", domain);
    }

    if let Some(port) = url.port() {
        println!("port: {}", port);
    }
    println!("path: {}", url.path());

    if let Some(query) = url.query() {
        println!("query: {}", query);
    }

    if let Some(fragment) = url.fragment() {
        println!("fragment: {}", fragment);
    }
}
fn main() {
    let urls = vec![
        "foo://example.com:8042/over/there?name=ferret#nose",
        "urn:example:animal:ferret:nose",
        "jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true",
        "ftp://ftp.is.co.za/rfc/rfc1808.txt",
        "http://www.ietf.org/rfc/rfc2396.txt#header1",
        "ldap://[2001:db8::7]/c=GB?objectClass=one&objectClass=two",
        "mailto:John.Doe@example.com",
        "news:comp.infosystems.www.servers.unix",
        "tel:+1-816-555-1212",
        "telnet://192.0.2.16:80/",
        "urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
        "ssh://alice@example.com",
        "https://bob:pass@example.com/place",
        "http://example.com/?a=1&b=2+2&c=3&c=4&d=%65%6e%63%6F%64%65%64",
    ];

    for url in urls {
        println!("Parsing {}", url);
        match Url::parse(url) {
            Ok(valid_url) => {
                print_fields(valid_url);
                println!();
            }
            Err(e) => println!("Error Parsing url - {:?}", e),
        }
    }
}
