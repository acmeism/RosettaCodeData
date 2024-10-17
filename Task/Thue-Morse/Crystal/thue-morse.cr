steps = 6

tmp = ""
s1 = "0"
s2 = "1"

steps.times {
  tmp = s1
  s1 += s2
  s2 += tmp
}

puts s1
