let animals  = ["Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake", "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"];
let aspects  = ["Yang","Yin"];
let elements = ["Wood", "Fire", "Earth", "Metal", "Water"];
let stems    = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"];
let branches = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"];
let s_names  = ["jiă", "yĭ", "bĭng", "dīng", "wù", "jĭ", "gēng", "xīn", "rén", "gŭi"];
let b_names  = ["zĭ", "chŏu", "yín", "măo", "chén", "sì", "wŭ", "wèi", "shēn", "yŏu",  "xū", "hài"];

struct ChineseZodiac {
    year:    int;
    stem:    string;
    branch:  string;
    s_name:  string;
    b_name:  string;
    element: string;
    animal:  string;
    aspect:  string;
    cycle:   int;
}

impl ChineseZodiac {
    fn new(year: int) -> Self {
        let y = year - 4;
        let s = y % 10;
        let b = y % 12;
        return ChineseZodiac {
            year:    year,
            stem:    stems[s],
            branch:  branches[b],
            s_name:  s_names[s],
            b_name:  b_names[b],
            element: elements[s / 2],
            animal:  animals[b],
            aspect:  aspects[s % 2],
            cycle:   y % 60 + 1
        };
    }

    fn display(self) {
        let fmt = "%d    %s%s   %5s-%-5s   %-7s  %-7s  %-6s  %02d/60\n";
        printf(fmt, .year, .stem, .branch, .s_name, .b_name, .element, .animal, .aspect, .cycle);
    }
}

fn main() {
    let years = [1935, 1938, 1968, 1972, 1976, 1984, 2017, 2020, 2026];
    println "Year  Chinese  Pinyin      Element  Animal   Aspect  Cycle";
    println "----  -------  ---------   -------  -------  ------  -----";
    for i in 0..9 {
        let cz = ChineseZodiac::new(years[i]);
        cz.display();
    }
}
