package main

import (
    "fmt"
    "html/template"
    "log"
    "os"
    "os/exec"
    "strings"
    "time"
)

type row struct {
    Address, Street, House, Color string
}

func isDigit(b byte) bool {
    return '0' <= b && b <= '9'
}

func separateHouseNumber(address string) (street string, house string) {
    length := len(address)
    fields := strings.Fields(address)
    size := len(fields)
    last := fields[size-1]
    penult := fields[size-2]
    if isDigit(last[0]) {
        isdig := isDigit(penult[0])
        if size > 2 && isdig && !strings.HasPrefix(penult, "194") {
            house = fmt.Sprintf("%s %s", penult, last)
        } else {
            house = last
        }
    } else if size > 2 {
        house = fmt.Sprintf("%s %s", penult, last)
    }
    street = strings.TrimRight(address[:length-len(house)], " ")
    return
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

var tmpl = `
<head>
  <title>Rosetta Code - Start a Web Browser</title>
  <meta charset="UTF-8">
</head>
<body bgcolor="#d8dcd6">
  <table border="2">
    <p align="center">
      <font face="Arial, sans-serif" size="5">Split the house number from the street name</font>
      <tr bgcolor="#02ccfe"><th>Address</th><th>Street</th><th>House Number</th></tr>
      {{range $row := .}}
      <tr bgcolor={{$row.Color}}>
        <td>{{$row.Address}}</td>
        <td>{{$row.Street}}</td>
        <td>{{$row.House}}</td>
      </tr>
      {{end}}
    </p>
  </table>
</body>
`
func main() {
    addresses := []string{
        "Plataanstraat 5",
        "Straat 12",
        "Straat 12 II",
        "Dr. J. Straat   12",
        "Dr. J. Straat 12 a",
        "Dr. J. Straat 12-14",
        "Laan 1940 - 1945 37",
        "Plein 1940 2",
        "1213-laan 11",
        "16 april 1944 Pad 1",
        "1e Kruisweg 36",
        "Laan 1940-'45 66",
        "Laan '40-'45",
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
    }
    browser := "firefox" // or whatever
    colors := [2]string{"#d7fffe", "#9dbcd4"}
    fileName := "addresses_table.html"
    ct := template.Must(template.New("").Parse(tmpl))
    file, err := os.Create(fileName)
    check(err)
    rows := make([]row, len(addresses))
    for i, address := range addresses {
        street, house := separateHouseNumber(address)
        if house == "" {
            house = "(none)"
        }
        color := colors[i%2]
        rows[i] = row{address, street, house, color}
    }
    err = ct.Execute(file, rows)
    check(err)
    cmd := exec.Command(browser, fileName)
    err = cmd.Run()
    check(err)
    file.Close()
    time.Sleep(5 * time.Second) // wait for 5 seconds before deleting file
    err = os.Remove(fileName)
    check(err)
}
