dict <- scan("https://web.archive.org/web/20180611003215/http://www.puzzlers.org/pub/wordlists/unixdict.txt", what = character())
changed <- chartr("e", "i", dict)
cbind(Before = dict, After = changed)[changed != dict & changed %in% dict & nchar(changed) > 5, ]
