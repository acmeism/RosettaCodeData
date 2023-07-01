function getEasterDate(year = new Date().getFullYear(), church = 1, calendar = year < 1918 ? 1 : 2) {
/*	year: a number of the year (from 325 CE);
	church: an algorithm of the computus,
		for Orthodox = 1; for Catholic = 2;
	calendar: a calendar of the output date,
		Julian = 1; Gregorian = 2. */

	if (church == 1) {
		let d = (year % 19 * 19 + 15) % 30;
		d += (year % 4 * 2 + year % 7 * 4 + 6 * d + 6) % 7;
		if (calendar == 1)
			return d > 9 ? [d - 9, 4] : [22 + d, 3];
		else if (calendar == 2) {
			const c = (year / 100 | 0) - (year / 400 | 0) - 2;
			return d > 39 - c ? [d - 39 + c, 5] : [d - 9 + c, 4];
		}
	}

	else if (church == 2) {
		const
			a = year % 19, b = year / 100 | 0, c = year % 100,
			d = (19 * a + b - (b / 4 | 0) - ((b - ((b + 8) / 25 | 0) + 1) / 3 | 0) + 15) % 30,
			e = (32 + 2 * (b % 4) + 2 * (c / 4 | 0) - d - c % 4) % 7,
			f = d + e - 7 * ((a + 11 * d + 22 * e) / 451 | 0) + 114;
		if (calendar == 1) {
			const
				g = f % 31 + 1,
				h = (year / 100 | 0) - (year / 400 | 0) - 2;
			return g <= h ? [31 + g - h, 3] : [g - h, f / 31 | 0];
		}
		else if (calendar == 2)
			return [f % 31 + 1, f / 31 | 0];
	}
}

const
	OrthodoxHolidays = [["Easter", 1], ["Ascension", 40], ["Trinity (Pentecost)", 50], ["All Saints' Sunday", 57]],
	CatholicHolidays = [["Easter", 1], ["Ascension", 40], ["Pentecost", 50], ["Trinity Sunday", 57], ["Corpus Christi", 61]];

const firstYearOfNewStyle = 1918;

function getHolidaysDates(year = new Date().getFullYear(), church = 1) {
	const
		Easter = getEasterDate(year, church, year < firstYearOfNewStyle ? 1 : 2),
		holidays = church == 1 ? OrthodoxHolidays : CatholicHolidays;
	return year + ": " +
		holidays.map(h => {
			const d = new Date(year, Easter[1] - 1, Easter[0]);
			d.setDate(d.getDate() + h[1] - 1);
			return h[0] + ": " + new Intl.DateTimeFormat("ru", { month: "numeric", day: "numeric" }).format(d);
		}).join("; ") + ".";
}

for (let year = 400; year <= 2100; year += year < 2000 ? 100 : year >= 2021 ? 80 : year < 2010 ? 10 : 1)
	document.write(getHolidaysDates(year, 1) + " <br />");
