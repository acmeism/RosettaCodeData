?- brace_expansion("~/{Downloads,Pictures}/*.{jpg,gif,png}", Out).
Out = ["~/Downloads/*.jpg","~/Downloads/*.gif","~/Downloads/*.png","~/Pictures/*.jpg","~/Pictures/*.gif","~/Pictures/*.png"].

?- brace_expansion("It{{em,alic}iz,erat}e{d,}, please.", Out).
Out = ["Itemized, please.", "Itemize, please.", "Iterated, please.", "Iterate, please.", "Italicized, please.", "Italicize, please."].

?- brace_expansion("{,{,gotta have{ ,\\, again\\, }}more }cowbell!", Out).
Out = ["cowbell!", "more cowbell!", "gotta have more cowbell!", "gotta have, again, more cowbell!"].
