using DataFrames, CSV

using CSV, DataFrames

function csv2html(fname; header::Bool=false)
    csv = CSV.read(fname)
    @assert(size(csv, 2) > 0)
    str = """
<html>

<head>
    <style type="text/css">
        body {
            margin: 2em;
        }
        h1 {
            text-align: center;
        }
        table {
            border-spacing: 0;
            box-shadow: 0 0 0.25em #888;
            margin: auto;
        }
        table,
        tr,
        th,
        td {
            border-collapse: collapse;
        }
        th {
            color: white;
            background-color: rgb(43, 53, 59);
        }
        th,
        td {
            padding: 0.5em;
        }
        table tr:nth-child(even) td {
            background-color: rgba(218, 224, 229, 0.850);
        }
    </style>
</head>

<body>
    <h1>csv2html Example</h1>
    <table>
        <tr>
"""
    tags = header ? ("<th>", "</th>") : ("<td>", "</td>")

    for i=1:size(csv, 2)
        str *= "            " * tags[1] * csv[1, i] * tags[2] * "\n"
    end

    str *= " "^8 * "</tr>\n"

    for i=2:size(csv, 1)
        str *= "        <tr>\n"

        for j=1:size(csv, 2)
            str *= "            " * "<td>" * csv[i, j] * "</td>\n"
        end

        str *= "        </tr>\n"
    end

    str * "    </table>\n</body>\n\n</html>\n"
end

print(csv2html("input.csv", header=true))
