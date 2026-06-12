const timeRatio = 1000 * 60 * 60 * 24;
var floor = Math.floor, abs = Math.abs;
var daysBetween = (d1, d2) => floor(abs(new Date(d1) - new Date(d2)) / timeRatio);

console.log('Days between 2021-10-27 and 2020-03-03: %s', daysBetween('2021-10-27', '2020-03-03'));
