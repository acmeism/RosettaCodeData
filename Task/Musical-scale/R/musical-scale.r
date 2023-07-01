install.packages("audio")
library(audio)
hz=c(1635,1835,2060,2183,2450,2750,3087,3270)
for (i in 1:8){
  play(audioSample(sin(1:1000), hz[i]))
  Sys.sleep(.7)
}
