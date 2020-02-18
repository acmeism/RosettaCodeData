actor Main
  let _env: Env
  new create(env: Env) =>
    _env = env
    var n: I32 = 99
    repeat
      if n == 0 then
        _env.out.print("No more bottles of beer on the wall, no more bottles of beer.")
        _env.out.print("Go to the store and buy some more, 99 bottles of beer on the wall.")
      elseif n == 1 then
        _env.out.print("1 bottle of beer on the wall, 1 bottle of beer.")
        _env.out.print("Take one down and pass it around, no more bottles of beer on the wall.\n")
      else
        _env.out.print(n.string() + " bottles of beer on the wall, " + n.string() + " bottles of beer.")
        _env.out.print("Take one down and pass it around, "+ (n - 1).string() +" bottles of beer on the wall.\n")
      end
      n = n - 1
    until n < 0 end
