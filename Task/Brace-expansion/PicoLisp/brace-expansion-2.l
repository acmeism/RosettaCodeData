(test
   (quote
      "~/Downloads/*.jpg"
      "~/Downloads/*.gif"
      "~/Downloads/*.png"
      "~/Pictures/*.jpg"
      "~/Pictures/*.gif"
      "~/Pictures/*.png" )
   (braceExpand "~/{Downloads,Pictures}/*.{jpg,gif,png}") )

(test
   (quote
      "Itemized, please."
      "Itemize, please."
      "Italicized, please."
      "Italicize, please."
      "Iterated, please."
      "Iterate, please." )
   (braceExpand "It{{em,alic}iz,erat}e{d,}, please.") )

(test
   (quote
      "cowbell!"
      "more cowbell!"
      "gotta have more cowbell!"
      "gotta have\, again\, more cowbell!" )
   (braceExpand "{,{,gotta have{ ,\\, again\\, }}more }cowbell!") )

(test
   (quote
      "{}} some }{,{\\ edge \,}{ cases, {here} \\\\\}"
      "{}} some }{,{\\ edge \,}{ cases, {here} \\\\\}" )
   (braceExpand "{}} some }{,{\\\\{ edge, edge} \\,}{ cases, {here} \\\\\\\\\\}") )
