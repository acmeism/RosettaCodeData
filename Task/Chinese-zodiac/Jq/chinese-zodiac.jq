def ChineseZodiac: {
  animals  : ["Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake",
              "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"],
  aspects  : ["Yang","Yin"],
  elements : ["Wood", "Fire", "Earth", "Metal", "Water"],
  stems    : ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"],
  branches : ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"],
  sNames   : ["jiă", "yĭ", "bĭng", "dīng", "wù", "jĭ", "gēng", "xīn", "rén", "gŭi"],
  bNames   : ["zĭ", "chŏu", "yín", "măo", "chén", "sì", "wŭ", "wèi", "shēn", "yŏu",  "xū", "hài"]
};

def ChineseZodiac($year):
  ($year - 4) as $y
  | ($y % 10) as $s
  | ($y % 12) as $b
  | ChineseZodiac
  | {   year    : $year,
        stem    : .stems[$s],
        branch  : .branches[$b],
        sName   : .sNames[$s],
        bName   : .bNames[$b],
        element : .elements[($s/2)|floor],
        animal  : .animals[$b],
        aspect  : .aspects[$s % 2],
        cycle   : ($y % 60 + 1)
    };

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# Input: ChineseZodiac($year)
def toString:
  (.sName + "-" + .bName | lpad(9)) as $name
  | (.element|lpad(7)) as $elem
  | (.animal|lpad(7)) as $anim
  | (.aspect|lpad(6)) as $aspt
  | ((.cycle|lpad(2)) + "/60") as $cycl
  | "\(.year)    \(.stem)\(.branch)   \($name)  \($elem)  \($anim)   \($aspt)  \($cycl)" ;


"Year  Chinese  Pinyin     Element  Animal   Aspect  Cycle",
"----  -------  ---------  -------  -------  ------  -----",
(ChineseZodiac(1935, 1938, 1968, 1972, 1976, 1984, 2017, 2020) | toString)
