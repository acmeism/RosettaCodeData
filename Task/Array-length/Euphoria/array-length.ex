sequence s = {"apple","orange",2.95} -- Euphoria doesn't care what you put in a sequence

? length(s)

3 -- three objects

? length(s[1])

5 -- apple has 5 characters

? length(s[1][$])

1 -- 'e' is an atomic value


? length(s[$])

1 -- 2.95 is an atomic value
