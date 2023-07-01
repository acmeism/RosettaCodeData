import groovy.xml.MarkupBuilder

def formatRow = { doc, row ->
    doc.tr { row.each { cell -> td { mkp.yield(cell) } } }
}

def formatPage = { titleString, csv, header=false ->
    def writer = new StringWriter()
    def doc = new MarkupBuilder(writer)
    def rows = csv.split('\n').collect { row -> row.split(',') }
    doc.html {
        head {
            title (titleString)
            style (type:"text/css") {
                mkp.yield('''
                    td {background-color:#ddddff; }
                    thead td {background-color:#ddffdd; text-align:center; }
                ''')
            }
        }
        body {
            table {
                header && thead { formatRow(doc, rows[0]) }
                header && tbody { rows[1..-1].each { formatRow(doc, it) } }
                header || rows.each { formatRow(doc, it) }
            }
        }
    }
    writer.toString()
}
