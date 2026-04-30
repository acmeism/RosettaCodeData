# Helper function to convert string to character vector
str_to_vec <- function(s) {
  strsplit(s, "")[[1]]
}

# Use Z algorithm to preprocess s
z_array <- function(s) {
  s_vec <- str_to_vec(s)
  len <- length(s_vec)
  stopifnot(len > 1)

  z <- c(len, integer(len - 1))

  # Initial comparison of s[2:] with prefix
  for (i in 1:(len - 1)) {
    if (!is.na(s_vec[i + 1]) && !is.na(s_vec[i]) && s_vec[i + 1] == s_vec[i]) {
      z[2] <- z[2] + 1
    } else {
      break
    }
  }

  r <- 0
  l <- 0
  if (z[2] > 0) {
    r <- z[2]
    l <- 1
  }

  for (k in 2:(len - 1)) {
    stopifnot(z[k + 1] == 0)
    if (k > r) {
      # Case 1
      for (i in k:(len - 1)) {
        if (!is.na(s_vec[i + 1]) && !is.na(s_vec[i - k + 1]) && s_vec[i + 1] == s_vec[i - k + 1]) {
          z[k + 1] <- z[k + 1] + 1
        } else {
          break
        }
      }
      r <- k + z[k + 1] - 1
      l <- k
    } else {
      # Case 2
      nbeta <- r - k + 1
      zkp <- z[k - l + 1]
      if (nbeta > zkp) {
        # Case 2a: Zkp wins
        z[k + 1] <- zkp
      } else {
        # Case 2b: Compare characters just past r
        nmatch <- 0
        for (i in (r + 1):(len - 1)) {
          if (!is.na(s_vec[i + 1]) && !is.na(s_vec[i - k + 1]) && s_vec[i + 1] == s_vec[i - k + 1]) {
            nmatch <- nmatch + 1
          } else {
            break
          }
        }
        l <- k
        r <- r + nmatch
        z[k + 1] <- r - k + 1
      }
    }
  }
  return(z)
}

# Compile the N array (Gusfield theorem 2.2.2) from the Z array
n_array <- function(s) {
  s_vec <- str_to_vec(s)
  rev_s <- paste(rev(s_vec), collapse = "")
  return(rev(z_array(rev_s)))
}

# Compile L' array (Gusfield theorem 2.2.2) using p and N array
big_l_prime_array <- function(p, n) {
  len <- nchar(p)
  lp <- integer(len)
  for (j in 1:(len - 1)) {
    i <- len - n[j]
    if (i < len) {
      lp[i + 1] <- j + 1
    }
  }
  return(lp)
}

# Compile L array (Gusfield theorem 2.2.2) using p and L' array
big_l_array <- function(p, lp) {
  l <- integer(nchar(p))
  l[2] <- lp[2]
  if (length(l) >= 3) {
    for (i in 3:length(l)) {
      l[i] <- max(l[i - 1], lp[i])
    }
  }
  return(l)
}

# Compile lp' array (Gusfield theorem 2.2.4) using N array
small_l_prime_array <- function(narray) {
  len <- length(narray)
  small_lp <- integer(len)
  for (i in seq_along(narray)) {
    if (narray[i] == i) {  # prefix matching a suffix
      small_lp[len - i + 1] <- i
    }
  }
  for (i in (len - 1):1) {  # "smear" them out to the left
    if (small_lp[i] == 0) {
      small_lp[i] <- small_lp[i + 1]
    }
  }
  return(small_lp)
}

# Return tables needed to apply good suffix rule
good_suffix_table <- function(p) {
  n <- n_array(p)
  lp <- big_l_prime_array(p, n)
  list(
    lp = lp,
    big_l = big_l_array(p, lp),
    small_l_prime = small_l_prime_array(n)
  )
}

# Given a mismatch at offset i, return amount to shift per good suffix rule
good_suffix_mismatch <- function(i, big_l_prime, small_l_prime) {
  len <- length(big_l_prime)
  stopifnot(i < len)
  if (i == len - 1) {
    return(0)
  }
  i <- i + 1  # i points to leftmost matching position of P
  if (big_l_prime[i] > 0) {
    return(len - big_l_prime[i])
  }
  return(len - small_l_prime[i])
}

# Given a full match of P to T, return amount to shift per good suffix rule
good_suffix_match <- function(small_l_prime) {
  length(small_l_prime) - small_l_prime[2]
}

# Create dense bad character table
dense_bad_char_tab <- function(p, amap) {
  p_vec <- str_to_vec(p)
  tab <- list()
  nxt <- integer(length(amap))
  for (i in seq_along(p_vec)) {
    c <- p_vec[i]
    stopifnot(c %in% names(amap))
    tab[[i]] <- nxt
    nxt[amap[[c]]] <- i
  }
  return(tab)
}

# Boyer-Moore object (list)
BoyerMoore <- function(p, alphabet = "ACGT") {
  # Create map from alphabet characters to integers
  alphabet_vec <- str_to_vec(alphabet)
  amap <- setNames(seq_along(alphabet_vec), alphabet_vec)

  # Make bad character rule table
  bad_char <- dense_bad_char_tab(p, amap)

  # Create good suffix rule table
  gs_table <- good_suffix_table(p)

  list(
    pat = p,
    alphabet = alphabet,
    amap = amap,
    bad_char = bad_char,
    big_l = gs_table$big_l,
    small_l_prime = gs_table$small_l_prime
  )
}

# Return # skips given by bad character rule at offset i
bad_character_rule <- function(bm, i, c) {
  stopifnot(c %in% names(bm$amap))
  ci <- bm$amap[[c]]
  stopifnot(i > bm$bad_char[[i + 1]][ci] - 1)
  return(i - (bm$bad_char[[i + 1]][ci] - 1))
}

# Given a mismatch at offset i, return amount to shift per good suffix rule
good_suffix_rule <- function(bm, i) {
  len <- length(bm$big_l)
  stopifnot(i < len)
  if (i == len - 1) {
    return(0)
  }
  i <- i + 1  # i points to leftmost matching position of P
  if (bm$big_l[i + 1] > 0) {
    return(len - bm$big_l[i + 1])
  }
  return(len - bm$small_l_prime[i + 1])
}

# Return amount to shift when P matches T
match_skip <- function(bm) {
  length(bm$small_l_prime) - bm$small_l_prime[2]
}

# Do Boyer-Moore matching
boyer_moore <- function(p, p_bm, t) {
  p_vec <- str_to_vec(p)
  t_vec <- str_to_vec(t)
  i <- 0
  occurrences <- integer(0)

  while (i < length(t_vec) - length(p_vec) + 1) {
    shift <- 1
    mismatched <- FALSE
    for (j in (length(p_vec) - 1):0) {
      if (!is.na(p_vec[j + 1]) && !is.na(t_vec[i + j + 1]) && p_vec[j + 1] != t_vec[i + j + 1]) {
        skip_bc <- bad_character_rule(p_bm, j, t_vec[i + j + 1])
        skip_gs <- good_suffix_rule(p_bm, j)
        shift <- max(shift, skip_bc, skip_gs)
        mismatched <- TRUE
        break
      } else if (is.na(p_vec[j + 1]) || is.na(t_vec[i + j + 1])) {
        # Treat NA as mismatch
        mismatched <- TRUE
        shift <- 1
        break
      }
    }
    if (!mismatched) {
      occurrences <- c(occurrences, i)
      skip_gs <- match_skip(p_bm)
      shift <- max(shift, skip_gs)
    }
    i <- i + shift
  }
  return(occurrences)
}

# Do Boyer-Moore matching with counts
boyer_moore_with_counts <- function(p, p_bm, t) {
  p_vec <- str_to_vec(p)
  t_vec <- str_to_vec(t)
  i <- 0
  occurrences <- integer(0)
  alignments_tried <- 0
  comparison_count <- 0

  while (i < length(t_vec) - length(p_vec) + 1) {
    alignments_tried <- alignments_tried + 1
    shift <- 1
    mismatched <- FALSE
    for (j in (length(p_vec) - 1):0) {
      comparison_count <- comparison_count + 1
      if (!is.na(p_vec[j + 1]) && !is.na(t_vec[i + j + 1]) && p_vec[j + 1] != t_vec[i + j + 1]) {
        skip_bc <- bad_character_rule(p_bm, j, t_vec[i + j + 1])
        skip_gs <- good_suffix_rule(p_bm, j)
        shift <- max(shift, skip_bc, skip_gs)
        mismatched <- TRUE
        break
      } else if (is.na(p_vec[j + 1]) || is.na(t_vec[i + j + 1])) {
        # Treat NA as mismatch
        mismatched <- TRUE
        shift <- 1
        break
      }
    }
    if (!mismatched) {
      occurrences <- c(occurrences, i)
      skip_gs <- match_skip(p_bm)
      shift <- max(shift, skip_gs)
    }
    i <- i + shift
  }
  return(list(
    occurrences = occurrences,
    alignments_tried = alignments_tried,
    comparison_count = comparison_count
  ))
}

# Test cases
cat("Test 1:\n")
p1 <- "TCTA"
p_bm1 <- BoyerMoore(p1, "ACGT")
t1 <- "GCTAGCTCTACGAGTCTA"
cat("boyer_moore(p1, p_bm1, t1)=", boyer_moore(p1, p_bm1, t1), "\n")

cat("\nTest 2:\n")
p2 <- "TAATAAA"
p_bm2 <- BoyerMoore(p2, "ACGT")
cat("bad_character_rule(p_bm2, 1, 'T')=", bad_character_rule(p_bm2, 1, 'T'), "\n")

cat("\nTest 3:\n")
p3 <- "word"
t3 <- "there would have been a time for such a word"
lowercase_alphabet <- "abcdefghijklmnopqrstuvwxyz "
p_bm3 <- BoyerMoore(p3, lowercase_alphabet)
result3 <- boyer_moore_with_counts(p3, p_bm3, t3)
cat("Occurrences:", result3$occurrences, "\n")
cat("Alignments:", result3$alignments_tried, "\n")
cat("Comparisons:", result3$comparison_count, "\n")

cat("\nTest 4:\n")
p4 <- "needle"
t4 <- "needle need noodle needle"
p_bm4 <- BoyerMoore(p4, lowercase_alphabet)
result4 <- boyer_moore_with_counts(p4, p_bm4, t4)
cat("Occurrences:", result4$occurrences, "\n")
cat("Alignments:", result4$alignments_tried, "\n")
cat("Comparisons:", result4$comparison_count, "\n")

cat("\nTest 5:\n")
p5 <- "put"
t5 <- "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented"
# Create ASCII chars string (characters 0-255)
ASCIIchars <- intToUtf8(0:255)
p_bm5 <- BoyerMoore(p5, ASCIIchars)
result5 <- boyer_moore_with_counts(p5, p_bm5, t5)
cat("Occurrences:", result5$occurrences, "\n")
cat("Alignments:", result5$alignments_tried, "\n")
cat("Comparisons:", result5$comparison_count, "\n")

cat("\nTest 6:\n")
p6 <- "and"
p_bm6 <- BoyerMoore(p6, ASCIIchars)
result6 <- boyer_moore_with_counts(p6, p_bm6, t5)
cat("Occurrences:", result6$occurrences, "\n")
cat("Alignments:", result6$alignments_tried, "\n")
cat("Comparisons:", result6$comparison_count, "\n")

cat("\nTest 7:\n")
p7 <- "alfalfa"
t7 <- "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk."
p_bm7 <- BoyerMoore(p7, ASCIIchars)
result7 <- boyer_moore_with_counts(p7, p_bm7, t7)
cat("Occurrences:", result7$occurrences, "\n")
cat("Alignments:", result7$alignments_tried, "\n")
cat("Comparisons:", result7$comparison_count, "\n")
