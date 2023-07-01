def a = new ABCSolver(["BO", "XK", "DQ", "CP", "NA", "GT", "RE", "TG", "QD", "FS",
                      "JW", "HU", "VI", "AN", "OB", "ER", "FS", "LY", "PC", "ZM"])

['', 'A', 'BARK', 'book', 'treat', 'COMMON', 'SQuAd', 'CONFUSE'].each {
    println "'${it}': ${a.canMakeWord(it)}"
}
