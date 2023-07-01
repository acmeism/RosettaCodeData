depth=: (i.~ ~.)@(0 i."1~' '=];._2)
tree=: (i: 0>.<:@{:)\
width=: {{NB. y is tree
   c=. *i.#y  NB. children
   NB. sum of children, inductively
   y (+//. c&*)`(~.@[)`]}^:_ c
}}

NB. avoid dark colors
NB. avoid dark colors
NB. avoid dark colors
pastel=: {{256#.192+?y$,:3#64}}

task=: {{
   depths=: depth y   NB. outline structure
   t=: tree depths    NB. outline as tree
   pad=: (i.#depths) -. t,I.(=>./)depths
   tr=: t,pad         NB. outline as constant depth tree
   dr=: depths,1+pad{depths
   lines=:(#dr){.<@dlb;._2 y
   widths=. width tr  NB. column widths
   top=. I.2>dr
   color=.<"1 hfd 8421504 (I.tr e.pad)} (top top} tr)&{^:_ (<:2^24),pastel<:#dr
   r=.'{| class="wikitable" style="text-align: center;"',LF
   for_d.~.dr do.     NB. descend through the depths
    k=.I.d=dr         NB. all lines at this depth
    p=. |:({:,~{&tr)^:d ,:k
    j=. k/:p          NB. order padding to fit parents
    r=. r,'|-',LF
    r=. r,;'| style="background: #',L:0 (j{color),L:0'" colspan=',L:0(j{widths),&":each' | ',L:0 (j{lines),L:0 LF
   end.
   r=.r,'|}',LF
}}
