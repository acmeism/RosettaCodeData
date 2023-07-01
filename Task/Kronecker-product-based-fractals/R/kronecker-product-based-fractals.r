## Generate and plot Kronecker product based fractals. aev 8/12/16
## gpKronFractal(m, n, pf, clr, ttl, dflg=0, psz=600):
## Where: m - initial matrix (filled with 0/1); n - order of the fractal;
## pf - plot file name (without extension); clr - color; ttl - plot title;
## dflg - writing dump file flag (0/1); psz - picture size.
gpKronFractal <- function(m, n, pf, clr, ttl, dflg=0, psz=600) {
  cat(" *** START:", date(), "n=", n, "clr=", clr, "psz=", psz, "\n");
  cat(" *** Plot file -", pf, "\n");
  r <- m;
  for(i in 1:n) {r = r%x%m};
  plotmat(r, pf, clr, ttl, dflg, psz);
  cat(" *** END:", date(), "\n");
}

## Required tests:
# 1. Vicsek Fractal
M <- matrix(c(0,1,0,1,1,1,0,1,0), ncol=3, nrow=3, byrow=TRUE);
gpKronFractal(M, 4, "VicsekFractalR","red", "Vicsek Fractal n=4")
# 2. Sierpinski carpet fractal
M <- matrix(c(1,1,1,1,0,1,1,1,1), ncol=3, nrow=3, byrow=TRUE);
gpKronFractal(M, 4, "SierpinskiCarpetFR", "maroon", "Sierpinski carpet fractal n=4")

# 3. Plus sign fractal
M <- matrix(c(1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,0,1,1,1,1,0,0,0,0,0,1,1,1,1,
+0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1), ncol=7, nrow=7, byrow=TRUE);
gpKronFractal(M, 3, "PlusSignFR", "maroon", "Plus sign fractal, n=3")

# Also, try these 3. I bet you've never seen them before.
# 4. Wider Sierpinski carpet fractal (a.k.a. Sierpinski carpet mutant)
# Note: If your computer is not super fast it could take a lot of time.
#       Use dump flag = 1, to save generated fractal.
#M <- matrix(c(1,1,1,1,1,1,0,0,0,1,1,0,0,0,1,1,0,0,0,1,1,1,1,1,1), ncol=5,
#+nrow=5, byrow=TRUE);
#gpKronFractal(M, 4, "SierpinskiCarpetFw", "brown", "Wider Sierpinski carpet fractal n=4", 1)
# 5. "H" fractal (Try all other letters in the alphabet...)
#M <- matrix(c(1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,
#+0,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1), ncol=7, nrow=7, byrow=TRUE);
#gpKronFractal(M, 3, "HFR", "maroon", "'H' fractal n=3", 1)
# 6. Chessboard fractal.
#M <- matrix(c(1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,
#     0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1), ncol=8, nrow=8, byrow=TRUE);
#gpKronFractal(M, 2, "ChessBrdFractalR","black", "Chessboard Fractal, n=2")
