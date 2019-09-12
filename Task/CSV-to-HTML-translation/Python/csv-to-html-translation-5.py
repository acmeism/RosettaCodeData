from csv import DictReader
from xml.etree import ElementTree as ET

def csv2html_robust(txt, header=True, attr=None):
    # Use DictReader because, despite what the docs say, reader() doesn't
    # return an object with .fieldnames
    # (DictReader expects an iterable that returns lines, so split on \n)
    reader = DictReader(txt.split('\n'))

    table = ET.Element("TABLE", **attr.get('TABLE', {}))
    thead_tr = ET.SubElement(
        ET.SubElement(table, "THEAD", **attr.get('THEAD', {})),
        "TR")
    tbody = ET.SubElement(table, "TBODY", **attr.get('TBODY', {}))

    if header:
        for name in reader.fieldnames:
            ET.SubElement(thead_tr, "TD").text = name

    for row in reader:
        tr_elem = ET.SubElement(tbody, "TR", **attr.get('TR', {}))

        # Use reader.fieldnames to query `row` in the correct order.
        # (`row` isn't an OrderedDict prior to Python 3.6)
        for field in reader.fieldnames:
            td_elem = ET.SubElement(tr_elem, "TD", **attr.get('TD', {}))
            td_elem.text = row[field]

    return ET.tostring(table, method='html')

htmltxt = csv2html_robust(csvtxt, True, {
    'TABLE': {'border': "1", 'summary': "csv2html extra program output"},
    'THEAD': {'bgcolor': "yellow"},
    'TBODY': {'bgcolor': "orange"}
})

print(htmltxt.decode('utf8'))
