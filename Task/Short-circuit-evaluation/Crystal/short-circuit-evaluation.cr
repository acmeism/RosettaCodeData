def a (p)
  print "a"
  p
end

def b (p)
  print "b"
  p
end

{% for op in ["&&", "||"] %}
  [true, false].each do |p|
    ps = p.to_s[0]
    print "r = a(#{ps}) #{ {{op}} } b(#{ps}): "
    r = a(p) {{op.id}} b(p)
    puts
  end
{% end %}
