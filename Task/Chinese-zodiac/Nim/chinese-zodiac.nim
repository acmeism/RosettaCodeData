import strformat

const ANIMALS: array[12, string] = ["Rat",    "Ox",
                                    "Tiger",  "Rabbit",
                                    "Dragon", "Snake",
                                    "Horse",  "Goat",
                                    "Monkey", "Rooster",
                                    "Dog",    "Pig"]

const ASPECTS: array[2, string] = ["Yang",   "Yin"]

const ELEMENTS: array[5, string] = ["Wood",  "Fire",
                                    "Earth", "Metal",
                                    "Water"]

const STEMS: array[10, string] = ["甲", "乙", "丙", "丁", "戊",
                                  "己", "庚", "辛", "壬", "癸"]

const BRANCHES: array[12, string] = ["子", "丑", "寅", "卯", "辰", "巳",
                                     "午", "未", "申", "酉", "戌", "亥"]

const S_NAMES: array[10, string] = ["jiă", "yĭ", "bĭng", "dīng", "wù",
                                    "jĭ", "gēng", "xīn", "rén", "gŭi"]

const B_NAMES: array[12, string] = ["zĭ", "chŏu", "yín", "măo", "chén", "sì",
                                    "wŭ", "wèi", "shēn", "yŏu", "xū", "hài"]

proc chineseZodiac(year: int): string =
  let y = year - 4
  let s = y mod 10
  let b = y mod 12
  let stem = STEMS[s]
  let branch = BRANCHES[b]
  let name = S_NAMES[s] & "-" & B_NAMES[b]
  let element = ELEMENTS[s div 2]
  let animal = ANIMALS[b]
  let aspect = ASPECTS[s mod 2]
  let cycle = y mod 60 + 1
  &"{year}   {stem}{branch}     {name:9}  {element:7}  {animal:7}  {aspect:6}  {cycle:02}/60"

let years = [1935, 1938, 1968, 1972, 1976, 1984, 2017, 2020]
echo "Year  Chinese  Pinyin     Element  Animal   Aspect  Cycle"
echo "----  -------  ------     -------  ------   ------  -----"
for year in years:
  echo &"{chineseZodiac(year)}"
