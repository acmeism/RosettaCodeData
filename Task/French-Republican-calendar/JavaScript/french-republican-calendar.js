class FrenchRCDate {
    constructor(year, month, day) {
        this.year = year;
        this.month = month;
        this.day = day;
    }

    static INTRODUCTION_DATE = new Date(Date.UTC(1792, 8, 22)); // Months are zero-indexed in JS
    static TERMINATION_DATE = new Date(Date.UTC(1805, 11, 31));

    static MONTHS = [
        "Vendémiaire", "Brumaire", "Frimaire", "Nivôse", "Pluviôse", "Ventôse",
        "Germinal", "Floréal", "Prairial", "Messidor", "Thermidor", "Fructidor"
    ];

    static SANSCULOTTIDES = [
        "Fête de la vertu", "Fête du génie", "Fête du travail",
        "Fête de l'opinion", "Fête des récompenses", "Fête de la Révolution"
    ];

    toGregorianDate() {
        const days = (this.year - 1) * 365 + FrenchRCDate.additionalDaysForYear(this.year) +
                     (this.month - 1) * 30 + this.day - 1;

        const gregorian = new Date(FrenchRCDate.INTRODUCTION_DATE);
        gregorian.setUTCDate(gregorian.getUTCDate() + days);
        return gregorian;
    }

    toString() {
        if (this.month < 13) {
            return `${this.day} ${FrenchRCDate.MONTHS[this.month - 1]} ${this.year}`;
        } else {
            return `${FrenchRCDate.SANSCULOTTIDES[this.day - 1]} ${this.year}`;
        }
    }

    static additionalDaysForYear(year) {
        return year > 11 ? 3 : year > 7 ? 2 : year > 3 ? 1 : 0;
    }

    static toFrenchRCDate(gregorianDate) {
        const daysAfter = Math.floor((gregorianDate - FrenchRCDate.INTRODUCTION_DATE) / (1000 * 60 * 60 * 24));
        const daysBefore = Math.floor((FrenchRCDate.TERMINATION_DATE - gregorianDate) / (1000 * 60 * 60 * 24));

        if (daysAfter < 0 || daysBefore < 0) {
            throw new Error("French Republican Calendar date out of range.");
        }

        let year = Math.floor((daysAfter + 366) / 365);
        let days = (daysAfter + 366) % 365 - FrenchRCDate.additionalDaysForYear(year);

        if (days < 1) {
            year -= 1;
            days += 366;
        }

        if (days < 361) {
            const month = Math.floor(days / 30) + 1;
            const day = days % 30 || 30;
            return new FrenchRCDate(year, month, day);
        } else {
            const day = days - 360;
            return new FrenchRCDate(year, 13, day);
        }
    }

    static parse(frenchRCDateString) {
        const parts = frenchRCDateString.trim().split(/\s+/);
        if (parts.length === 3) {
            const [dayStr, monthStr, yearStr] = parts;
            const year = parseInt(yearStr, 10);
            const month = FrenchRCDate.MONTHS.indexOf(monthStr) + 1;
            const day = parseInt(dayStr, 10);
            return new FrenchRCDate(year, month, day);
        } else {
            const yearStr = parts[parts.length - 1];
            const year = parseInt(yearStr, 10);
            const sansculottideName = parts.slice(0, -1).join(" ");
            const day = FrenchRCDate.SANSCULOTTIDES.indexOf(sansculottideName) + 1;
            return new FrenchRCDate(year, 13, day);
        }
    }
}

// Helper to format dates like "d MMMM yyyy"
function formatDate(date) {
    const months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ];
    const day = date.getUTCDate();
    const month = months[date.getUTCMonth()];
    const year = date.getUTCFullYear();
    return `${day} ${month} ${year}`;
}

// Main logic
const gregorianStrings = [
    "22 September 1792",
    "20 May 1795",
    "15 July 1799",
    "23 September 1803",
    "31 December 1805"
];

const frenchRCStrings = [];

for (const gregorianString of gregorianStrings) {
    // Parse into JS Date object
    const [day, month, year] = gregorianString.split(" ");
    const monthIndex = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ].indexOf(month);
    const gregorianDate = new Date(Date.UTC(parseInt(year), monthIndex, parseInt(day)));

    const frenchRCDate = FrenchRCDate.toFrenchRCDate(gregorianDate);
    const frenchRCString = frenchRCDate.toString();
    frenchRCStrings.push(frenchRCString);
    console.log(`${gregorianString} => ${frenchRCString}`);
}

console.log();

for (const frenchRCString of frenchRCStrings) {
    const frenchRCDate = FrenchRCDate.parse(frenchRCString);
    const gregorianDate = frenchRCDate.toGregorianDate();
    console.log(`${frenchRCString} => ${formatDate(gregorianDate)}`);
}
