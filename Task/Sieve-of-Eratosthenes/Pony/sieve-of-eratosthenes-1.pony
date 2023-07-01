use "time" // for testing
use "collections"

class Primes is Iterator[U32] // returns an Iterator of found primes...
  let _bitmask: Array[U8] = [ 1; 2; 4; 8; 16; 32; 64; 128 ]
  var _lmt: USize
  let _cmpsts: Array[U8]
  var _ndx: USize = 2
  var _curr: U32 = 2

  new create(limit: U32) ? =>
    _lmt = USize.from[U32](limit)
    let sqrtlmt = USize.from[F64](F64.from[U32](limit).sqrt())
    _cmpsts = Array[U8].init(0, (_lmt + 8) / 8) // already zeroed; bit array
    _cmpsts(0)? = 3 // mark 0 and 1 as not prime!
    if sqrtlmt < 2 then return end
    for p in Range[USize](2, sqrtlmt + 1) do
      if (_cmpsts(p >> 3)? and _bitmask(p and 7)?) == 0 then
        var s = p * p // cull start address for p * p!
        let slmt = (s + (p << 3)).min(_lmt + 1)
        while s < slmt do
          let msk = _bitmask(s and 7)?
          var c = s >> 3
          while c < _cmpsts.size() do
            _cmpsts(c)? = _cmpsts(c)? or msk
            c = c + p
          end
          s = s + p
        end
      end
    end

  fun ref has_next(): Bool val => _ndx < (_lmt + 1)

  fun ref next(): U32 ? =>
    _curr = U32.from[USize](_ndx); _ndx = _ndx + 1
    while (_ndx <= _lmt) and ((_cmpsts(_ndx >> 3)? and _bitmask(_ndx and 7)?) != 0) do
      _ndx = _ndx + 1
    end
    _curr

actor Main
  new create(env: Env) =>
    let limit: U32 = 1_000_000_000
    try
      env.out.write("Primes to 100:  ")
      for p in Primes(100)? do env.out.write(p.string() + " ") end
      var count: I32 = 0
      for p in Primes(1_000_000)? do count = count + 1 end
      env.out.print("\nThere are " + count.string() + " primes to a million.")
      let t = Time
      let start = t.millis()
      let prms = Primes(limit)?
      let elpsd = t.millis() - start
      count = 0
      for _ in prms do count = count + 1 end
      env.out.print("Found " + count.string() + " primes to " + limit.string() + ".")
      env.out.print("This took " + elpsd.string() + " milliseconds.")
    end
