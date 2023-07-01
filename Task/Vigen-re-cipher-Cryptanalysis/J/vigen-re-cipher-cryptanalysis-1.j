NB. https://en.wikipedia.org/wiki/Kasiski_examination
kasiski=: {{
  grams=. ({: #"1~1 < ;@{.)|:(#/.~;"0~.) g=. 3 <\ y
  deltas=. ;grams (2 -~/\ I.@E.)L:0 enc
  {:,{.\:~(#/.~,.~.)1 -.~,+./~ deltas
}}

NB. https://en.wikipedia.org/wiki/Letter_frequency
AZ=: 8 u: 65+i.26
lfreq=: 0.01*do{{)n
 8.2 1.5 2.8 4.3 13 2.2 2 6.1 7 0.15
 0.77 4 2.4 6.7 7.5 1.9 0.095 6 6.3 9.1
 2.8 0.98 2.4 0.15 2 0.074
}}-.LF


caesarkey=: {{
  freqs=. (<:#/.~AZ,y)%#y=. y ([-.-.) AZ
  AZ{~(i. <./)lfreq +/&.:*:@:-"1 (i.26)|."0 1 freqs
}}
vigenerekey=: {{ caesarkey"1|:(-kasiski y) ]\y }}

uncaesar=: {{ 26&|@-&(AZ i.x)&.(AZ&i.) y }}"0 1
unvigenere=: {{ ' '-.~,x uncaesar"0 1&.|:(-#x) ]\y }}
