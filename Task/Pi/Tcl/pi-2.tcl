coroutine piDigit piDigitsBySpigot 10000
fconfigure stdout -buffering none
while 1 {
    puts -nonewline [piDigit]
}
