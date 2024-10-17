require "uri"

examples = ["foo://example.com:8042/over/there?name=ferret#nose",
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
            "https://bob:password@[::1]/place?a=1&b=2%202"]

examples.each do |example|
    puts "Parsing \"#{example}\":"
    url = URI.parse example
    {% for name in ["scheme", "host", "hostname", "port", "path", "userinfo",
                    "user", "password", "fragment", "query"] %}
        unless url.{{name.id}}.nil?
            puts "    {{name.id}}: \"#{url.{{name.id}}}\""
        end
    {% end %}
    unless url.query_params.empty?
        puts "    query_params:"
        url.query_params.each do |k, v|
            puts "        #{k}: \"#{v}\""
        end
    end
    puts
end
