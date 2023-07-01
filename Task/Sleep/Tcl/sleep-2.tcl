puts -nonewline "Enter a number of milliseconds to sleep: "
flush stdout
set millis [gets stdin]
set ::wakupflag 0
puts Sleeping...
after $millis set ::wakeupflag 1
vwait ::wakeupflag
puts Awake!
