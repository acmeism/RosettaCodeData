function add12hours(dateString) {

  // Get the parts of the date string
  var parts = dateString.split(/\s+/),
      date  = parts[1],
      month = parts[0],
      year  = parts[2],
      time  = parts[3];

  var hr    = Number(time.split(':')[0]),
      min   = Number(time.split(':')[1].replace(/\D/g,'')),
      ampm  = time && time.match(/[a-z]+$/i)[0],
      zone  = parts[4].toUpperCase();

  var months = ['January','February','March','April','May','June',
                'July','August','September','October','November','December'];
  var zones  = {'EST': 300, 'AEST': -600}; // Minutes to add to zone time to get UTC

  // Convert month name to number, zero indexed. Return if invalid month
  month = months.indexOf(month);
  if (month === -1) { return; }

  // Add 12 hours as specified. Add another 12 if pm for 24hr time
  hr += (ampm.toLowerCase() === 'pm') ? 24 : 12

  // Create a date object in local zone
  var localTime = new Date(year, month, date);
  localTime.setHours(hr, min, 0, 0);

  // Adjust localTime minutes for the time zones so it is now a local date
  // representing the same moment as the source date plus 12 hours
  localTime.setMinutes(localTime.getMinutes() + zones[zone] - localTime.getTimezoneOffset() );
  return localTime;
}

var inputDateString = 'March 7 2009 7:30pm EST';

console.log(
  'Input: ' + inputDateString + '\n' +
  '+12hrs in local time: ' + add12hours(inputDateString)
 );
