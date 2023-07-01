class MovingAverage
  let period: USize
  let _arr: Array[I32] // circular buffer
  var _curr: USize  // index of pointer position
  var _total: I32   // cache the total so far

  new create(period': USize) =>
    period = period'
    _arr = Array[I32](period) // preallocate space
    _curr = 0
    _total = 0

  fun ref apply(n: I32): F32 =>
    _total = _total + n
    if _arr.size() < period then
      _arr.push(n)
    else
      try
        let prev = _arr.update(_curr, n)?
        _total = _total - prev
        _curr = (_curr + 1) % period
      end
    end
    _total.f32() / _arr.size().f32()

// ---- TESTING -----
actor Main
  new create(env: Env) =>
    let foo = MovingAverage(3)
    let bar = MovingAverage(5)
    let data: Array[I32] = [1; 2; 3; 4; 5; 5; 4; 3; 2; 1]
    for v in data.values() do
      env.out.print("Foo: " + foo(v).string())
    end
    for v in data.values() do
      env.out.print("Bar: " + bar(v).string())
    end
