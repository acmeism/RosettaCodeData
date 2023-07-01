GD <- function(vec) {
    c(vec[vec != 0], vec[vec == 0])
}
DG <- function(vec) {
    c(vec[vec == 0], vec[vec != 0])
}

DG_ <- function(vec, v = TRUE) {
    if (v)
        print(vec)
    rev(GD_(rev(vec), v = FALSE))
}

GD_ <- function(vec, v = TRUE) {
    if (v) {
        print(vec)
    }
    vec2 <- GD(vec)
    # on cherche les 2 cote a cote
    pos <- which(vec2 == c(vec2[-1], 9999))
    # put pas y avoir consécutif dans pos
    pos[-1][which(abs(pos - c(pos[-1], 999)) == 1)]
    av <- which(c(0, c(pos[-1], 9) - pos) == 1)
    if (length(av) > 0) {
        pos <- pos[-av]
    }
    vec2[pos] <- vec2[pos] + vec2[pos + 1]
    vec2[pos + 1] <- 0
    GD(vec2)

}

H_ <- function(base) {
    apply(base, MARGIN = 2, FUN = GD_, v = FALSE)
}
B_ <- function(base) {
    apply(base, MARGIN = 2, FUN = DG_, v = FALSE)
}
G_ <- function(base) {
    t(apply(base, MARGIN = 1, FUN = GD_, v = FALSE))
}
D_ <- function(base) {
    t(apply(base, MARGIN = 1, FUN = DG_, v = FALSE))
}

H <- function(base) {
    apply(base, MARGIN = 2, FUN = GD, v = FALSE)
}
B <- function(base) {
    apply(base, MARGIN = 2, FUN = DG, v = FALSE)
}
G <- function(base) {
    t(apply(base, MARGIN = 1, FUN = GD, v = FALSE))
}
D <- function(base) {
    t(apply(base, MARGIN = 1, FUN = DG, v = FALSE))
}

add2or4 <- function(base, p = 0.9) {
    lw <- which(base == 0)
    if (length(lw) > 1) {
        tirage <- sample(lw, 1)
    } else {
        tirage <- lw
    }
    base[tirage] <- sample(c(2, 4), 1, prob = c(p, 1 - p))
    base
}
print.dqh <- function(base) {
    cat("\n\n")
    for (i in 1:nrow(base)) {
        cat(paste("     ", base[i, ], " "))
        cat("\n")
    }
    cat("\n")
}



# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title run_2048
#' @description The 2048 game
#' @param nrow nomber of row
#' @param ncol numver of col
#' @param p probability to obtain a 2 (1-p) is the probability to obtain a 4
#' @examples
#' \dontrun{
#' run_2048()
#' }
#' @export


run_2048 <- function(nrow, ncol, p = 0.9) {



    help <- function() {
        cat("   *** KEY BINDING ***  \n\n")
        cat("press ECHAP to quit\n\n")
        cat("choose moove E (up) ; D (down) ; S (left); F (right) \n")
        cat("choose moove 8 (up) ; 2 (down) ; 4 (left); 6 (right) \n")
        cat("choose moove I (up) ; K (down) ; J (left); L (right) \n\n\n")

    }


    if (missing(nrow) & missing(ncol)) {
        nrow <- ncol <- 4
    }
    if (missing(nrow)) {
        nrow <- ncol
    }
    if (missing(ncol)) {
        ncol <- nrow
    }

    base <- matrix(0, nrow = nrow, ncol = ncol)

    while (length(which(base == 2048)) == 0) {
        base <- add2or4(base, p = p)
        # print(base)

        class(base) <- "dqh"
        print(base)
        flag <- sum((base == rbind(base[-1, ], 0)) + (base == rbind(0,
            base[-nrow(base), ])) + (base == cbind(base[, -1], 0)) + (base ==
            cbind(0, base[, -nrow(base)])))
        if (flag == 0) {

            break
        }

        y <- character(0)
        while (length(y) == 0) {
            cat("\n", "choose moove E (up) ; D (down) ; s (left); f (right) OR H for help",
                "\n")  # prompt
            y <- scan(n = 1, what = "character")
        }


        baseSAVE <- base
        base <- switch(EXPR = y, E = H_(base), D = B_(base), S = G_(base),
            F = D_(base), e = H_(base), d = B_(base), s = G_(base), f = D_(base),
            `8` = H_(base), `2` = B_(base), `4` = G_(base), `6` = D_(base),
            H = help(), h = help(), i = H_(base), k = B_(base), j = G_(base),
            l = D_(base), I = H_(base), K = B_(base), J = G_(base), L = D_(base))
        if (is.null(base)) {
            cat(" wrong KEY \n")
            base <- baseSAVE
        }



    }

    if (sum(base >= 2048) > 1) {
        cat("YOU WIN ! \n")
    } else {
        cat("YOU LOOSE \n")
    }
}
