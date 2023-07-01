whpsc=: ' ',TAB                                NB. define whitespace as desired
dlws=: }.~ (e.&whpsc i. 0:)                    NB. delete leading whitespace (spaces and tabs)
dtws=: #~ ([: +./\. -.@:e.&whpsc)              NB. delete trailing whitespace
dltws=: #~ ([: (+./\ *. +./\.) -.@:e.&whpsc)   NB. delete leading & trailing whitespace
dews=: #~ (+. (1: |. (> </\)))@(-.@:e.&whpsc)  NB. delete extraneous whitespace
