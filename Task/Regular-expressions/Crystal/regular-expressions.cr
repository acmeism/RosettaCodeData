s = "I am a string"
# Match
s =~ /string$/ # => 7
s =~ /^You/    # => nil
# Substitute
s.sub(/\ba\b/, "a different")  # => "I am a different string"
s.gsub(/\b\w/) {|c| c.upcase } # => "I Am A String"
