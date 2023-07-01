truth_table <- function(x) {
  vars <- unique(unlist(strsplit(x, "[^a-zA-Z]+")))
  vars <- vars[vars != ""]
  perm <- expand.grid(rep(list(c(FALSE, TRUE)), length(vars)))
  names(perm) <- vars
  perm[ , x] <- with(perm, eval(parse(text = x)))
  perm
}

"%^%" <- xor # define unary xor operator

truth_table("!A") # not
##       A    !A
## 1 FALSE  TRUE
## 2  TRUE FALSE

truth_table("A | B") # or
##       A     B A | B
## 1 FALSE FALSE FALSE
## 2  TRUE FALSE  TRUE
## 3 FALSE  TRUE  TRUE
## 4  TRUE  TRUE  TRUE

truth_table("A & B") # and
##       A     B A & B
## 1 FALSE FALSE FALSE
## 2  TRUE FALSE FALSE
## 3 FALSE  TRUE FALSE
## 4  TRUE  TRUE  TRUE

truth_table("A %^% B") # xor
##       A     B A %^% B
## 1 FALSE FALSE   FALSE
## 2  TRUE FALSE    TRUE
## 3 FALSE  TRUE    TRUE
## 4  TRUE  TRUE   FALSE

truth_table("S | (T %^% U)") # 3 variables with brackets
##       S     T     U S | (T %^% U)
## 1 FALSE FALSE FALSE         FALSE
## 2  TRUE FALSE FALSE          TRUE
## 3 FALSE  TRUE FALSE          TRUE
## 4  TRUE  TRUE FALSE          TRUE
## 5 FALSE FALSE  TRUE          TRUE
## 6  TRUE FALSE  TRUE          TRUE
## 7 FALSE  TRUE  TRUE         FALSE
## 8  TRUE  TRUE  TRUE          TRUE

truth_table("A %^% (B %^% (C %^% D))") # 4 variables with nested brackets
##        A     B     C     D A %^% (B %^% (C %^% D))
## 1  FALSE FALSE FALSE FALSE                   FALSE
## 2   TRUE FALSE FALSE FALSE                    TRUE
## 3  FALSE  TRUE FALSE FALSE                    TRUE
## 4   TRUE  TRUE FALSE FALSE                   FALSE
## 5  FALSE FALSE  TRUE FALSE                    TRUE
## 6   TRUE FALSE  TRUE FALSE                   FALSE
## 7  FALSE  TRUE  TRUE FALSE                   FALSE
## 8   TRUE  TRUE  TRUE FALSE                    TRUE
## 9  FALSE FALSE FALSE  TRUE                    TRUE
## 10  TRUE FALSE FALSE  TRUE                   FALSE
## 11 FALSE  TRUE FALSE  TRUE                   FALSE
## 12  TRUE  TRUE FALSE  TRUE                    TRUE
## 13 FALSE FALSE  TRUE  TRUE                   FALSE
## 14  TRUE FALSE  TRUE  TRUE                    TRUE
## 15 FALSE  TRUE  TRUE  TRUE                    TRUE
## 16  TRUE  TRUE  TRUE  TRUE                   FALSE
