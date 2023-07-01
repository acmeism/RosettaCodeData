/* Rexx */

-- MathLoadFuncs & MathDropFuncs are no longer needed and are effectively NOPs
-- but MathLoadFuncs does return its copyright statement when given a string argument
RxMathCopyright = MathLoadFuncs('')
say RxMathCopyright

numeric digits 16

x = 2.5
y = 3
pad = 40
digs = digits()
say
say 'Working with precision' digs
say 'Math constants & functions:'
say ('  Euler''s number (e):')~left(pad)                    RxCalcExp(1, digs)
say ('  Pi:')~left(pad)                                     RxCalcPi(digs)
say ('  Square root of' x':')~left(pad)                     RxCalcSqrt(x, digs)
say ('  Log(e) of' x':')~left(pad)                          RxCalcLog(x, digs)
say ('  Log(e) of e:')~left(pad)                            RxCalcLog(RxCalcExp(1, digs), digs)
say ('  Log(10) of' x':')~left(pad)                         RxCalcLog10(x, digs)
say ('  Log(10) of 10:')~left(pad)                          RxCalcLog10(10, digs)
say ('  Exponential (e**x) of' x':')~left(pad)              RxCalcExp(x, digs)
say ('  Exponential (e**x) of log(e)' x':')~left(pad)       RxCalcExp(RxCalcLog(x, digs), digs)
say (' ' x 'to the power of' y':')~left(pad)                RxCalcPower(x, y, digs)
say (' ' x 'to the power of 1/'y':')~left(pad)              RxCalcPower(x, 1 / y, digs)
say ('  10 to the power of log10' x':')~left(pad)           RxCalcPower(10, RxCalcLog10(x), digs)

say
say 'Rexx built-in support for numeric data:'
say ('  Abs of' x':')~left(pad)                             x~abs()
say ('  Abs of' (-x)':')~left(pad)                          (-x)~abs()
say ('  Sign of' x':')~left(pad)                            x~sign()
say ('  Sign of' x '-' x':')~left(pad)                      (x - x)~sign()
say ('  Sign of' (-x)':')~left(pad)                         (-x)~sign()
say ('  Max of' (-x) '&' x':')~left(pad)                    (-x)~max(x)
say ('  Min of' (-x) '&' x':')~left(pad)                    (-x)~min(x)
say ('  Truncate' x 'by' y':')~left(pad)                    x~trunc(y)
say ('  Format (with rounding)' x 'by' y':')~left(pad)      x~format(y, 0)

say
say 'Use RYO functions for floor & ceiling:'
say ('  Floor of' x':')~left(pad)                           floor(x)
say ('  Floor of' (-x)':')~left(pad)                        floor((-x))
say ('  Ceiling of' x':')~left(pad)                         ceiling(x)
say ('  Ceiling of' (-x)':')~left(pad)                      ceiling((-x))

return

-- floor and ceiling functions are not part of ooRexx
floor: procedure
  return arg(1)~trunc() - (arg(1) < 0) * (arg(1) \= arg(1)~trunc())

ceiling: procedure
  return arg(1)~trunc() + (arg(1) > 0) * (arg(1) \= arg(1)~trunc())

::requires 'RxMath' library
