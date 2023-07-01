# Project : Musical scale

loadlib("C:\Ring\extensions\ringbeep\ringbeep.dll")
freqs = [[262,"Do"], [294,"Ra"], [330,"Me"], [349,"Fa"], [392,"So"], [440,"La"], [494,"Te"], [523,"do"]]
for f = 1 to len(freqs)
     see freqs[f][2] + nl
     beep(freqs[f][1],300)
next
