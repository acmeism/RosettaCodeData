deck=: >,{;:each'one two three';'red green purple';'solid striped open';'diamond oval squiggle'
deal=: (?#) { ]

sets=:  {{ >;sets0\y }}
sets0=: {{ <;({:y) sets1\}:y }}
sets1=: {{ <~.;({:y) sets2 m\}:y }}
sets2=: {{ <(m,:n)<@,"2 1 y#~m isset n"1 y }}
isset=: {{ 1=#~.(m=n),(m=y),:n=y }}

disp=: <@(;:inv)"1
