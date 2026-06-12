package main

import (
    "fmt"
    "github.com/beevik/etree"
    "log"
    "os"
    "strconv"
    "strings"
)

type animData struct {
    element *etree.Element
    attrib  string
    from    string
    to      string
    begin   float64
    dur     float64
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func (ad *animData) AtTime(t float64) string {
    beg := ad.begin
    end := beg + ad.dur
    if t < beg || t > end {
        log.Fatalf("time must be in interval [%g, %g]", beg, end)
    }
    fromSplit := strings.Fields(ad.from)
    toSplit := strings.Fields(ad.to)
    le := len(fromSplit)
    interSplit := make([]string, le)
    for i := 0; i < le; i++ {
        fromF, err := strconv.ParseFloat(fromSplit[i], 64)
        check(err)
        toF, err := strconv.ParseFloat(toSplit[i], 64)
        check(err)
        interF := (fromF*(end-t) + toF*(t-beg)) / ad.dur
        interSplit[i] = fmt.Sprintf("%.2f", interF)
    }
    return strings.Join(interSplit, " ")
}

func main() {
    doc := etree.NewDocument()
    check(doc.ReadFromFile("smil.xml"))
    smil := doc.SelectElement("smil")
    if smil == nil {
        log.Fatal("'smil' element not found")
    }
    x3d := smil.SelectElement("X3D")
    if x3d == nil {
        log.Fatal("'X3D' element not found")
    }
    doc.SetRoot(x3d) // remove 'smil' element
    var ads []*animData
    for _, a := range doc.FindElements("//animate") {
        attrib := a.SelectAttrValue("attributeName", "?")
        from := a.SelectAttrValue("from", "?")
        to := a.SelectAttrValue("to", "?")
        beginS := a.SelectAttrValue("begin", "?")
        durS := a.SelectAttrValue("dur", "?")
        if attrib == "?" || from == "?" || to == "?" ||
            beginS == "?" || durS == "?" {
            log.Fatal("an animate element has missing attribute(s)")
        }
        begin, err := strconv.ParseFloat(beginS[:len(beginS)-1], 64)
        check(err)
        dur, err := strconv.ParseFloat(durS[:len(durS)-1], 64)
        check(err)
        p := a.Parent()
        if p == nil {
            log.Fatal("an animate element has no parent")
        }
        pattrib := p.SelectAttrValue(attrib, "?")
        if pattrib == "?" {
            log.Fatal("an animate element's parent has missing attribute")
        }
        ads = append(ads, &animData{p, attrib, from, to, begin, dur})
        p.RemoveChild(a) // remove 'animate' element
    }
    ts := []float64{0, 2}
    for _, t := range ts {
        for _, ad := range ads {
            s := ad.AtTime(t)
            ad.element.CreateAttr(ad.attrib, s)
        }
        doc.Indent(2)
        fmt.Printf("At time = %g seconds:\n\n", t)
        doc.WriteTo(os.Stdout)
        fmt.Println()
    }
}
