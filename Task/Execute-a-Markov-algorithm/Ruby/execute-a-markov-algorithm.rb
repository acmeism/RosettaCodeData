raise "Please input an input code file, an input data file, and an output file." if ARGV.size < 3

rules = File.readlines(ARGV[0]).inject([]) do |rules, line|
  if line =~ /^\s*#/
    rules
  elsif line =~ /^(.+)\s+->\s+(\.?)(.*)$/
    rules << [$1, $3, $2 != ""]
  else
    raise "Syntax error: #{line}"
  end
end

File.open(ARGV[2], "w") do |file|
  file.write(File.read(ARGV[1]).tap { |input_data|
    while (matched = rules.find { |match, replace, term|
      input_data[match] and input_data.sub!(match, replace)
    }) and !matched[2]
    end
  })
end
