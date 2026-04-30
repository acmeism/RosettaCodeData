#include <iostream>
#include <string>
#include <vector>

// Parser of a well-formed URL
class Parser {
public:
	Parser(const std::string& url) : url(url) {
		parse();
		print();
	}

	void parse() {
		// Find the Scheme
		size_t scheme_end = url.find(":");
		scheme = url.substr(0, scheme_end);
		scheme_end += 1; // Skip over ":"

		// Complete the parsing of URL's not containing "://"
		const size_t double_slash = url.find("//");
		if ( double_slash == std::string::npos ) {
			path = url.substr(scheme_end);
			return;
		}

		if ( double_slash != scheme_end ) {
			const size_t question_mark = url.find("?", scheme_end);
			path = url.substr(scheme_end, question_mark - scheme_end);
			const size_t hash = url.find("#", question_mark + 1);
			if ( hash == std::string::npos ) {
				query = url.substr(question_mark + 1);
			} else {
				query = url.substr(question_mark + 1, hash - question_mark - 1);
				fragment = url.substr(hash + 1);
			}
			return;
		}

		scheme_end += 2; // Skip over "//"

		// Find Username and Password
		const size_t at_symbol = url.find("@", scheme_end);
		if ( at_symbol != std::string::npos ) {
			const size_t colon = url.find(":", scheme_end);
			if ( colon == std::string::npos ) {
				username = url.substr(scheme_end, at_symbol - scheme_end);
			} else {
				username = url.substr(scheme_end, colon - scheme_end);
				password = url.substr(colon + 1, at_symbol - colon - 1);
			}

			scheme_end = at_symbol + 1;
		}

		// Find Domain and Port
		const size_t domain_end = url.find("/", scheme_end);
		const size_t closing_bracket = url.find("]", scheme_end);
		if ( closing_bracket != std::string::npos ) {
			domain = url.substr(scheme_end, domain_end - scheme_end);
		} else {
			const size_t colon = url.find(":", scheme_end);
			if ( colon == std::string::npos ) {
				domain = url.substr(scheme_end, domain_end - scheme_end);
			} else {
				domain = url.substr(scheme_end, colon - scheme_end);
				port = url.substr(colon + 1, domain_end - colon - 1);
			}
		}

		if ( domain_end == std::string::npos ) {
			return;
		}

		// Find Path
		const size_t question_mark = url.find("?", domain_end);
		const size_t hash = url.find("#", domain_end);
		if ( hash == std::string::npos ) {
			path = url.substr(domain_end, question_mark - domain_end);
		} else {
			if ( hash < question_mark ) {
				path = url.substr(domain_end, hash - domain_end);
			} else {
				path = url.substr(domain_end, question_mark - domain_end);
			}
		}

		const size_t path_end = ( hash < question_mark ) ? hash: question_mark;
		if ( path_end == std::string::npos ) {
			return;
		}

		// Find Query and Fragmant
		const size_t query_end = url.find("#", path_end);
		if ( question_mark == std::string::npos ) {
			fragment = url.substr(query_end + 1);
		} else {
			query = url.substr(question_mark + 1, query_end - question_mark - 1);
			if ( query_end != std::string::npos ) {
				fragment = url.substr(query_end + 1);
			}
		}
	}

private:
	void print() const {
		if ( ! url.empty()      ) { std::cout << "URL      = " << url << std::endl; }
		if ( ! scheme.empty()   ) { std::cout << "Scheme   = " << scheme << std::endl; }
		if ( ! username.empty() ) { std::cout << "Username = " << username << std::endl; }
		if ( ! password.empty() ) { std::cout << "Password = " << password << std::endl; }
		if ( ! domain.empty()   ) { std::cout << "Domain   = " << domain << std::endl; }
		if ( ! port.empty()     ) { std::cout << "Port     = " << port << std::endl; }
		if ( ! path.empty()     ) { std::cout << "Path     = " << path << std::endl; }
		if ( ! query.empty()    ) { std::cout << "Query    = " << query << std::endl; }
		if ( ! fragment.empty() ) { std::cout << "Fragment = " << fragment << std::endl; }
		std::cout << std::endl;
	}

	std::string url;
	std::string scheme;
	std::string domain;
	std::string port;
	std::string username;
	std::string password;
	std::string path;
	std::string query;
	std::string fragment;
};

int main() {
	const std::vector<std::string> urls = {
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
		"http://example.com/?a=1&b=2+2&c=3&c=4&d=\%65\%6e\%63\%6F\%64\%65\%64"
	};

	for ( const std::string& url : urls ) {
		Parser parser(url);
	}
}
