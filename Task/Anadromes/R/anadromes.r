anagra <- function(x) {
  flipfun <- function(x) {
    x <- rev(x)

    x <- paste(x, collapse = "")

    return(x)

  }

  x <- strsplit(x, split = "")

  x <- lapply(x, flipfun)

  x <- unlist(x)

  return(x)
}

sortfun <- function(x) {
  x <- unlist(x)

  x <- unname(x)

  x <- sort(x)

  x <- data.frame(orig = x[1], flip = x[2])

  return(x)

}


anadrome <- read.delim("words.txt")[, 1]

anadrome <- anadrome[nchar(anadrome) > 6]

anadrome <- anadrome[anagra(anadrome) %in% anadrome]

anadrome <- data.frame(orig = anadrome, flip = anagra(anadrome))

anadrome <- anadrome[anadrome$orig != anadrome$flip, ]

anadrome <- lapply(1:nrow(anadrome), function(i) sortfun(anadrome[i, ]))

anadrome <- do.call(rbind, anadrome)

anadrome <- anadrome[duplicated(anadrome), ]


for (i in 1:nrow(anadrome)) {
  cat(paste0(i, " ", anadrome[i, 1], " <-> ", anadrome[i, 2]), "\n")

}
