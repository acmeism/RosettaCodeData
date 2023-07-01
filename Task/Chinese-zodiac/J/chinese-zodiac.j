   ELEMENTS=: _4 |. 2 # ;:'Wood Fire Earth Metal Water'
   YEARS=: 1935 1938 1968 1972 1976 2017

   ANIMALS=: _4 |. ;:'Rat Ox Tiger Rabbit Dragon Snake Horse Goat Monkey Rooster Dog Pig'
   YINYANG=: ;:'yang yin'

   cz=: (|~ #)~ { [

   ANIMALS cz YEARS
┌───┬─────┬──────┬───┬──────┬───────┐
│Pig│Tiger│Monkey│Rat│Dragon│Rooster│
└───┴─────┴──────┴───┴──────┴───────┘

   YINYANG cz YEARS
┌───┬────┬────┬────┬────┬───┐
│yin│yang│yang│yang│yang│yin│
└───┴────┴────┴────┴────┴───┘

   chinese_zodiac =: 3 : ';:inv(<":y),(ELEMENTS cz y),(ANIMALS cz y),(<''(''),(YINYANG cz y),(<'')'')'

   chinese_zodiac&>YEARS
1935 Wood Pig ( yin )
1938 Earth Tiger ( yang )
1968 Earth Monkey ( yang )
1972 Water Rat ( yang )
1976 Fire Dragon ( yang )
2017 Fire Rooster ( yin )


   'CELESTIAL TERRESTRIAL'=:7&u:&.>{&a.&.> 16be7 16b94 16bb2 16be4 16bb9 16b99 16be4 16bb8 16b99 16be4 16bb8 16b81 16be6 16b88 16b8a 16be5 16bb7 16bb1 16be5 16bba 16b9a 16be8 16bbe 16b9b 16be5 16ba3 16bac 16be7 16b99 16bb8; 16be5 16bad 16b90 16be4 16bb8 16b91 16be5 16baf 16b85 16be5 16b8d 16baf 16be8 16bbe 16bb0 16be5 16bb7 16bb3 16be5 16b8d 16b88 16be6 16b9c 16baa 16be7 16b94 16bb3 16be9 16b85 16b89 16be6 16b88 16b8c 16be4 16bba 16ba5

   ANIMALS=: ;/ _4 |. TERRESTRIAL
   ELEMENTS=: ;/ _4 |. CELESTIAL

   chinese_zodiac&>YEARS
1935 乙 亥 ( yin )
1938 戊 寅 ( yang )
1968 戊 申 ( yang )
1972 壬 子 ( yang )
1976 丙 辰 ( yang )
2017 丁 酉 ( yin )
