$$ MODE TUSCRIPT
str= "      sentence w/whitespace before and after    "
trimmedtop=EXTRACT (str,":<|<> :"|,0)
trimmedtail=EXTRACT (str,0,":<> >|:")
trimmedboth=SQUEEZE(str)
PRINT "string           <|", str," >|"
PRINT "trimmed on top   <|",trimmedtop,">|"
PRINT "trimmed on tail  <|", trimmedtail,">|"
PRINT "trimmed on both  <|", trimmedboth,">|"
