decaesar=: {{
  freqs=. (<:#/.~AZ,y)%#y=. y ([-.-.) AZ
  ndx=. (i. <./)lfreq +/&.:*:@:-"1 (i.26)|."0 1 freqs
  26&|@-&ndx&.(AZ&i.) y
}}
devigenere=: {{ ' '-.~,decaesar"1&.|:(-kasiski y) ]\y }}
