package main

import (
	"fmt"
	"log"
	"net"
	"net/url"
)

func main() {
	for _, in := range []string{
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
	} {
		fmt.Println(in)
		u, err := url.Parse(in)
		if err != nil {
			log.Println(err)
			continue
		}
		if in != u.String() {
			fmt.Printf("Note: reassmebles as %q\n", u)
		}
		printURL(u)
	}
}

func printURL(u *url.URL) {
	fmt.Println("    Scheme:", u.Scheme)
	if u.Opaque != "" {
		fmt.Println("    Opaque:", u.Opaque)
	}
	if u.User != nil {
		fmt.Println("    Username:", u.User.Username())
		if pwd, ok := u.User.Password(); ok {
			fmt.Println("    Password:", pwd)
		}
	}
	if u.Host != "" {
		if host, port, err := net.SplitHostPort(u.Host); err == nil {
			fmt.Println("    Host:", host)
			fmt.Println("    Port:", port)
		} else {
			fmt.Println("    Host:", u.Host)
		}
	}
	if u.Path != "" {
		fmt.Println("    Path:", u.Path)
	}
	if u.RawQuery != "" {
		fmt.Println("    RawQuery:", u.RawQuery)
		m, err := url.ParseQuery(u.RawQuery)
		if err == nil {
			for k, v := range m {
				fmt.Printf("        Key: %q Values: %q\n", k, v)
			}
		}
	}
	if u.Fragment != "" {
		fmt.Println("    Fragment:", u.Fragment)
	}
}
