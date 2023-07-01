let s = ref("")
for i in 1 to 5 {
  for _ in 1 to i {
    s := Js.String2.concat(s.contents, "*")
  }
  s := Js.String2.concat(s.contents, "\n")
}
Js.log(s.contents)
