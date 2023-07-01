const Easter = year => {
    let date = (year % 19 * 19 + 15) % 30;
    date += (year % 4 * 2 + year % 7 * 4 + 6 * date + 6) % 7;
    if (year >= 1918) date += (year / 100 | 0) - (year / 400 | 0) - 2;
    return new Date(year, 2, 22 + date);
};

for (let year = 400; year <= 2100; year += year < 2000 ? 100 : year >= 2020 ? 80 : year < 2010 ? 10 : 1) {
    const Easter_Date = Easter(year);
    document.write(
        year + ": " +
        [ ["Easter", 1], ["Ascension", 40], ["Trinity (Pentecost)", 50], ["All Saints' Sunday", 57] ].map(holiday => {
            let date = new Date(Easter_Date);
            date.setDate(date.getDate() + holiday[1] - 1);
            return holiday[0] + ": " + new Intl.DateTimeFormat("ru", { month: "numeric", day: "numeric" }).format(date);
        }).join("; ") + ".<br />"
    );
}
