def solve( problem )
  lines = problem.split(".")
  names = lines.first.scan( /[A-Z]\w*/ )
  re_names = Regexp.union( names )
  # Later on, search for these keywords (the word "not" is handled separately).
  words = %w(first second third fourth fifth sixth seventh eighth nineth tenth
  bottom top higher lower adjacent)
  re_keywords = Regexp.union( words )

  predicates = [] #build an array of lambda's
  lines[1..-2].each do |line|
    keywords = line.scan( re_keywords )
    name1, name2 = line.scan( re_names )
    keywords.each do |keyword|
      l = case keyword
        when "bottom"   then ->(c){ c.first == name1 }
        when "top"      then ->(c){ c.last == name1 }
        when "higher"   then ->(c){ c.index( name1 ) > c.index( name2 ) }
        when "lower"    then ->(c){ c.index( name1 ) < c.index( name2 ) }
        when "adjacent" then ->(c){ (c.index( name1 ) - c.index( name2 )).abs == 1 }
        else                 ->(c){ c[words.index(keyword)] == name1 }
        end
     line =~ /\bnot\b/  ? res = ->(c){not l.call(c) } : res = l
     predicates << res
    end
  end

  names.permutation.detect{|candidate| predicates.all?{|predicate| predicate.(candidate)}}

end
