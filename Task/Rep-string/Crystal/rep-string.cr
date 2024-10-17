def rep(s : String) : Int32
  x = s.size // 2

  while x > 0
    return x if s.starts_with? s[x..]
    x -= 1
  end

  0
end

def main
  %w(
    1001110011
    1110111011
    0010010010
    1010101010
    1111111111
    0100101101
    0100100
    101
    11
    00
    1
  ).each do |s|
    n = rep s
    puts n > 0 ? "\"#{s}\" #{n} rep-string \"#{s[..(n - 1)]}\"" : "\"#{s}\" not a rep-string"
  end
end

main
