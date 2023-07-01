$htmlformat  = '<title>Csv to Html</title>'
$htmlformat += '<style type="text/css">'
$htmlformat += 'BODY{background-color:#663300;color:#FFCC00;font-family:Arial Narrow,sans-serif;font-size:17px;}'
$htmlformat += 'TABLE{border-width: 3px;border-style: solid;border-color: black;border-collapse: collapse;}'
$htmlformat += 'TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:#663333}'
$htmlformat += 'TD{border-width: 1px;padding: 8px;border-style: solid;border-color: black;background-color:#660033}'
$htmlformat += '</style>'
Import-Csv -Path .\csv_html_test.csv | ConvertTo-Html -Head $htmlformat -Body '<h1>Csv to Html</h1>' | Out-File .\csv_html_test.html
Invoke-Expression .\csv_html_test.html
