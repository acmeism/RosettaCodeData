identification division.
program-id. sierpinski-triangle-program.
data division.
working-storage section.
01  sierpinski.
    05 n              pic 99.
    05 i              pic 999.
    05 k              pic 999.
    05 m              pic 999.
    05 c              pic 9(18).
    05 i-limit        pic 999.
    05 q              pic 9(18).
    05 r              pic 9.
procedure division.
control-paragraph.
    move 4 to n.
    multiply n by 4 giving i-limit.
    subtract 1 from i-limit.
    perform sierpinski-paragraph
    varying i from 0 by 1 until i is greater than i-limit.
    stop run.
sierpinski-paragraph.
    subtract i from i-limit giving m.
    multiply m by 2 giving m.
    perform m times,
    display space with no advancing,
    end-perform.
    move 1 to c.
    perform inner-loop-paragraph
    varying k from 0 by 1 until k is greater than i.
    display ''.
inner-loop-paragraph.
    divide c by 2 giving q remainder r.
    if r is equal to zero then display '  * ' with no advancing.
    if r is not equal to zero then display '    ' with no advancing.
    compute c = c * (i - k) / (k + 1).
