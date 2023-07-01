print_all:  procedure              /*   [↓]     is the # of args passed.*/
                           do j=1  for arg()
                           say  '[argument'   j"]: "   arg(j)
                           end   /*j*/
return
