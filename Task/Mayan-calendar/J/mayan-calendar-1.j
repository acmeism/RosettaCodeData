require 'types/datetime'

NB. 1794214= (0 20 18 20 20#.13 0 0 0 0)-todayno 2012 12 21
longcount=: {{ rplc&' .'":0 20 18 20 20#:y+1794214 }}

tsolkin=: (cut {{)n
   Imix’   Ik’     Ak’bal    K’an    Chikchan
   Kimi    Manik’  Lamat     Muluk   Ok
   Chuwen  Eb      Ben       Hix     Men
   K’ib’   Kaban   Etz’nab’  Kawak   Ajaw
}}-.LF){{ (":1+13|y-4),' ',(20|y-7){::m }}

haab=:(cut {{)n
   Pop      Wo’       Sip     Sotz’   Sek      Xul
   Yaxk’in  Mol       Ch’en   Yax     Sak’     Keh
   Mak      K’ank’in  Muwan   Pax     K’ayab   Kumk’u
   Wayeb’
}}-.LF){{
  'M D'=.0 20#:365|y-143
  ({{ if.*y do.":y else.'Chum'end. }} D),' ',(M-0=D){::m
}}

round=: [:;:inv tsolkin;haab;'G',&":1+9|]

gmt=: >@(fmtDate;round;longcount)@todayno
