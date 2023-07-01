func duration (_ secs:Int) -> String {
    if secs <= 0 { return "" }
    let units = [(604800,"wk"), (86400,"d"), (3600,"hr"),  (60,"min")]
    var secs = secs
    var result = ""
    for (period, unit) in units {
        if secs >= period {
            result +=  "\(secs/period) \(unit), "
            secs = secs % period
        }
    }
    if secs == 0 {
        result.removeLast(2) // remove ", "
    } else {
        result += "\(secs) sec"
    }
    return result
}

print(duration(7259))
print(duration(86400))
print(duration(6000000))
