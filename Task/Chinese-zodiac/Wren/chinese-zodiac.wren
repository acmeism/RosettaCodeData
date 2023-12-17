import "./fmt" for Fmt

class ChineseZodiac {
    static init() {
        __animals  = ["Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake",
            "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"]
        __aspects  = ["Yang","Yin"]
        __elements = ["Wood", "Fire", "Earth", "Metal", "Water"]
        __stems    = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
        __branches = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
        __sNames   = ["jiă", "yĭ", "bĭng", "dīng", "wù", "jĭ", "gēng", "xīn", "rén", "gŭi"]
        __bNames   = ["zĭ", "chŏu", "yín", "măo", "chén", "sì", "wŭ", "wèi", "shēn", "yŏu",  "xū", "hài"]
    }

    construct new(year) {
        var y = year - 4
        var s = y % 10
        var b = y % 12
        _year    = year
        _stem    = __stems[s]
        _branch  = __branches[b]
        _sName   = __sNames[s]
        _bName   = __bNames[b]
        _element = __elements[(s/2).floor]
        _animal  = __animals[b]
        _aspect  = __aspects[s % 2]
        _cycle   = y % 60 + 1
    }

    toString {
        var name = Fmt.s(-9, _sName + "-" + _bName)
        var elem = Fmt.s(-7, _element)
        var anim = Fmt.s(-7, _animal)
        var aspt = Fmt.s(-6, _aspect)
        var cycl = Fmt.dz(2, _cycle) + "/60"
        return "%(_year)    %(_stem)%(_branch)   %(name)  %(elem)  %(anim)   %(aspt) %(cycl)"
    }
}

var years = [1935, 1938, 1968, 1972, 1976, 1984, 2017, 2020]
System.print("Year  Chinese  Pinyin     Element  Animal   Aspect  Cycle")
System.print("----  -------  ---------  -------  -------  ------  -----")
ChineseZodiac.init()
for (year in years) System.print(ChineseZodiac.new(year))
