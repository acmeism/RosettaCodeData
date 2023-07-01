def getitem(s, depth=0)
  out = [""]
  until s.empty?
    c = s[0]
    break  if depth>0 and (c == ',' or c == '}')
    if c == '{' and x = getgroup(s[1..-1], depth+1)
      out = out.product(x[0]).map{|a,b| a+b}
      s = x[1]
    else
      s, c = s[1..-1], c + s[1]  if c == '\\' and s.size > 1
      out, s = out.map{|a| a+c}, s[1..-1]
    end
  end
  return out, s
end

def getgroup(s, depth)
  out, comma = [], false
  until s.empty?
    g, s = getitem(s, depth)
    break  if s.empty?
    out += g
    case s[0]
      when '}' then return (comma ? out : out.map{|a| "{#{a}}"}), s[1..-1]
      when ',' then comma, s = true, s[1..-1]
    end
  end
end

strs = <<'EOS'
~/{Downloads,Pictures}/*.{jpg,gif,png}
It{{em,alic}iz,erat}e{d,}, please.
{,{,gotta have{ ,\, again\, }}more }cowbell!
{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}
EOS

strs.each_line do |s|
  puts s.chomp!
  puts getitem(s)[0].map{|str| "\t"+str}
  puts
end
