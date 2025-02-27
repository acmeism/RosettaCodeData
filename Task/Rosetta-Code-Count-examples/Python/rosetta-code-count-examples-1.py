from urllib.request import urlopen, Request
import xml.dom.minidom

r = Request(
    "https://rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=xml",
    headers={"User-Agent": "Mozilla/5.0"},
)
x = urlopen(r)

tasks = []
for i in xml.dom.minidom.parseString(x.read()).getElementsByTagName("cm"):
    t = i.getAttribute("title").replace(" ", "_").replace("+", "%2B")
    r = Request(
        f"https://rosettacode.org/w/index.php?title={t}&action=raw",
        headers={"User-Agent": "Mozilla/5.0"},
    )
    y = urlopen(r)
    tasks.append(y.read().lower().count(b"{{header|"))
    print(t.replace("_", " ") + f": {tasks[-1]} examples.")

print(f"\nTotal: {sum(tasks)} examples.")
