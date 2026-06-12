def make_regex (kind = :uri)
  alpha      = %r< [A-Za-z] >x
  digit      = %r< [0-9] >x
  hexdig     = %r< [0-9A-Fa-f] >x

  ucschar = %r< [\x{A0}-\x{D7FF}]     | [\x{F900}-\x{FDCF}]   | [\x{FDF0}-\x{FFEF}]
              | [\x{10000}-\x{1FFFD}] | [\x{20000}-\x{2FFFD}] | [\x{30000}-\x{3FFFD}]
              | [\x{40000}-\x{4FFFD}] | [\x{50000}-\x{5FFFD}] | [\x{60000}-\x{6FFFD}]
              | [\x{70000}-\x{7FFFD}] | [\x{80000}-\x{8FFFD}] | [\x{90000}-\x{9FFFD}]
              | [\x{A0000}-\x{AFFFD}] | [\x{B0000}-\x{BFFFD}] | [\x{C0000}-\x{CFFFD}]
              | [\x{D0000}-\x{DFFFD}] | [\x{E1000}-\x{EFFFD}] >x
  iprivate = %r< [\x{E000}-\x{F8FF}]  | [\x{F0000}-\x{FFFFD}] | [\x{100000}-\x{10FFFD}] >x

  sub_delims = %r< [!$&'()*+,;=] >x
  gen_delims = %r< [:/?#\[\]@] >x
  reserved   = %r< #{gen_delims} | #{sub_delims} >x

  uunreserved = %r< #{alpha} | #{digit} | - | \. | _ | ~ >x
  unreserved = case kind
               when :uri then uunreserved
               when :iri then %r< #{alpha} | #{digit} | - | \. | _ | ~ | #{ucschar} >x
               else raise "choose either :uri or :iri"
               end

  pct_encoded = %r< % #{hexdig} #{hexdig} >x

  pchar = %r< #{unreserved} | #{pct_encoded} | #{sub_delims} | : | @ >x

  query = kind == :uri ? %r< ( #{pchar} | / | \? )* >x
                       : %r< ( #{pchar} | #{iprivate} | / | \? )* >x
  fragment = %r< ( #{pchar} | / | \? )* >x

  segment       = %r< #{pchar}* >x
  segment_nz    = %r< #{pchar}+ >x
  segment_nz_nc = %r< ( #{unreserved} | #{pct_encoded} | #{sub_delims} | @ )+ >x

  path_abempty  = %r< ( / #{segment} )* >x
  path_absolute = %r< / ( #{segment_nz} ( / #{segment} )* )? >x
  path_noscheme = %r< #{segment_nz_nc} ( / #{segment} )* >x
  path_rootless = %r< #{segment_nz} ( / #{segment} )* >x
  path_empty    = %r< >x

  path = %r< #{path_abempty} | #{path_absolute} | #{path_noscheme}
           | #{path_rootless} | #{path_empty} >x

  reg_name = %r< ( #{unreserved} | #{pct_encoded} | #{sub_delims} )* >x

  dec_octet = %r< 25 [0-5] | 2 [0-4] #{digit}
                | 1 #{digit}{2} | [1-9] #{digit} | #{digit} >x

  ipv4address = %r< #{dec_octet} \. #{dec_octet} \. #{dec_octet} \. #{dec_octet} >x
  h16         = %r< ( #{hexdig}{1,4} )+ >x
  ls32        = %r< ( #{h16} : #{h16} ) | #{ipv4address} >x

  ipv6address = %r<                                  ( #{h16} : ){6} #{ls32}
                  |                               :: ( #{h16} : ){5} #{ls32}
                  | (                   #{h16} )? :: ( #{h16} : ){4} #{ls32}
                  | ( ( #{h16} : ){,1}  #{h16} )? :: ( #{h16} : ){3} #{ls32}
                  | ( ( #{h16} : ){,2}  #{h16} )? :: ( #{h16} : ){2} #{ls32}
                  | ( ( #{h16} : ){,3}  #{h16} )? ::   #{h16} :      #{ls32}
                  | ( ( #{h16} : ){,4}  #{h16} )? ::                 #{ls32}
                  | ( ( #{h16} : ){,5}  #{h16} )? ::                 #{h16}
                  | ( ( #{h16} : ){,6}  #{h16} )? ::                         >x

  ipvfuture = %r< v #{hexdig}+ \. ( #{uunreserved} | #{sub_delims} | : )+ >x

  ip_literal = %r< \[ ( #{ipv6address} | #{ipvfuture} ) \] >x

  userinfo  = %r< ( #{unreserved} | #{pct_encoded} | #{sub_delims} | : )* >x
  host      = %r< #{ip_literal} | #{ipv4address} | #{reg_name} >x
  port      = %r< #{digit}* >x
  authority = %r< ( #{userinfo} @ )? #{host} ( : #{port} )? >x

  scheme = %r< #{alpha} ( #{alpha} | #{digit} | \+ | - | \. )* >x

  hier_part = %r< // #{authority} #{path_abempty}
                | #{path_absolute} | #{path_rootless} | #{path_empty} >x

  uri = %r< #{scheme} : #{hier_part} ( \? #{query} )? ( \# #{fragment} )? >x
end

uri_re = make_regex :uri
iri_re = make_regex :iri

text = <<-EOT
     this URI contains an illegal character, parentheses and a misplaced full stop:
     http://en.wikipedia.org/wiki/Erich_Kästner_(camera_designer). (which is handled by http://mediawiki.org/).
     and another one just to confuse the parser: http://en.wikipedia.org/wiki/-)
     ")" is handled the wrong way by the mediawiki parser.
     ftp://domain.name/path(balanced_brackets)/foo.html
     ftp://domain.name/path(balanced_brackets)/ending.in.dot.
     ftp://domain.name/path(unbalanced_brackets/ending.in.dot.
     leading junk ftp://domain.name/path/embedded?punct/uation.
     leading junk ftp://domain.name/dangling_close_paren)
     if you have other interesting URIs for testing, please add them here:
     http://www.example.org/foo.html#includes_fragment
     http://www.example.org/foo.html#enthält_Unicode-Fragment
      http://192.168.0.1/admin/?hackme=%%%%%%%%%true
     blah (foo://domain.hld/))))
     https://haxor.ur:4592/~mama/####&?foo
       ftp://ftp.is.co.za/rfc/rfc1808.txt
       http://www.ietf.org/rfc/rfc2396.txt
       mailto:John.Doe@example.com
       news:comp.infosystems.www.servers.unix
       tel:+1-816-555-1212
       telnet://192.0.2.16:80/
       urn:oasis:names:specification:docbook:dtd:xml:4.1.2
       An example of ldap: ldap://[2001:db8::7]/c=GB?objectClass?one
     EOT

matches = (text.scan(uri_re).map {|m| { m.begin, m[0], :uri } } +
           text.scan(iri_re).map {|m| { m.begin, m[0], :iri } }).sort!
maxwd = matches.max_of {|m| m[1].size }

puts " pos  %-*s  URI IRI" % { maxwd, "match" }
puts "------%s---------" % { "-" * maxwd }

matches.each.chunk_while {|(p1, s1, _), (p2, s2, _)| p1 == p2 && s1 == s2 }
  .each do |chunk|
  pos, match = chunk[0]
  printf "%4d  %-*s  ", pos, maxwd, match
  kinds = chunk.map {|(_, _, kind)| kind }
  puts " %s   %s" % { :uri.in?(kinds) ? "x" : " ", :iri.in?(kinds) ? "x" : " " }
end
