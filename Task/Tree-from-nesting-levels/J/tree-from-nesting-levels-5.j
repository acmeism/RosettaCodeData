pnest=: {{
   t=. ;:y                   NB. tokens
   p=. (;:'()')=/t           NB. paren token matches
   d=: +/\-/p                NB. paren token depths
   k=: =/p                   NB. keep non-paren tokens
   merge d <@]^:[&.>&(k&#) t NB. exercise task
}}
