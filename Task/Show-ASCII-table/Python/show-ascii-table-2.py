from unicodedata import name
from html import escape

def pp(n):
    if n <= 32:
        return chr(0x2400 + n)
    if n == 127:
        return '␡'
    return chr(n)

print('<table border="3px" style="background-color:LightCyan;text-align:center">\n <tr>')
for n in range(128):
    if n %16 == 0 and 1 < n:
        print(" </tr><tr>")
    print(f'  <td style="center">{n}<br>0x{n:02x}<br><big><b title="{escape(name(pp(n)))}">{escape(pp(n))}</b></big></td>')
print(""" </tr>\n</table>""")
