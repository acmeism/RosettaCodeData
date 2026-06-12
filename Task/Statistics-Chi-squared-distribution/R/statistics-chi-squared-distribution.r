# Gamma function to 12 decimal places (Lanczos approximation)
gamma_func <- function(x) {
  p <- c(0.99999999999980993, 676.5203681218851, -1259.1392167224028,
         771.32342877765313, -176.61502916214059, 12.507343278686905,
         -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7)

  if (x < 0.5) {
    return(pi / (sin(pi * x) * gamma_func(1.0 - x)))
  } else {
    x <- x - 1.0
    t <- p[1]
    for (i in 1:8) {
      t <- t + p[i+1] / (x + i)
    }
    w <- x + 7.5
    return(sqrt(2.0 * pi) * w^(x + 0.5) * exp(-w) * t)
  }
}

# Chi-squared probability density function
chi2_pdf <- function(x, k) {
  if (x > 0) {
    return(x^(k/2 - 1) * exp(-x/2) / (2^(k/2) * gamma_func(k/2)))
  } else {
    return(0)
  }
}

# Lower incomplete gamma CDF by series expansion
gamma_cdf <- function(k, x) {
  total <- 0
  for (m in 0:100) {
    total <- total + (x^m) / gamma_func(k + m + 1)
  }
  return(x^k * exp(-x) * total)
}

# Cumulative distribution function for Chi-squared
chi2_cdf <- function(x, k) {
  if (x <= 0 || k <= 0) {
    return(0.0)
  } else {
    return(gamma_cdf(k/2, x/2))
  }
}

# --- Print PDF table ---
cat("x           χ2 k = 1             k = 2             k = 3             k = 4             k = 5\n")
cat(paste(rep("-", 93), collapse=""), "\n")

for (x in 0:10) {
  cat(sprintf("%2d", x))
  for (k in 1:5) {
    s <- chi2_pdf(x, k)
    cat(sprintf("%18.12f", s))
    if (k %% 5 == 0) cat("\n")
  }
}

# --- CDF + P-values ---
cat("\nχ2 x     cdf for χ2   P value (df=3)\n", paste(rep("-", 36), collapse=""), "\n", sep="")
for (p in c(1, 2, 4, 8, 16, 32)) {
  cdf <- round(chi2_cdf(p, 3), 10)
  cat(sprintf("%2d     %.10f   %.10f\n", p, cdf, round(1.0 - cdf, 10)))
}

# --- Airport data test ---
airportdata <- matrix(c(77,23,
                        88,12,
                        79,21,
                        81,19), ncol=2, byrow=TRUE)

expected_data <- matrix(c(81.25,18.75,
                          81.25,18.75,
                          81.25,18.75,
                          81.25,18.75), ncol=2, byrow=TRUE)

dtotal <- sum((airportdata - expected_data)^2 / expected_data)

cat(sprintf("\nFor the airport data, diff total is %.6f, χ2 is %.6f, p value %.6f\n",
            dtotal, chi2_pdf(dtotal, 3), chi2_cdf(dtotal, 3)))

# --- Plot Chi-squared PDFs ---
xvals <- seq(0, 10, by=0.01)
plot(xvals, sapply(xvals, function(x) chi2_pdf(x, 0)), type="l", ylim=c(-0.1, 0.5),
     xlab="x", ylab="Chi-squared PDF", col="black", lwd=2)
for (k in 1:3) {
  lines(xvals, sapply(xvals, function(x) chi2_pdf(x, k)), col=k+1, lwd=2)
}
legend("topright", legend=c("k=0","k=1","k=2","k=3"), col=1:4, lwd=2)

