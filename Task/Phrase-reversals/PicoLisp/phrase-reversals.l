(let (S (chop "rosetta code phrase reversal")  L (split S " "))
   (prinl (reverse S))
   (prinl (glue " " (mapcar reverse L)))
   (prinl (glue " " (reverse L))) )
