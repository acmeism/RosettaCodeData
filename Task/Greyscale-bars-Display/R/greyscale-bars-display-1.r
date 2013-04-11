mat <- matrix(c(rep(1:8, each = 8) / 8,
                rep(16:1, each = 4) / 16,
                rep(1:32, each = 2) / 32,
                rep(64:1, each = 1) / 64),
              nrow = 4, byrow = TRUE)
par(mar = rep(0, 4))
image(t(mat[4:1, ]), col = gray(1:64/64), axes = FALSE)
