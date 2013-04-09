re = /\A     # beginning of string
  (?<bb>     # begin capture group <bb>
    \[       #   literal [
    \g<bb>*  #   zero or more <bb>
    \]       #   literal ]
  )*         # end group, zero or more such groups
\z/x         # end of string

(0..9).each do |i|
  s = "[]" * i

  # There is no String#shuffle! method.
  # This is a Knuth shuffle.
  (s.length - 1).downto(1) do |a; b|
    b = rand(a + 1)
    s[a], s[b] = s[b], s[a]
  end

  puts((s =~ re ? " OK: " : "bad: ") + s)
end

["[[]", "[]]", "[letters]"].each do |s|
  puts((s =~ re ? " OK: " : "bad: ") + s)
end
