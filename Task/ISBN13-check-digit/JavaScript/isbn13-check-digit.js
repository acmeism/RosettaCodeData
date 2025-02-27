/**
 * Validate that the given string of digits is an ISBN13 number
 * If we allow 8, 12, 13, and 14-digit numbers, this becomes a GTIN validator.
 * See: https://ref.gs1.org/standards/genspecs/
 * @param {string} s
 * @returns {boolean} True if the given string is a GS1 GTIN number
 */
const check = s => {
  const _multiply = (e, i) => i % 2 ? e * 1 : e * 3;
  const _sum = (p, c) => p + c;
  const arr = [...s.replaceAll('-', '')
    .replaceAll(' ', '')];
  if ([13].includes(arr.length)) {
    const [last, ...rest] = [...arr].reverse();
    const result = rest.map(_multiply).reduce(_sum, last * 1);
    return result % 10 === 0;
  }
  return false;
}

[
  "978-0596528126",
  "978-0596528120",
  "978-1788399081",
  "978-1788399083"].map(check)
