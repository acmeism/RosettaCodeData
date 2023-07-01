let inline swap (a: _ []) i j =
  let temp = a.[i]
  a.[i] <- a.[j]
  a.[j] <- temp

let inline sift cmp (a: _ []) start count =
  let rec loop root child =
    if root * 2 + 1 < count then
      let p = child < count - 1 && cmp a.[child] a.[child + 1] < 0
      let child = if p then child + 1 else child
      if cmp a.[root] a.[child] < 0 then
        swap a root child
        loop child (child * 2 + 1)
  loop start (start * 2 + 1)

let inline heapsort cmp (a: _ []) =
  let n = a.Length
  for start = n/2 - 1 downto 0 do
    sift cmp a start n
  for term = n - 1 downto 1 do
    swap a term 0
    sift cmp a 0 term
