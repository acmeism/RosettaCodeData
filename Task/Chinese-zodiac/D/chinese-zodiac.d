import std.stdio;

// 10 heavenly stems
immutable tiangan=[
    ["甲","乙","丙","丁","戊","己","庚","辛","壬","癸"],
    ["jiă","yĭ","bĭng","dīng","wù","jĭ","gēng","xīn","rén","gŭi"]
];

// 12 terrestrial branches
immutable dizhi=[
    ["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"],
    ["zĭ","chŏu","yín","măo","chén","sì","wŭ","wèi","shēn","yŏu","xū","hài"]
];

// 5 elements
immutable wuxing=[
    ["木","火","土","金","水"],
    ["mù","huǒ","tǔ","jīn","shuǐ"],
    ["wood","fire","earth","metal","water"]
];

// 12 symbolic animals
immutable shengxiao=[
    ["鼠","牛","虎","兔","龍","蛇","馬","羊","猴","鸡","狗","豬"],
    ["shǔ","niú","hǔ","tù","lóng","shé","mǎ","yáng","hóu","jī","gǒu","zhū"],
    ["rat","ox","tiger","rabbit","dragon","snake","horse","goat","monkey","rooster","dog","pig"]
];

// yin yang
immutable yinyang=[
    ["阳","阴"],
    ["yáng","yīn"]
];

void main(string[] args) {
    process(args[1..$]);
}

void process(string[] years) {
    import std.conv;
    foreach(yearStr; years) {
        try {
            auto year = to!int(yearStr);

            auto cy = year - 4;
            auto stem = cy % 10;
            auto branch = cy % 12;

            writefln("%4s  %-11s  %-7s  %-10s%s", year,tiangan[0][stem]~dizhi[0][branch], wuxing[0][stem/2], shengxiao[0][branch], yinyang[0][year%2]);
            writefln("      %-12s%-8s%-10s%s",      tiangan[1][stem]~dizhi[1][branch],    wuxing[1][stem/2], shengxiao[1][branch], yinyang[1][year%2]);
            writefln("      %2s/60     %-7s%s", cy%60+1,                                  wuxing[2][stem/2], shengxiao[2][branch]);
            writeln;
        } catch (ConvException e) {
            stderr.writeln("Not a valid year: ", yearStr);
        }
    }
}
