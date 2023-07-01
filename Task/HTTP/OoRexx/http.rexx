url=.bsf~new("java.net.URL","http://teletext.orf.at")
sc =.bsf~new("java.util.Scanner",url~openStream)
loop while sc~hasNext
  say sc~nextLine
  End
::requires BSF.CLS   -- get Java camouflaging support
