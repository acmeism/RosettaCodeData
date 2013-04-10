package ddate

import (
    "strconv"
    "strings"
    "time"
)

// Predefined formats for DiscDate.Format
const (
    DefaultFmt = "Pungenday, Discord 5, 3131 YOLD"
    OldFmt     = `Today is Pungenday, the 5th day of Discord in the YOLD 3131
Celebrate Mojoday`
)

// Formats passed to DiscDate.Format are protypes for formated dates.
// Format replaces occurrences of prototype elements (the constant strings
// listed here) with values corresponding to the date being formatted.
// If the date is St. Tib's Day, the string from the first date element
// through the last is replaced with "St. Tib's Day".
const (
    protoLongSeason  = "Discord"
    protoShortSeason = "Dsc"
    protoLongDay     = "Pungenday"
    protoShortDay    = "PD"
    protoOrdDay      = "5"
    protoCardDay     = "5th"
    protoHolyday     = "Mojoday"
    protoYear        = "3131"
)

var (
    longDay = []string{"Sweetmorn", "Boomtime", "Pungenday",
        "Prickle-Prickle", "Setting Orange"}
    shortDay   = []string{"SM", "BT", "PD", "PP", "SO"}
    longSeason = []string{
        "Chaos", "Discord", "Confusion", "Bureaucracy", "The Aftermath"}
    shortSeason = []string{"Chs", "Dsc", "Cfn", "Bcy", "Afm"}
    holyday     = [][]string{{"Mungday", "Chaoflux"}, {"Mojoday", "Discoflux"},
        {"Syaday", "Confuflux"}, {"Zaraday", "Bureflux"}, {"Maladay", "Afflux"}}
)

type DiscDate struct {
    StTibs bool
    Dayy   int // zero based day of year, meaningless if StTibs is true
    Year   int // gregorian + 1166
}

func New(eris time.Time) DiscDate {
    t := time.Date(eris.Year(), 1, 1, eris.Hour(), eris.Minute(),
        eris.Second(), eris.Nanosecond(), eris.Location())
    bob := int(eris.Sub(t).Hours()) / 24
    raw := eris.Year()
    hastur := DiscDate{Year: raw + 1166}
    if raw%4 == 0 && (raw%100 != 0 || raw%400 == 0) {
        if bob > 59 {
            bob--
        } else if bob == 59 {
            hastur.StTibs = true
            return hastur
        }
    }
    hastur.Dayy = bob
    return hastur
}

func (dd DiscDate) Format(f string) (r string) {
    var st, snarf string
    var dateElement bool
    f6 := func(proto, wibble string) {
        if !dateElement {
            snarf = r
            dateElement = true
        }
        if st > "" {
            r = ""
        } else {
            r += wibble
        }
        f = f[len(proto):]
    }
    f4 := func(proto, wibble string) {
        if dd.StTibs {
            st = "St. Tib's Day"
        }
        f6(proto, wibble)
    }
    season, day := dd.Dayy/73, dd.Dayy%73
    for f > "" {
        switch {
        case strings.HasPrefix(f, protoLongDay):
            f4(protoLongDay, longDay[dd.Dayy%5])
        case strings.HasPrefix(f, protoShortDay):
            f4(protoShortDay, shortDay[dd.Dayy%5])
        case strings.HasPrefix(f, protoCardDay):
            funkychickens := "th"
            if day/10 != 1 {
                switch day % 10 {
                case 0:
                    funkychickens = "st"
                case 1:
                    funkychickens = "nd"
                case 2:
                    funkychickens = "rd"
                }
            }
            f4(protoCardDay, strconv.Itoa(day+1)+funkychickens)
        case strings.HasPrefix(f, protoOrdDay):
            f4(protoOrdDay, strconv.Itoa(day+1))
        case strings.HasPrefix(f, protoLongSeason):
            f6(protoLongSeason, longSeason[season])
        case strings.HasPrefix(f, protoShortSeason):
            f6(protoShortSeason, shortSeason[season])
        case strings.HasPrefix(f, protoHolyday):
            if day == 4 {
                r += holyday[season][0]
            } else if day == 49 {
                r += holyday[season][1]
            }
            f = f[len(protoHolyday):]
        case strings.HasPrefix(f, protoYear):
            r += strconv.Itoa(dd.Year)
            f = f[4:]
        default:
            r += f[:1]
            f = f[1:]
        }
    }
    if st > "" {
        r = snarf + st + r
    }
    return
}
