def formatCell = { cell ->
    "<td>${cell.replaceAll('&','&amp;').replaceAll('<','&lt;')}</td>"
}

def formatRow = { row ->
    """<tr>${row.split(',').collect { cell -> formatCell(cell) }.join('')}</tr>
"""
}

def formatTable = { csv, header=false ->
    def rows = csv.split('\n').collect { row -> formatRow(row) }
    header \
        ? """
<table>
<thead>
${rows[0]}</thead>
<tbody>
${rows[1..-1].join('')}</tbody>
</table>
""" \
        : """
<table>
${rows.join('')}</table>
"""
}

def formatPage = { title, csv, header=false ->
"""<html>
<head>
<title>${title}</title>
<style type="text/css">
td {background-color:#ddddff; }
thead td {background-color:#ddffdd; text-align:center; }
</style>
</head>
<body>${formatTable(csv, header)}</body>
</html>"""
}
