sub Chinese-zodiac ( Int $year ) {
    my @heaven  = <甲 jiă 乙 yĭ 丙 bĭng 丁 dīng 戊 wù 己 jĭ 庚 gēng 辛 xīn 壬 rén 癸 gŭi>.pairup;
    my @earth   = <子 zĭ 丑 chŏu 寅 yín 卯 măo 辰 chén 巳 sì 午 wŭ 未 wèi 申 shēn 酉 yŏu 戌 xū 亥 hài>.pairup;
    my @animal  = <Rat Ox Tiger Rabbit Dragon Snake Horse Goat Monkey Rooster Dog Pig>;
    my @element = <Wood Fire Earth Metal Water>;
    my @aspect  = <yang yin>;

    my $cycle_year = ($year - 4) % 60;
    my $i2         = $cycle_year % 2;
    my $i10        = $cycle_year % 10;
    my $i12        = $cycle_year % 12;

    %(
        'Han'     => @heaven[$i10].key ~ @earth[$i12].key,
        'pinyin'  => @heaven[$i10].value ~ @earth[$i12].value,
        'heaven'  => @heaven[$i10],
        'earth'   => @earth[$i12],
        'element' => @element[$i10 div 2],
        'animal'  => @animal[$i12],
        'aspect'  => @aspect[$i2],
        'cycle'   => $cycle_year + 1
    )
}

# TESTING
printf "%d: %s (%s, %s %s; %s - year %d in the cycle)\n",
    $_, .&Chinese-zodiac<Han pinyin element animal aspect cycle>
    for 1935, 1938, 1968, 1972, 1976, 1984, Date.today.year;
