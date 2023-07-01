ls:{raze(string 1_ deltas d,count x),'x d:where differ x}  / look & say
sumsay:ls desc@                                            / summarize & say

seeds:group desc each string til 1000000                   / seeds for million integers
seq:(key seeds)!30 sumsay\'key seeds                       / sequences for unique seeds
top:max its:(count distinct@)each seq                      / count iterations

/ report results
rpt:{1 x,": ",y,"\n\n";}
rpt["Seeds"]" "sv string raze seeds where its=top          / all forms of top seed/s
rpt["Iterations"]string top
rpt["Sequence"]"\n\n","\n"sv raze seq where its=top
