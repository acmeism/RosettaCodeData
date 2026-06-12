// Punched cards. Nigel Galloway: February 19th., 2026
let r12=" x           xxxxxxxxx                        xxxxxx            xxxxxxxxxxxxxxxxxx        xx  "
let r11="  x                   xxxxxxxxx                    xxxxxxx               xxxxxxxxxxxxxxxxx xxx"
let r10="   x                           xxxxxxxxx                  xxxxxxxxxxxxxxx         xxxxxxxxx xx"
let  r1="    x        x        x        x                                x        x                  x "
let  r2="     x        x        x        x       x     x     x     x      x        x       x           "
let  r3="      x        x        x        x       x     x     x     x      x        x       x          "
let  r4="       x        x        x        x       x     x     x     x      x        x       x         "
let  r5="        x        x        x        x       x     x     x     x      x        x       x        "
let  r6="         x        x        x        x       x     x     x     x      x        x       x       "
let  r7="          x        x        x        x       x           x     x      x        x       x      "
let  r8="           x        x        x        x xxxxxxxxxxx xxxxxxxxxxxx       x        x       x     "
let  r9="            x        x        x        x                                x        x       x    "
let alphabet=""" &-0123456789ABCDEFGHIJKLMNOPQR/STUVWXYZ:#@'="[.<(+|]$*);^\,%_>?abcdefghijklmnopqrstuvwxyz{|~}"""
let a2p=alphabet.ToCharArray()|>Array.mapi(fun n g->(g,n))|>Map
let punch (n:string)=
  let g,b=new string(' ',80-n.Length)+"|","."+new string('_',80)+"."
  printfn "%s\n/%s%s" b n g
  [r12;r11;r10;r1;r2;r3;r4;r5;r6;r7;r8;r9]|>List.iter(fun r->printf "|";(for c in n do printf "%c" (r[a2p[c]]));printfn "%s" g)
  printfn "%s" b
punch """printfn "%s" "Hi World" """
