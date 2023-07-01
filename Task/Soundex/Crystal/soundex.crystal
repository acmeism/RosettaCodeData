# version 0.21.1

def get_code(c : Char)
  case c
  when 'B', 'F', 'P', 'V'
    "1"
  when 'C', 'G', 'J', 'K', 'Q', 'S', 'X', 'Z'
    "2"
  when 'D', 'T'
    "3"
  when 'L'
    "4"
  when 'M', 'N'
    "5"
  when 'R'
    "6"
  when 'H', 'W'
    "-"
  else
    ""
  end
end

def soundex(s : String)
  return "" if s == ""
  s = s.upcase
  result = s[0,1]
  prev = get_code s[0]
  s.lchop.each_char {|c|
    curr = get_code c
    result += curr if curr != "" && curr != "-" && curr != prev
    prev = curr unless curr == "-"
  }
  result.ljust(4, '0')[0, 4]
end

pairs = [
          ["Ashcraft"  , "A261"],
          ["Ashcroft"  , "A261"],
          ["Gauss"     , "G200"],
          ["Ghosh"     , "G200"],
          ["Hilbert"   , "H416"],
          ["Heilbronn" , "H416"],
          ["Lee"       , "L000"],
          ["Lloyd"     , "L300"],
          ["Moses"     , "M220"],
          ["Pfister"   , "P236"],
          ["Robert"    , "R163"],
          ["Rupert"    , "R163"],
          ["Rubin"     , "R150"],
          ["Tymczak"   , "T522"],
          ["Soundex"   , "S532"],
          ["Example"   , "E251"]
        ]

pairs.each { |pair|
  puts "#{pair[0].ljust(9)} -> #{pair[1]} -> #{soundex(pair[0]) == pair[1]}"
}
