TASKS=: fread '~/tasks.txt' NB. from Sorensen–Dice_coefficient/Tasks
sdtok=: [: (#~  ' '*/ .~:~])2]\ 7 u: tolower@rplc&(LF,' ')
sdinter=: {{
  all=. ~.x,y
  X=. <:#/.~all,x
  Y=. <:#/.~all,y
  +/X<.Y
}}
sdunion=: #@,
SDC=: (2 * sdinter % sdunion)&sdtok S:0
nearest=: {{ m{.\:~ x (] ;"0~ SDC) cutLF y }}
fmt=: ((8j6": 0{::]),' ',1{::])"1
