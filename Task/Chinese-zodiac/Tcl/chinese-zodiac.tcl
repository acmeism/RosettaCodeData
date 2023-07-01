proc cn_zodiac year {
   set year0 [expr $year-4]
   set animals {Rat Ox Tiger Rabbit Dragon Snake Horse Goat Monkey Rooster Dog Pig}
   set elements {Wood Fire Earth Metal Water}
   set stems {jia3 yi3 bing3 ding1 wu4 ji3 geng1 xin1 ren2 gui3}
   set gan {\u7532 \u4E59 \u4E19 \u4E01 \u620A \u5DF1 \u5E9A \u8F9B \u58EC \u7678}
   set branches {zi3 chou3 yin2 mao3 chen2 si4 wu3 wei4 shen1 you3 xu1 hai4}
   set zhi {\u5B50 \u4E11 \u5BC5 \u536F \u8FB0 \u5DF3 \u5348 \u672A \u7533 \u9149 \u620C \u4EA5}
   set m10 [expr $year0%10]
   set m12 [expr $year0%12]
   set res [lindex $gan $m10][lindex $zhi $m12]
   lappend res [lindex $stems $m10]-[lindex $branches $m12]
   lappend res [lindex $elements [expr $m10/2]]
   lappend res [lindex $animals $m12] ([expr {$year0%2 ? "yin" : "yang"}])
   lappend res year [expr $year0%60+1]
   return $res
}
