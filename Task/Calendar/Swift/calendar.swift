import Foundation

let monthWidth = 20
let monthGap = 2
let dayNames = "Su Mo Tu We Th Fr Sa"
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "MMMM"

func rpad(string: String, width: Int) -> String {
    return string.count >= width ? string
        : String(repeating: " ", count: width - string.count) + string
}

func lpad(string: String, width: Int) -> String {
    return string.count >= width ? string
        : string + String(repeating: " ", count: width - string.count)
}

func centre(string: String, width: Int) -> String {
    if string.count >= width {
        return string
    }
    let c = (width - string.count)/2
    return String(repeating: " ", count: c) + string
        + String(repeating: " ", count: width - string.count - c)
}

func formatMonth(year: Int, month: Int) -> [String] {
    let calendar = Calendar.current
    let dc = DateComponents(year: year, month: month, day: 1)
    let date = calendar.date(from: dc)!
    let firstDay = calendar.component(.weekday, from: date) - 1
    let range = calendar.range(of: .day, in: .month, for: date)!
    let daysInMonth = range.count
    var lines: [String] = []
    lines.append(centre(string: dateFormatter.string(from: date), width: monthWidth))
    lines.append(dayNames)
    var padWidth = 2
    var line = String(repeating: " ", count: 3 * firstDay)
    for day in 1...daysInMonth {
        line += rpad(string: String(day), width: padWidth)
        padWidth = 3
        if (firstDay + day) % 7 == 0 {
            lines.append(line)
            line = ""
            padWidth = 2
        }
    }
    if line.count > 0 {
        lines.append(lpad(string: line, width: monthWidth))
    }
    return lines
}

func printCentred(string: String, width: Int) {
    print(rpad(string: string, width: (width + string.count)/2))
}

public func printCalendar(year: Int, width: Int) {
    let months = min(12, max(1, (width + monthGap)/(monthWidth + monthGap)))
    let lineWidth = monthWidth * months + monthGap * (months - 1)
    printCentred(string: "[Snoopy]", width: lineWidth)
    printCentred(string: String(year), width: lineWidth)
    var firstMonth = 1
    while firstMonth <= 12 {
        if firstMonth > 1 {
            print()
        }
        let lastMonth = min(12, firstMonth + months - 1)
        let monthCount = lastMonth - firstMonth + 1
        var lines: [[String]] = []
        var lineCount = 0
        for month in firstMonth...lastMonth {
            let monthLines = formatMonth(year: year, month: month)
            lineCount = max(lineCount, monthLines.count)
            lines.append(monthLines)
        }
        for i in 0..<lineCount {
            var line = ""
            for month in 0..<monthCount {
                if month > 0 {
                    line.append(String(repeating: " ", count: monthGap))
                }
                line.append(i < lines[month].count ? lines[month][i]
                            : String(repeating: " ", count: monthWidth))
            }
            print(line)
        }
        firstMonth = lastMonth + 1
    }
}

printCalendar(year: 1969, width: 80)
