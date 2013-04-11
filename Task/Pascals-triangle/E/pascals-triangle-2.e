def out := <file:triangle.html>.textWriter()
try {
    pascalsTriangle(15, out)
} finally {
    out.close()
}
makeCommand("yourFavoriteWebBrowser")("triangle.html")
