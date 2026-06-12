import os
import re
import time
import webbrowser

ADDRESSES = [
    "Plataanstraat 5",
    "Straat 12",
    "Straat 12 II",
    "Dr. J. Straat   12",
    "Dr. J. Straat 12 a",
    "Dr. J. Straat 12-14",
    "Laan 1940 – 1945 37",
    "Plein 1940 2",
    "1213-laan 11",
    "16 april 1944 Pad 1",
    "1e Kruisweg 36",
    "Laan 1940-’45 66",
    "Laan ’40-’45",
    "Langeloërduinen 3 46",
    "Marienwaerdt 2e Dreef 2",
    "Provincialeweg N205 1",
    "Rivium 2e Straat 59.",
    "Nieuwe gracht 20rd",
    "Nieuwe gracht 20rd 2",
    "Nieuwe gracht 20zw /2",
    "Nieuwe gracht 20zw/3",
    "Nieuwe gracht 20 zw/4",
    "Bahnhofstr. 4",
    "Wertstr. 10",
    "Lindenhof 1",
    "Nordesch 20",
    "Weilstr. 6",
    "Harthauer Weg 2",
    "Mainaustr. 49",
    "August-Horch-Str. 3",
    "Marktplatz 31",
    "Schmidener Weg 3",
    "Karl-Weysser-Str. 6",
]


def split_address(address: str):
    arr = [
        item.strip()
        for item in re.split(
            r"(\s\d+[-/]\d+)|(\s(?!1940|1945)\d+[a-zI. /]*\d*)$|\d+\['][40|45]$",
            address,
        )
        if item is not None and item != ""
    ]

    if len(arr) < 2:
        return arr[0], ""

    return arr


def main():
    HTML_HEADER = """
        <html>
        <head>
        <title>Rosetta Code - Start a Web Browser</title>
        <meta charset="UTF-8">
        </head>
        <body bgcolor="#e6e6ff">
        <p align="center">
        <font face="Arial, sans-serif" size="5">Split the house number from the street name</font>
        </p>
        <p align="center">
        <table border="2"> <tr bgcolor="#9bbb59">
        <th>Address</th><th>Street</th><th>House Number</th>
    """

    HTML_FOOTER = """
        </table>
        </p>
        </body>
        </html>
    """

    HTML_LINE = "<tr bgcolor={0}><td>{1}</td><td>{2}</td><td>{3}</td></tr>"

    with open("index.html", "w") as html_file:
        html_file.write(HTML_HEADER)

        for i, addr in enumerate(ADDRESSES):
            color = "#ebf1de" if i & 1 == 0 else "#d8e4bc"
            street, number = split_address(addr)
            html_file.write(HTML_LINE.format(color, addr, street, number))

        html_file.write(HTML_FOOTER)

    webbrowser.open("index.html")
    time.sleep(5)
    os.remove("index.html")


if __name__ == "__main__":
    main()
