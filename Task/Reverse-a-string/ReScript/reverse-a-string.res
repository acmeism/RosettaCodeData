let rev_string = (s) => {
  let len = Js.String2.length(s)
  let arr = []
  for i in 0 to (len-1) {
    let c = Js.String2.get(s, len - 1 - i)
    let _ = Js.Array2.push(arr, c)
  }
  Js.String2.concatMany("", arr)
}

Js.log(rev_string("abcdefg"))
