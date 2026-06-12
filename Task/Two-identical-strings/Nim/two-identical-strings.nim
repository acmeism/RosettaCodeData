import strformat

func isConcat(s: string): bool =
  if (s.len and 1) != 0: return false
  let half = s.len shr 1
  result = s[0..<half] == s[half..^1]

for n in 0..999:
  let b = &"{n:b}"
  if b.isConcat: echo &"{n:3} {b}"
