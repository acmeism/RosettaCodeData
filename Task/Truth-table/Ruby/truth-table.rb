loop do
  print "\ninput a boolean expression (e.g. 'a & b'): "
  expr = gets.strip.downcase
  break if expr.empty?

  vars = expr.scan(/\p{Alpha}+/)
  if vars.empty?
    puts "no variables detected in your boolean expression"
    next
  end

  vars.each {|v| print "#{v}\t"}
  puts "| #{expr}"

  prefix = []
  suffix = []
  vars.each do |v|
    prefix << "[false, true].each do |#{v}|"
    suffix << "end"
  end

  body = vars.inject("puts ") {|str, v| str + "#{v}.to_s + '\t' + "}
  body += '"| " + eval(expr).to_s'

  eval (prefix + [body] + suffix).join("\n")
end
