fun palindrome s =
  let val cs = explode s in
    cs = rev cs
  end
