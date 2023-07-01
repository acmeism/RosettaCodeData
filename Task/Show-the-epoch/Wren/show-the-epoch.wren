import "/date" for Date

Date.default = Date.isoFull
var dt = Date.fromNumber(0)
System.print(dt)

var dt2 = Date.unixEpoch
System.print(dt2)
