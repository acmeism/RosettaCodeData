import requests
import html

text = "Python"
font = "larry3d"
url = f"http://www.network-science.de/ascii/ascii.php?TEXT={text}&FONT={font}&RICH=no&FORM=left&WIDT=1000"

r = requests.get(url)
r.raise_for_status()

ascii_text = html.unescape(r.text)
pre_ascii = "<TD><PRE>"
post_ascii = "\n</PRE>"
ascii_text = ascii_text[ascii_text.index(pre_ascii) + len(pre_ascii):]
ascii_text = ascii_text[:ascii_text.index(post_ascii)]

print(ascii_text)
