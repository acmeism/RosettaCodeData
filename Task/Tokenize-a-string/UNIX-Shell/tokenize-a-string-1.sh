string='Hello,How,Are,You,Today'

(IFS=,
 printf '%s.' $string
 echo)
