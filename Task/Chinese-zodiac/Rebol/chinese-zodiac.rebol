Rebol [
    title: "Rosetta code: Chinese zodiac"
    file:  %Chinese_zodiac.r3
    url:   https://rosettacode.org/wiki/Chinese_zodiac
    note:  "Translated from Julia"
]

chinese: function/with [year [integer!]] [
    cycleyear: year - base

    stemnumber:    1 + cycleyear % 10
    stemhan:       celestial/:stemnumber
    stempinyin:    pinyin/:stemhan

    elementnumber: 1 + stemnumber / 2
    element:       elements/:elementnumber

    branchnumber:  1 + cycleyear % 12
    branchhan:     terrestrial/:branchnumber
    branchpinyin:  pinyin/:branchhan
    animal:        animals/:branchnumber

    aspectnumber:  1 + cycleyear % 2
    aspect:        aspects/:aspectnumber

    index: 1 + cycleyear % 60

    rejoin [
        year ": " stemhan branchhan
        " (" stempinyin "-" branchpinyin ", "
        element " " animal "; "
        aspect " - year " index " of the cycle)"
    ]
][
    pinyin: make map! [
        "甲" "jiă"   "乙" "yĭ"    "丙" "bĭng"  "丁" "dīng"
        "戊" "wù"    "己" "jĭ"    "庚" "gēng"  "辛" "xīn"
        "壬" "rén"   "癸" "gŭi"   "子" "zĭ"    "丑" "chŏu"
        "寅" "yín"   "卯" "măo"   "辰" "chén"  "巳" "sì"
        "午" "wŭ"    "未" "wèi"   "申" "shēn"  "酉" "yŏu"
        "戌" "xū"    "亥" "hài"
    ]

    elements:    ["Wood" "Fire" "Earth" "Metal" "Water"]
    animals:     ["Rat" "Ox" "Tiger" "Rabbit" "Dragon" "Snake"
                  "Horse" "Goat" "Monkey" "Rooster" "Dog" "Pig"]
    celestial:   ["甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"]
    terrestrial: ["子" "丑" "寅" "卯" "辰" "巳" "午" "未" "申" "酉" "戌" "亥"]
    aspects:     ["yang" "yin"]
    base: 4
]

foreach year reduce [1935 1938 1968 1972 1976 now/year][
    print chinese year
]
