def setup(ruleset)
  ruleset.each_line.inject([]) do |rules, line|
    if line =~ /^\s*#/
      rules
    elsif line =~ /^(.+)\s+->\s+(\.?)(.*)$/
      rules << [$1, $3, $2 != ""]
    else
      raise "Syntax error: #{line}"
    end
  end
end

def markov(ruleset, input_data)
  rules = setup(ruleset)
  while (matched = rules.find { |match, replace, term|
    input_data[match] and input_data.sub!(match, replace)
    }) and !matched[2]
  end
  input_data
end
