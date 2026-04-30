words = ("Sort an array (or list) of strings in order of descending length, " +
         "and in ascending lexicographic order for strings of equal length.").scan(/\w+/).map &.to_s

p words.sort_by {|word| { -word.size, word.downcase } }
