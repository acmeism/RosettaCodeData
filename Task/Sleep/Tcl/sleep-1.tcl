puts -nonewline "Enter a number of milliseconds to sleep: "
flush stdout
set millis [gets stdin]
puts Sleeping...
after $millis
puts Awake!
