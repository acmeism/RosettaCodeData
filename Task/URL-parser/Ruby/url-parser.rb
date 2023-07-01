require 'uri'

test_cases = [
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
  "http://example.com/?a=1&b=2+2&c=3&c=4&d=%65%6e%63%6F%64%65%64"
]

class URI::Generic; alias_method :domain, :host; end

test_cases.each do |test_case|
  puts test_case
  uri = URI.parse(test_case)
  %w[ scheme domain port path query fragment user password ].each do |attr|
    puts "  #{attr.rjust(8)} = #{uri.send(attr)}" if uri.send(attr)
  end
end
