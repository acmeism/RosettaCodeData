/* Rexx */
say
say 'Loops/Foreach'
out = ''

days = .array~of('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')

loop daysi over days
  out ||= daysi' '
  end daysi
say out~strip()

exit
