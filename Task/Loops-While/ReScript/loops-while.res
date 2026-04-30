let n = ref(1024)
while n.contents > 0 {
  Js.log(n.contents)
  n := n.contents / 2
}
