pta = c(1,2)
ptb = c(4,2)
ptc = c(2.5,4)
spt = c(1,2)

plot(t(data.frame(pta,ptb,ptc)),
     xlab= "", ylab = "", pch = 19, asp =1,
     xaxt='n',yaxt='n', ann=FALSE,frame.plot=FALSE)
points(x = spt[1], y = spt[2], col = "blue", pch = 19)

ittt = 100000
ptcex = .2
for (i in 1:ittt) {
  d = sample(1:6,1,TRUE)
  if (d == 1 | d == 2) {
    pta1 = spt + ((pta-spt)/2)
    points(pta1[1],pta1[2], col = "red", pch = 19, cex = ptcex)
    spt=pta1
  }
  if (d == 3 | d == 4) {
    ptb1 = spt + (ptb-spt)/2
    points(ptb1[1],ptb1[2], col = "red", pch = 19, cex = ptcex)
    spt=ptb1
  }
  if (d == 5 | d == 6) {
    ptc1 = spt + (ptc-spt)/2
    points(ptc1[1],ptc1[2], col = "red", pch = 19, cex = ptcex)
    spt=ptc1
  }
}
