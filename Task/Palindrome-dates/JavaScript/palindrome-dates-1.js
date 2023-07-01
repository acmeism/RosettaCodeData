/**
 * Adds zeros for 1 digit days/months
 * @param date: string
 */
const addMissingZeros = date => (/^\d$/.test(date) ? `0${date}` : date);

/**
 * Formats a Date to a string. If readable is false,
 * string is only numbers (used for comparison), else
 * is a human readable date.
 * @param date: Date
 * @param readable: boolean
 */
const formatter = (date, readable) => {
  const year = date.getFullYear();
  const month = addMissingZeros(date.getMonth() + 1);
  const day = addMissingZeros(date.getDate());

  return readable ? `${year}-${month}-${day}` : `${year}${month}${day}`;
};

/**
 * Returns n (palindromesToShow) palindrome dates
 * since start (or 2020-02-02)
 * @param start: Date
 * @param palindromesToShow: number
 */
function getPalindromeDates(start, palindromesToShow = 15) {
  let date = start || new Date(2020, 3, 2);

  for (
    let i = 0;
    i < palindromesToShow;
    date = new Date(date.setDate(date.getDate() + 1))
  ) {
    const formattedDate = formatter(date);
    if (formattedDate === formattedDate.split("").reverse().join("")) {
      i++;
      console.log(formatter(date, true));
    }
  }
}

getPalindromeDates();
