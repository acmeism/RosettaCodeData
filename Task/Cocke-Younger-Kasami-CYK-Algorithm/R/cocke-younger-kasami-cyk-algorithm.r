cyk_parse <- function(w, r, startcode = "NP") {
  n <- length(w)
  out <- rep(list(rep(list(NULL), n)), n)
  for(i in seq_along(w)) {
    for(j in seq_along(r)) {
      lhs <- names(r)[j]
      for(rhs in r[[j]]) {
        if(length(rhs) == 1 && rhs[1] == w[i]) {
          out[[i]][[i]] <- c(out[[i]][[i]], lhs)
        }
      }
    }
    for(k in i:1) {
      for(l in k:(ifelse(i > 1, i-1, 1))) {
        for(m in seq_along(r)) {
          lhs <- names(r)[m]
          for(rhs in r[[m]]) {
            if(length(rhs) == 2 &&
               rhs[1] %in% out[[k]][[l]] &&
               rhs[2] %in% out[[l+1]][[i]]) {
              out[[k]][[i]] <- c(out[[k]][[i]], lhs)
            }
          }
        }
      }
    }
  }
  startcode %in% out[[1]][[n]]
}

rules <- list("NP" = list(c("Det", "Nom")),
              "Nom" = list(c("AP", "Nom"), "book", "orange", "man"),
              "AP" = list(c("Adv", "A"), "heavy", "orange", "tall"),
              "Det" = "a",
              "Adv" = list("very", "extremely"),
              "A" = list("heavy", "orange", "tall", "muscular"))

words <- unlist(strsplit("a very heavy orange book", " "))
cyk_parse(words, rules)
