   gray:{x[0],xor':x}
   g2b:xor\
   / using allcomb instead of 2_vs'!32 for nicer presentation
   allcomb:{+(x#y)_vs!_ y^x}
   a:(+allcomb . 5 2)
   `0:,/{n:2_sv x;gg:gray x;gb:g2b gg;n2:2_sv gb;
        ,/$((2$n)," : ",$x," -> ",$gg," -> ",$gb," : ",(2$n2),"\n") }'a
