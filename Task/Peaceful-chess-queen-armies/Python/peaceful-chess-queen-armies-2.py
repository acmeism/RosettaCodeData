from peaceful_queen_armies_simpler import place
from itertools import product, count

_bqueenh, _wqueenh = '&#x265b;', '<font color="green">&#x2655;</font>'

def hboard(black_white, n):
    "HTML board generator"
    if black_white is None:
        blk, wht = set(), set()
    else:
        blk, wht = black_white
    out = (f"<br><b>## {len(blk)} black and {len(wht)} white queens "
           f"on a {n}-by-{n} board</b><br>\n")
    out += '<table style="font-weight:bold">\n  '
    tbl = ''
    for x, y in product(range(n), repeat=2):
        if y == 0:
            tbl += '  </tr>\n  <tr valign="middle" align="center">\n'
        xy = (x, y)
        ch = ('<span style="color:red">?</span>' if xy in blk and xy in wht
              else _bqueenh if xy in blk
              else _wqueenh if xy in wht
              else "")
        bg = "" if (x + y)%2 else ' bgcolor="silver"'
        tbl += f'    <td style="width:14pt; height:14pt;"{bg}>{ch}</td>\n'
    out += tbl[7:]
    out += '  </tr>\n</table>\n<br>\n'
    return out

if __name__ == '__main__':
    n=2
    html = ''
    for n in range(2, 7):
        print()
        for m in count(1):
            ans = place(m, n)
            if ans[0]:
                html += hboard(ans, n)
            else:
                html += (f"<b># Can't place {m} queen armies on a "
                         f"{n}-by-{n} board</b><br><br>\n\n" )
                break
    #
    html += '<br>\n'
    m, n = 6, 7
    ans = place(m, n)
    html += hboard(ans, n)
    with open('peaceful_queen_armies.htm', 'w') as f:
        f.write(html)
