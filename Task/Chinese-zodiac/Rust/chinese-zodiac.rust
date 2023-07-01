fn chinese_zodiac(year: usize) -> String {
    static ANIMALS: [&str; 12] = [
        "Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake",
        "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig",
    ];
    static ASPECTS: [&str; 2] = ["Yang", "Yin"];
    static ELEMENTS: [&str; 5] = ["Wood", "Fire", "Earth", "Metal", "Water"];
    static STEMS: [char; 10] = [
        '甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸',
    ];
    static BRANCHES: [char; 12] = [
        '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥',
    ];
    static S_NAMES: [&str; 10] = [
        "jiă", "yĭ", "bĭng", "dīng", "wù", "jĭ", "gēng", "xīn", "rén", "gŭi",
    ];
    static B_NAMES: [&str; 12] = [
        "zĭ", "chŏu", "yín", "măo", "chén", "sì",
        "wŭ", "wèi", "shēn", "yŏu", "xū", "hài",
    ];

    let y = year - 4;
    let s = y % 10;
    let b = y % 12;

    let stem = STEMS[s];
    let branch = BRANCHES[b];
    let s_name = S_NAMES[s];
    let b_name = B_NAMES[b];
    let element = ELEMENTS[s / 2];
    let animal = ANIMALS[b];
    let aspect = ASPECTS[s % 2];
    let cycle = y % 60 + 1;

    format!(
        "{}    {}{}    {:9}  {:7}  {:7}  {:6}  {:02}/60",
        year,
        stem,
        branch,
        format!("{}-{}", s_name, b_name),
        element,
        animal,
        aspect,
        cycle
    )
}

fn main() {
    let years = [1935, 1938, 1968, 1972, 1976, 1984, 2017];
    println!("Year  Chinese  Pinyin     Element  Animal   Aspect  Cycle");
    println!("----  -------  ---------  -------  -------  ------  -----");
    for &year in &years {
        println!("{}", chinese_zodiac(year));
    }
}
