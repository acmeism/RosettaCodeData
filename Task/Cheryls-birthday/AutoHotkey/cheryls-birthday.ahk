oDates:=    {"May" : [        15,    16,         19]
            ,"Jun" : [                17, 18]
            ,"Jul" : [14,         16]
            ,"Aug" : [14,     15,     17]}

filter1(oDates)
filter2(oDates)
filter3(oDates)
MsgBox % result := checkAnswer(oDates)
return

filter1(ByRef oDates){                        ; remove months that has a unique day in it.
    for d, obj in MonthsOfDay(oDates)
        if (obj.count() = 1)
            for m, bool in obj
                oDates.Remove(m)
}

filter2(ByRef oDates){                        ; remove non-unique days from remaining months.
    for d, obj in MonthsOfDay(oDates)
        if (obj.count() > 1)
            for m, bool in obj
                for i, day in oDates[m]
                    if (day=d)
                        oDates[m].Remove(i)
}

filter3(ByRef oDates){                        ; remove months that has multiple days from remaining months.
    oRemove := []
    for m, obj in oDates
        if obj.count() > 1
            oRemove.Push(m)
    for i, m in oRemove
        oDates.Remove(m)
}

MonthsOfDay(oDates){                        ; create a list of months per day.
    MonthsOfDay := []
    for m, obj in oDates
        for i, d in obj
            MonthsOfDay[d, m] := 1
    return MonthsOfDay
}

checkAnswer(oDates){                        ; check unique answer if any.
    if oDates.count()>1
        return false
    for m, obj in oDates
        if obj.count() > 1
            return false
        else
            return m " " obj.1
}
