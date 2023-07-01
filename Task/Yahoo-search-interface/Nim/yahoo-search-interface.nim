import httpclient, strutils, htmlparser, xmltree, strtabs
const
  PageSize = 7
  YahooURLPattern = "https://search.yahoo.com/search?fr=opensearch&b=$$#&pz=$#&p=".format(PageSize)
type
  SearchResult = ref object
    url, title, content: string
  SearchInterface = ref object
    client: HttpClient
    urlPattern: string
    page: int
    results: array[PageSize+2, SearchResult]
proc newSearchInterface(question: string): SearchInterface =
  new result
  result.client = newHttpClient()
#  result.client = newHttpClient(proxy = newProxy(
#      "http://localhost:40001")) # only http_proxy supported
  result.urlPattern = YahooURLPattern&question
proc search(si: SearchInterface) =
  let html = parseHtml(si.client.getContent(si.urlPattern.format(
      si.page*PageSize+1)))
  var
    i: int
    attrs: XmlAttributes
  for d in html.findAll("div"):
    attrs = d.attrs
    if attrs != nil and attrs.getOrDefault("class").startsWith("dd algo algo-sr relsrch"):
      let d_inner = d.child("div")
      for a in d_inner.findAll("a"):
        attrs = a.attrs
        if attrs != nil and attrs.getOrDefault("class") == " ac-algo fz-l ac-21th lh-24":
          si.results[i] = SearchResult(url: attrs["href"], title: a.innerText,
              content: d.findAll("p")[0].innerText)
          i+=1
          break
  while i < len(si.results) and si.results[i] != nil:
    si.results[i] = nil
    i+=1
proc nextPage(si: SearchInterface) =
  si.page+=1
  si.search()

proc echoResult(si: SearchInterface) =
  for res in si.results:
    if res == nil:
      break
    echo(res[])

var searchInf = newSearchInterface("weather")
searchInf.search()
searchInf.echoResult()
echo("searching for next page...")
searchInf.nextPage()
searchInf.echoResult()
