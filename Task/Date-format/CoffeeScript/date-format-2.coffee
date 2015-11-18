# JS does not have extensive formatting support out of the box.  This code shows
# how you could create a date formatter object.
DateFormatter = ->
  weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
  months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
  pad = (n) ->
    if n < 10
      "0" + n
    else
      n

  brief: (date) ->
    month = 1 + date.getMonth()
    "#{date.getFullYear()}-#{pad month}-#{pad date.getDate()}"

  verbose: (date) ->
    weekday = weekdays[date.getDay()]
    month = months[date.getMonth()]
    day = date.getDate()
    year = date.getFullYear();
    "#{weekday}, #{month} #{day}, #{year}"

formatter = DateFormatter()
date = new Date()
console.log formatter.brief(date)
console.log formatter.verbose(date)
