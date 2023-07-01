import Foundation

let monthDays = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
let seasons = ["Chaos", "Discord", "Confusion", "Bureacracy", "The Aftermath"]
let dayNames = ["Sweetmorn", "Boomtime", "Pungenday", "Prickle-Prickle", "Setting Orange"]
let holyDays1 = ["Mungday", "Mojoday", "Syaday", "Zaraday", "Maladay"]
let holyDays2 = ["Chaoflux", "Discoflux", "Confuflux", "Bureflux", "Afflux"]

func discordianDate(date: Date) -> String {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    let discYear = year + 1166
    if month == 2 && day == 29 {
        return "St. Tib's Day in the YOLD \(discYear)"
    }
    let dayOfYear = monthDays[month - 1] + day - 1
    let season = dayOfYear/73
    let weekDay = dayOfYear % 5
    let dayOfSeason = 1 + dayOfYear % 73
    let ddate = "\(dayNames[weekDay]), day \(dayOfSeason) of \(seasons[season]) in the YOLD \(discYear)"
    switch (dayOfSeason) {
    case 5:
        return ddate + ". Celebrate \(holyDays1[season])!"
    case 50:
        return ddate + ". Celebrate \(holyDays2[season])!"
    default:
        return ddate
    }
}

func showDiscordianDate(year: Int, month: Int, day: Int) {
    let calendar = Calendar.current
    let date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
    let ddate = discordianDate(date: date)
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    print("\(format.string(from: date)): \(ddate)")
}

showDiscordianDate(year: 2022, month: 1, day: 20)
showDiscordianDate(year: 2020, month: 9, day: 21)
showDiscordianDate(year: 2020, month: 2, day: 29)
showDiscordianDate(year: 2019, month: 7, day: 15)
showDiscordianDate(year: 2025, month: 3, day: 19)
showDiscordianDate(year: 2017, month: 12, day: 8)
