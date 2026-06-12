require'format/printf'
penrosesvg=: {{
  penrose=. rplc&(".{{)n
    'A';'';
    'M';'OA++PA----NA(-OA----MA)++';
    'N';'+OA--PA(---MA--NA)+';
    'O';'-MA++NA(+++OA++PA)-';
    'P';'--OA++++MA(+PA++++NA)--NA'
}}-.LF)^:y '(N)++(N)++(N)++(N)++(N)'
  LINE=. 2 2$0
  A=. a=. o.%5
  R=. 20
  LINES=. STACK=. EMPTY
  for_ch. penrose do.
    select. ch
      case. 'A' do. LINES=. LINES,,LINE=. (R*0,:2 1 o. A)+"1 {:LINE
      case. '+' do. A=. A+a
      case. '-' do. A=. A-a
      case. '(' do. STACK=. STACK, A;LINE
      case. ')' do. STACK=. }: STACK [ 'A LINE'=. {: STACK
    end.
  end.
  OFF=. 25+>.>./,LINES=. ~.LINES
  assert 1<(F=.'penrose_tiling_%d.svg' sprintf y) fwrite~ {{)n
<svg xmlns="http://www.w3.org/2000/svg" height="%d" width="%d">
  <rect height="100%%" width="100%%" style="fill:black" />
%s
</svg>
}} sprintf (2#<2*OFF),<}:,{{)n
  <line x1="%.1f" y1="%.1f" x2="%.1f" y2="%.1f" style="stroke:rgb(255,165,0)"/>
}} sprintf"1 OFF+LINES
  (jpathsep 1!:43''),'/',F
}}
