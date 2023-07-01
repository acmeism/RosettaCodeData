var last_friday_of_month, print_last_fridays_of_month;

last_friday_of_month = function(year, month) {
  var i, last_day;
  i = 0;
  while (true) {
    last_day = new Date(year, month, i);
    if (last_day.getDay() === 5) {
      return last_day.toDateString();
    }
    i -= 1;
  }
};

print_last_fridays_of_month = function(year) {
  var month, results;
  results = [];
  for (month = 1; month <= 12; ++month) {
    results.push(console.log(last_friday_of_month(year, month)));
  }
  return results;
};

(function() {
  var year;
  year = parseInt(process.argv[2]);
  return print_last_fridays_of_month(year);
})();
