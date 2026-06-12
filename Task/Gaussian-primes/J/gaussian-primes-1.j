isgpri=: {{
  if. 1 p: (*+) y do. 1 return. end.
  int=. |(+.y)-.0
  if. 1=#int do. {.(1 p: int) * 3=4|int else. 0 end.
}}"0
