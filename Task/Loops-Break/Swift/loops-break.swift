while true
{
  let a = Int(arc4random()) % (20)
  print("a: \(a)",terminator: "   ")
  if (a == 10)
  {
    break
  }
  let b = Int(arc4random()) % (20)
  print("b: \(b)")
}
