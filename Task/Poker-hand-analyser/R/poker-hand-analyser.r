library(stringr)

poker_rank <- function(hand) {
  #Get a vector of individual cards in the hand
  cards <- str_split_1(hand, " ")
  #Any duplicate cards?
  if (!identical(cards, unique(cards))) return("Invalid: duplicate cards")
  #Split cards into a vector of faces and a vector of suits (both lowercase)
  cards <- str_split(cards, "")
  faces <- sapply(cards, function(v) v[1]) |> tolower()
  suits <- sapply(cards, function(v) v[2]) |> tolower()
  #Do faces or suits contain any invalid characters?
  if (str_detect(str_flatten(faces), "[^2-9xjqka]")) return("Invalid: bad face")
  if (str_detect(str_flatten(suits), "[^cdhs]")) return("Invalid: bad suit")
  #Replace court cards (and tens) with numbers and sort numerically
  faces <- str_replace_all(faces, c("x" = "10",
                                    "j" = "11",
                                    "q" = "12",
                                    "k" = "13",
                                    "a" = "14")) |> as.numeric() |> sort()
  #Are all suits the same? If so, it's a flush
  flushcond <- length(unique(suits)) == 1
  #Are all differences between face values equal to 1? If so, it's a straight
  facediffs <- diff(faces)
  straightcond <- identical(facediffs, rep(1L, 4))
  #Check for A-2-3-4-5 edge case ("the wheel")
  wheelcond <- identical(faces, c(2:5, 14))
  if (straightcond || wheelcond) {
    if (flushcond) return("Straight flush")
    return("Straight")
  } else if (flushcond) return("Flush")
  #We can tell how many cards have the same face(s) by how many differences in
  #their values are zero, and how many of these zeroes are consecutive
  nconsec0 <- function(v, n) identical(diff(which(!v)), rep(1L, n-1))
  switch(1+sum(!facediffs),
         "High card",
         "One pair",
         ifelse(nconsec0(facediffs, 2), "Three of a kind", "Two pair"),
         ifelse(nconsec0(facediffs, 3), "Four of a kind", "Full house"))
}

test_hands <- c("2h 2d 2c kc qd",
                "2h 5h 7d 8c 9s",
                "ah 2d 3c 4c 5d",
                "2h 3h 2d 3c 3d",
                "2h 7h 2d 3c 3d",
                "2d 7h 7d 7c 7s",
                "xh jh qh kh ah",
                "4h 4s ks 5d xs",
                "qc xc 7c 6c qc")

#Okay, fine, let's show the suits in Unicode
writeLines(paste(str_replace_all(test_hands, c("c" = "♣︎",
                                               "d" = "♦︎",
                                               "h" = "♥︎",
                                               "s" = "♠︎")),
                 "-",
                 sapply(test_hands, poker_rank)))
