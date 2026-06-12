require'format/printf'

sunfract=: {{ NB. y: number of "sunflower seeds"
  phi=. 0.5*1+%:5
  XY=. (y%10)+(2*(I^phi)%y) * +.^j.2*1p1*phi*I=.1+i.y
  XY,.(%:I)%13
}}

sunfractsvg=: {{
  fract=. sunfract x
  C=.,'\n<circle cx="%.2f" cy="%.2f" r="%.1f" />' sprintf fract
  ({{)n
    <svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" style="stroke:gold">
      <rect width="100%%" height="100%%" fill="black" />
        %s
    </svg>
}} sprintf (;/<.20+}:>./fract),<C) fwrite y}}
