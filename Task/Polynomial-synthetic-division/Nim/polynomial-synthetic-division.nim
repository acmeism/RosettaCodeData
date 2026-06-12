import strformat

type Polynomial = seq[int]

func `$`(p: Polynomial): string = system.`$`(p)[1..^1]

func extendedSyntheticDivision(dividend, divisor: Polynomial): tuple[q, r: Polynomial] =
    var res = dividend
    let normalizer = divisor[0]
    let separator = dividend.len - divisor.len
    for i in 0..separator:
      res[i] = res[i] div normalizer
      let coef = res[i]
      if coef != 0:
        for j in 1..divisor.high:
          res[i + j] += -divisor[j] * coef
    result = (res[0..separator], res[(separator+1)..^1])

when isMainModule:
  echo "Polynomial synthetic division"
  let n1 = @[1, -12, 0, -42]
  let d1 = @[1, -3]
  let (q1, r1) = extendedSyntheticDivision(n1, d1)
  echo &"{n1} / {d1}  =  {q1}, remainder {r1}"
  let n2 = @[1, 0, 0, 0, -2]
  let d2 = @[1, 1, 1, 1]
  let (q2, r2) = extendedSyntheticDivision(n2, d2)
  echo &"{n2} / {d2}  =  {q2}, remainder {r2}"
