function chinese(year::Int)
    pinyin = Dict(
        "甲" => "jiă",
        "乙" => "yĭ",
        "丙" => "bĭng",
        "丁" => "dīng",
        "戊" => "wù",
        "己" => "jĭ",
        "庚" => "gēng",
        "辛" => "xīn",
        "壬" => "rén",
        "癸" => "gŭi",
        "子" => "zĭ",
        "丑" => "chŏu",
        "寅" => "yín",
        "卯" => "măo",
        "辰" => "chén",
        "巳" => "sì",
        "午" => "wŭ",
        "未" => "wèi",
        "申" => "shēn",
        "酉" => "yŏu",
        "戌" => "xū",
        "亥" => "hài",
    )
    elements    = ["Wood", "Fire", "Earth", "Metal", "Water"]
    animals     = ["Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake",
                   "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"]
    celestial   = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
    terrestrial = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
    aspects     = ["yang", "yin"]
    base = 4

    cycleyear = year - base

    stemnumber = cycleyear % 10 + 1
    stemhan    = celestial[stemnumber]
    stempinyin = pinyin[stemhan]

    elementnumber = div(stemnumber, 2) + 1
    element       = elements[elementnumber]

    branchnumber = cycleyear % 12 + 1
    branchhan    = terrestrial[branchnumber]
    branchpinyin = pinyin[branchhan]
    animal       = animals[branchnumber]

    aspectnumber = cycleyear % 2 + 1
    aspect       = aspects[aspectnumber]

    index = cycleyear % 60 + 1

    return "$year: $stemhan$branchhan ($stempinyin-$branchpinyin, $element $animal; $aspect - year $index of the cycle)"
end

curryr = Dates.year(now())
yrs = [1935, 1938, 1968, 1972, 1976, curryr]
foreach(println, map(chinese, yrs))
