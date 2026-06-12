import std/[math, strformat]

const

  Angles = [0.78539816339745, 0.46364760900081, 0.24497866312686, 0.12435499454676,
            0.06241880999596, 0.03123983343027, 0.01562372862048, 0.00781234106010,
            0.00390623013197, 0.00195312251648, 0.00097656218956, 0.00048828121119,
            0.00024414062015, 0.00012207031189, 0.00006103515617, 0.00003051757812,
            0.00001525878906, 0.00000762939453, 0.00000381469727, 0.00000190734863,
            0.00000095367432, 0.00000047683716, 0.00000023841858, 0.00000011920929,
            0.00000005960464, 0.00000002980232, 0.00000001490116, 0.00000000745058]

  KValues = [0.70710678118655, 0.63245553203368, 0.61357199107790, 0.60883391251775,
             0.60764825625617, 0.60735177014130, 0.60727764409353, 0.60725911229889,
             0.60725447933256, 0.60725332108988, 0.60725303152913, 0.60725295913894,
             0.60725294104140, 0.60725293651701, 0.60725293538591, 0.60725293510314,
             0.60725293503245, 0.60725293501477, 0.60725293501035, 0.60725293500925,
             0.60725293500897, 0.60725293500890, 0.60725293500889, 0.60725293500888]


proc cordic(alpha: float; n: int): tuple[cos, sin: float] =

  let newSgn = if int(alpha / (2 * PI)) mod 2 == 1: 1.0 else: -1.0
  if alpha < -PI / 2 or alpha > PI / 2:
    let (x, y) = if alpha < 0: cordic(alpha + PI, n) else: cordic(alpha - PI, n)
    return (x * newSgn, y * newSgn)

  var ix = n - 1
  if ix > 23: ix = 23
  let kn = KValues[ix]
  var (x, y) = (1.0, 0.0)
  var theta = 0.0
  var pow2 = 1.0
  for i in 0..<n:
    let atn = Angles[i]
    let sigma = if theta < alpha: 1.0 else: -1.0
    theta += sigma * atn
    let t = x
    x -= sigma * y * pow2
    y += sigma * t * pow2
    pow2 /= 2
  result = (x * kn, y * kn)


when isMainModule:
  let angles = [-9.0, 0.0, 1.5, 6.0]

  echo "  x       sin(x)     diff. sine     cos(x)    diff. cosine"
  for th in countup(-90, 90, 15):
    let thr = degToRad(th.toFloat)
    let (ccos, csin) = cordic(thr, 24)
    echo &"{th:+03}.0°  {csin:+.8f} ({csin - sin(thr):+.8f}) {ccos:+.8f} ({ccos - cos(thr):+.8f})"

  echo "\nx(rads)   sin(x)     diff. sine     cos(x)    diff. cosine"
  for i in 0..3:
    let thr = angles[i]
    let (ccos, csin) = cordic(thr, 24)
    echo &"{thr:+4.1f}    {csin:+.8f} ({csin - sin(thr):+.8f}) {ccos:+.8f} ({ccos - cos(thr):+.8f})"
