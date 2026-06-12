dict <- scan("https://web.archive.org/web/20180611003215/http://www.puzzlers.org/pub/wordlists/unixdict.txt", what = character())
dict[nchar(dict) > 5 & substr(dict, 1, 3) == substr(dict, nchar(dict) - 2, nchar(dict))]
