#!/usr/bin/lasso9

define generatePi => {
  yield currentCapture

  local(r = array(), i, k, b, d, c = 0, x)
  with i in generateSeries(1, 2800)
  do #r->insert(2000)
  with k in generateSeries(2800, 1, -14)
  do {
    #d = 0
    #i = #k
    while(true) => {
      #d += #r->get(#i) * 10000
      #b = 2 * #i - 1
      #r->get(#i) = #d % #b
      #d /= #b
      #i--
      !#i ? loop_abort
      #d *= #i
    }
    #x = (#c + #d / 10000)
    yield (#k == 2800 ? ((#x * 0.001)->asstring(-precision = 3)) | #x->asstring(-padding=4, -padChar='0'))
    #c = #d % 10000
  }
}

local(pi_digits) = generatePi
loop(200) => {
    stdout(#pi_digits())
}
