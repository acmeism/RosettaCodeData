library(caTools);   dx=800;   dy=600   # write.gif, grid size
jet.colors = colorRampPalette(c("#00007F", "blue", "#007FFF",
   "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
C = complex(real=rep(seq(-2.2, 1.0, length.out=dx), each=dy),
            imag=rep(seq(-1.2, 1.2, length.out=dy),      dx))
C = matrix(C, dy, dx);   Z = 0;   X = array(0, c(dy, dx, 20))
for (k in 1 : 20) {Z = Z ^ 2 + C;   X[, , k] = exp(- abs(Z))}
write.gif(X, "Mandelbrot_set.gif", col=jet.colors, delay=100)
