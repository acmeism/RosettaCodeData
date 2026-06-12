#!/usr/bin/R

printf <- function(...) cat(sprintf(...))
#allows printing to greater number of digits #https://stackoverflow.com/questions/13023274/how-to-do-printf-in-r#13023329
d1 <- c(27.5,21.0,19.0,23.6,17.0,17.9,16.9,20.1,21.9,22.6,23.1,19.6,19.0,21.7,21.4)
d2 <- c(27.1,22.0,20.8,23.4,23.4,23.5,25.8,22.0,24.8,20.2,21.9,22.1,22.9,20.5,24.4)
d3 <- c(17.2,20.9,22.6,18.1,21.7,21.4,23.5,24.2,14.7,21.8)
d4 <- c(21.5,22.8,21.0,23.0,21.6,23.6,22.5,20.7,23.4,21.8,20.7,21.7,21.5,22.5,23.6,21.5,22.5,23.5,21.5,21.8)
d5 <- c(19.8,20.4,19.6,17.8,18.5,18.9,18.3,18.9,19.5,22.0)
d6 <- c(28.2,26.6,20.1,23.3,25.2,22.1,17.7,27.6,20.6,13.7,23.2,17.5,20.6,18.0,23.9,21.6,24.3,20.4,24.0,13.2)
d7 <- c(30.02,29.99,30.11,29.97,30.01,29.99)
d8 <- c(29.89,29.93,29.72,29.98,30.02,29.98)
x <- c(3.0,4.0,1.0,2.1)
y <- c(490.2,340.0,433.9)
v1 <- c(0.010268,0.000167,0.000167);
v2<- c(0.159258,0.136278,0.122389);
s1<- c(1.0/15,10.0/62.0);
s2<- c(1.0/10,2/50.0);
z1<- c(9/23.0,21/45.0,0/38.0);
z2<- c(0/44.0,42/94.0,0/22.0);

results <- t.test(d1,d2, alternative="two.sided", var.equal=FALSE)
printf("%.15g\n", results$p.value);
results <- t.test(d3,d4, alternative="two.sided", var.equal=FALSE)
printf("%.15g\n", results$p.value);
results <- t.test(d5,d6, alternative="two.sided", var.equal=FALSE)
printf("%.15g\n", results$p.value);
results <- t.test(d7,d8, alternative="two.sided", var.equal=FALSE)
printf("%.15g\n", results$p.value);
results <- t.test(x,y, alternative="two.sided", var.equal=FALSE)
printf("%.15g\n", results$p.value);
results <- t.test(v1,v2, alternative="two.sided", var.equal=FALSE)
printf("%.15g\n", results$p.value);
results <- t.test(s1,s2, alternative="two.sided", var.equal=FALSE)
printf("%.15g\n", results$p.value);
results <- t.test(z1,z2, alternative="two.sided", var.equal=FALSE)
printf("%.15g\n", results$p.value);
