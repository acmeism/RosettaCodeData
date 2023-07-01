sub zodiac {
  my $year = shift;
  my @animals = qw/Rat Ox Tiger Rabbit Dragon Snake Horse Goat Monkey Rooster Dog Pig/;
  my @elements = qw/Wood Fire Earth Metal Water/;
  my @terrestrial_han = qw/子 丑 寅 卯 辰 巳 午 未 申 酉 戌 亥/;
  my @terrestrial_pinyin = qw/zĭ chŏu yín măo chén sì wŭ wèi shēn yŏu xū hài/;
  my @celestial_han = qw/甲 乙 丙 丁 戊 己 庚 辛 壬 癸/;
  my @celestial_pinyin = qw/jiă yĭ bĭng dīng wù jĭ gēng xīn rén gŭi/;
  my @aspect = qw/yang yin/;

  my $cycle_year = ($year-4) % 60;
  my($i2, $i10, $i12) = ($cycle_year % 2, $cycle_year % 10, $cycle_year % 12);

  ($year,
   $celestial_han[$i10], $terrestrial_han[$i12],
   $celestial_pinyin[$i10], $terrestrial_pinyin[$i12],
   $elements[$i10 >> 1], $animals[$i12], $aspect[$i2], $cycle_year+1);
}

printf("%4d: %s%s (%s-%s) %s %s; %s - year %d of the cycle\n", zodiac($_))
  for (1935, 1938, 1968, 1972, 1976, 2017);
