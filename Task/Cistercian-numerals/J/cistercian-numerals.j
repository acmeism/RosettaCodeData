NB. http://rosettacode.org/wiki/Cistercian_numerals
NB. converted from
NB. https://scipython.com/blog/cistercian-numerals/

Dyad=: [: :

NB. numeric_vector format 'python {} string'
format=: ''&$: :([: ; (a: , [: ":&.> [) ,. '{}' ([ (E. <@}.;._1 ]) ,) ])  NB. literals x should be boxed

pwd=:1!:43
rm=: 1!:55@boxopen ::empty
print=: echo@[ NB. debug
print=: (1!:3~,&LF)~ Dyad
open=: 1!:21
close=: 1!:22

NB.# http://en.kpartner.kr/data/warrant-check-pzmwqyk/qrf56.php?3fff1d=cistercian-numbers-unicode
NB.
NB.# The paths to create the digits 1–9 in the "units" position.
NB.d_paths = {
NB.(0, 1): ((1, 0), (2, 0)),
NB.(0, 2): ((1, 1), (2, 1)),
NB.(0, 3): ((1, 0), (2, 1)),
NB.(0, 4): ((1, 1), (2, 0)),
NB.(0, 5): ((1, 1), (2, 0), (1, 0)),
NB.(0, 6): ((2, 0), (2, 1)),
NB.(0, 7): ((1, 0), (2, 0), (2, 1)),
NB.(0, 8): ((1, 1), (2, 1), (2, 0)),
NB.(0, 9): ((1, 1), (2, 1), (2, 0), (1, 0)),
NB.}
NB.# Generate the paths for the digits in the 10s, 100s and 1000s position by
NB.# reflection.
NB.for i in range(1, 10):
NB.    d_paths[(1, i)] = [(2-x, y) for x, y in d_paths[(0, i)]]
NB.    d_paths[(2, i)] = [(x, 3-y) for x, y in d_paths[(0, i)]]
NB.    d_paths[(3, i)] = [(2-x, 3-y) for x, y in d_paths[(0, i)]]
NB.
d_paths=: _2[\L:0]((1, 0), (2, 0));((1, 1), (2, 1));((1, 0), (2, 1));((1, 1), (2, 0));((1, 1), (2, 0), (1, 0));((2, 0), (2, 1));((1, 0), (2, 0), (2, 1));((1, 1), (2, 1), (2, 0));((1, 1), (2, 1), (2, 0), (1, 0))
d_paths=: (, ((2-[),])/"1 L:0 , (,3&-)/"1 L:0 , ((2-[),(3-]))/"1 L:0) d_paths
d_paths=: , a: ,. _9]\ d_paths  NB. adjust indexing
NB.echo d_paths NB. test

NB.def transform(x, y, dx, dy, sc):
NB.    """Transform the coordinates (x, y) into the scaled, displaced system."""
NB.    return x*sc + dx, y*sc + dy
NB.
transform=: (] p.~ [: (2&{. (,.) 2 $ 2&}.) [) Dyad  NB. (dx dy sx [sy]) transform (x y)

NB.def get_path(i, d):
NB.    """Return the SVG path to render the digit d in decimal position i."""
NB.    if d == 0:
NB.        return
NB.    path = d_paths[(i, d)]
NB.    return 'M{},{} '.format(*transform(*path[0], *tprms)) + ' '.join(
NB.                ['L{},{}'.format(*transform(*xy, *tprms)) for xy in path[1:]])
NB.
get_path=: 3 :0
 'i d'=. y
 if. d do.
  path=. d_paths {::~ 10 #. y
  result=. 'M{},{} 'format~ TPRMS transform {. path
  result=. result , }: , ' ' ,.~ 'L{},{}'format"1~TPRMS transform"1 }. path
 else.
  ''
 end.
)

NB.def make_digit(i, d):
NB.    """Output the SVG path element for digit d in decimal position i."""
NB.    print('<path d="{}"/>'.format(get_path(i, d)), file=fo)
NB.
make_digit=: (print~ (('<path d="{}"/>') (format~ <) get_path)) Dyad NB. fo make_digit n

NB.def make_stave():
NB.    """Output the SVG line element for the vertical stave."""
NB.    x1, y1 = transform(1, 0, *tprms)
NB.    x2, y2 = transform(1, 3, *tprms)
NB.    print('<line x1="{}" y1="{}" x2="{}" y2="{}"/>'.format(x1, y1, x2, y2),
NB.          file=fo)
make_stave=: 3 :'y print~ ''<line x1="{}" y1="{}" x2="{}" y2="{}"/>'' format~ , TPRMS (transform"1) 1 0,:1 3'

NB.def svg_preamble(fo):
NB.    """Write the SVG preamble, including the styles."""
NB.
NB.    # Set the path stroke-width appropriate to the scale.
NB.    stroke_width = max(1.5, tprms[2] / 5)
NB.    print("""<?xml version="1.0" encoding="utf-8"?>
NB.<svg xmlns="http://www.w3.org/2000/svg"
NB.     xmlns:xlink="http://www.w3.org/1999/xlink" width="2000" height="2005" >
NB.<defs>
NB.<style type="text/css"><![CDATA[
NB.line, path {
NB.  stroke: black;
NB.  stroke-width: %d;
NB.  stroke-linecap: square;
NB.}
NB.path {
NB.  fill: none;
NB.}
NB.]]>
NB.</style>
NB.</defs>
NB.""" % stroke_width, file=fo)
NB.
PREAMBLE=: 0 :0
<?xml version="1.0" encoding="utf-8"?>
<svg xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink" width="2000" height="2005" >
<defs>
<style type="text/css"><![CDATA[
line, path {
  stroke: black;
  stroke-width: {};
  stroke-linecap: square;
}
path {
  fill: none;
}
]]>
</style>
</defs>
)

svg_preamble=: 3 :'(PREAMBLE format~ 1.5 >. 5 *inv 2 { TPRMS) print y'

NB.def make_numeral(n, fo):
NB.    """Output the SVG for the number n using the current transform."""
NB.    make_stave()
NB.    for i, s_d in enumerate(str(n)[::-1]):
NB.        make_digit(i, int(s_d))
NB.
make_numeral=: 4 :0
 fo=. x
 n=. y
 make_stave fo
 if. y do.
  fo make_digit"1 (,.~ i.@#) |. 10 #.inv n
 end.
)

NB.# Transform parameters: dx, dy, scale.
NB.tprms = [5, 5, 5]
NB.
NB.with open('all_cistercian_numerals.svg', 'w') as fo:
NB.    svg_preamble(fo)
NB.    for i in range(10000):
NB.        # Locate this number at the position dx, dy = tprms[:2].
NB.        tprms[0] = 15 * (i % 125) + 5
NB.        tprms[1] = 25 * (i // 125) + 5
NB.        make_numeral(i, fo)
NB.    print("""</svg>""", file=fo)
main=: 3 :0 ::('Use: main ''filename.svg'''"_)
 TPRMS=: 5 5 5
 rm<y
 fo=. open<y
 svg_preamble fo
 for_i. i. 10000 do.
  TPRMS=: (5 ,~ (5 + 15 * 125 | ]) , 5 + 25 * [: (<.) 125 *^:_1 ]) i
  fo make_numeral i
 end.
 '</svg>' print fo
 empty close fo
 'open browser to {}/{}' format~ (pwd'') ; y
)
rc=: 3 :0 ::('Use: rc ''filename.svg'''"_)
 scale=. 5
 TPRMS=: 5 5 , scale
 rm<y
 fo=. open<y
 svg_preamble fo
 RC=. 0 1 20 300 666 4000 5555 6789
 echo 'writing {}' format~ < RC
 for_k. (,.~ i.@#) RC do.
  'j i'=. k
  TPRMS=: (scale ,~ (5 + scale * 15 * 125 | ]) , 5 + scale * 25 * [: (<.) 125 *^:_1 ]) j
  fo make_numeral i
 end.
 '</svg>' print fo
 empty close fo
 'open browser to {}{}{}' format~ (pwd'') ; PATHJSEP_j_ ; y
)
