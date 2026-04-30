// doom.js
const LEAP_DOOM = [4, 1, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5];
const NORM_DOOM = [3, 7, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5];
const WEEKDAYS = [
  'Sunday', 'Monday', 'Tuesday', 'Wednesday',
  'Thursday', 'Friday', 'Saturday'
];

class Date {
  constructor(year, month, day) {
    this.year = year;
    this.month = month;   // 1-based
    this.day = day;
  }

  isLeapYear() {
    const y = this.year;
    return y % 4 === 0 && (y % 100 !== 0 || y % 400 === 0);
  }

  format() {
    const { month, day, year } = this;
    return `${String(month).padStart(2, '0')}/${String(day).padStart(2, '0')}/${year}`;
  }

  weekday() {
    const { year, month, day } = this;
    const c = Math.floor(year / 100);
    const r = year % 100;
    const s = Math.floor(r / 12);
    const t = r % 12;

    const cAnchor = (5 * (c % 4) + 2) % 7;
    const doom = (s + t + Math.floor(t / 4) + cAnchor) % 7;
    const anchor = (this.isLeapYear() ? LEAP_DOOM : NORM_DOOM)[month - 1];

    return WEEKDAYS[(doom + day - anchor + 7) % 7];
  }
}

/* ---------- demo ---------- */
const dates = [
  new Date(1800, 1, 6),
  new Date(1875, 3, 29),
  new Date(1915, 12, 7),
  new Date(1970, 12, 23),
  new Date(2043, 5, 14),
  new Date(2077, 2, 12),
  new Date(2101, 4, 2)
];

dates.forEach(d => console.log(`${d.format()}: ${d.weekday()}`));
