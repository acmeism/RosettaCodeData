/**
 * Given a width, return a function that takes a string, and
 * pads it at both ends to the given width
 * @param {number} width
 * @returns {function(string): string}
 */
const printCenter = width =>
    s => s.padStart(width / 2 + s.length / 2, ' ').padEnd(width);

/**
 * Given an locale string and options, return a function that takes a date
 * object, and retrurns the date formatted to the locale and options.
 * @param {string} locale
 * @param {DateTimeFormatOptions} options
 * @returns {function(Date): string}
 */
const localeName = (locale, options) => {
  const formatter = new Intl.DateTimeFormat(locale, options);
  return date => formatter.format(date);
};

/**
 * Increment the date by number.
 * @param {Date} date
 * @param {number} inc
 * @returns {Date}
 */
const addDay = (date, inc = 1) => {
  const res = new Date(date.valueOf());
  res.setDate(date.getDate() + inc);
  return res;
}

/**
 * Given a date, build a string of the week, and return it along with
 * the mutated date object.
 * @param {Date} date
 * @returns {[boolean, Date, string]}
 */
const makeWeek = date => {
  const month = date.getMonth();
  let [wdi, md, m] = [date.getUTCDay(), date.getDate(), date.getMonth()];
  const line = Array(7).fill('  ').map((e, i) => {
    if (i === wdi && m === month) {
      const result = (md + '').padStart(2, ' ');
      date = addDay(date);
      [wdi, md, m] = [date.getUTCDay(), date.getDate(), date.getMonth()];
      return result;
    } else {
      return e;
    }
  }).join(' ');
  return [month !== m, date, line];
}

/**
 * Print a nicely formatted calender for the given year in the given locale.
 * @param {number} year The required year of the calender
 * @param {string} locale The locale string. Defaults to US English.
 * @param {number} cols The number of columns for the months. Defaults to 3.
 * @param {number} coll_space The space between the columns. Defaults to 5.
 */
const cal = (year, locale = 'en-US', cols = 3, coll_space = 5) => {
  const MONTH_LINES = 9;  // Number of lines that make up a month.
  const MONTH_COL_WIDTH = 20;  // Character width of a month
  const COL_SPACE = ' '.padStart(coll_space);
  const FULL_WIDTH = MONTH_COL_WIDTH * cols + coll_space * (cols - 1);

  const collArr = Array(cols).fill('');
  const monthName = localeName(locale, {month: 'long'});
  const weekDayShort = localeName(locale, {weekday: 'short'});
  const monthCenter = printCenter(MONTH_COL_WIDTH);
  const pageCenter = printCenter(FULL_WIDTH);

  // Get the weekday in the given locale.
  const sun = new Date(Date.UTC(2017, 0, 1)); // A sunday
  const weekdays = Array(7).fill('').map((e, i) =>
      weekDayShort(addDay(sun, i)).padStart(2, ' ').substring(0, 2)).join(' ');

  // The start date.
  let date = new Date(Date.UTC(year, 0, 1, 0, 0, 0));
  let nextMonth = true;
  let line = '';
  const fullYear = date.getUTCFullYear();

  // The array into which each of the lines are populated.
  const accumulate = [];

  // Populate the month table heading and columns.
  const preAmble = date => {
    accumulate.push(monthCenter(' '))
    accumulate.push(monthCenter(monthName(date)));
    accumulate.push(weekdays);
  };

  // Accumulate the week lines for the year.
  while (date.getUTCFullYear() === fullYear) {
    if (nextMonth) {
      if (accumulate.length % MONTH_LINES !== 0) {
        accumulate.push(monthCenter(' '))
      }
      preAmble(date);
    }
    [nextMonth, date, line] = makeWeek(date);
    accumulate.push(line);
  }

  // Print the calendar.
  console.log(pageCenter(String.fromCodePoint(0x1F436)));
  console.log(pageCenter(`--- ${fullYear} ---`));
  accumulate.reduce((p, e, i) => {
    if (!p.includes(i)) {
      const indexes = collArr.map((e, ci) => i + ci * MONTH_LINES);
      console.log(indexes.map(e => accumulate[e]).join(COL_SPACE));
      p.push(...indexes);
    }
    return p;
  }, []);
};

cal(1969, 'en-US', 3);
