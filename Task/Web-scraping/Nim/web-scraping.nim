import httpclient, strutils

var client = newHttpClient()

var res: string
for line in client.getContent("https://rosettacode.org/wiki/Talk:Web_scraping").splitLines:
  let k = line.find("UTC")
  if k >= 0:
    res = line[0..(k - 3)]
    let k = res.rfind("</a>")
    res = res[(k + 6)..^1]
    break
echo if res.len > 0: res else: "No date/time found."
