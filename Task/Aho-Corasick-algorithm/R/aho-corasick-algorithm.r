VALID_CHARS <- letters  # 'a' to 'z'

# Node constructor
create_node <- function() {
  list(
    son = integer(length(VALID_CHARS)),
    ans = 0L,
    fail = 1L,
    du = 0L,
    idx = 0L
  )
}

# ACAutomaton constructor
create_ac_automaton <- function(max_nodes) {
  tr <- vector("list", max_nodes)
  for (i in 1:max_nodes) {
    tr[[i]] <- create_node()
  }
  list(
    tr = tr,
    tot = 1L,
    final_ans = integer(0),
    pidx = 0L
  )
}

# Insert pattern into automaton
insert <- function(ac, pattern) {
  u <- 1L  # 1-based, root node position is 1

  for (ch in strsplit(pattern, "")[[1]]) {
    char_code <- match(ch, VALID_CHARS)
    if (is.na(char_code)) next

    if (ac$tr[[u]]$son[char_code] == 0) {
      ac$tot <- ac$tot + 1L
      ac$tr[[u]]$son[char_code] <- ac$tot
    }
    u <- ac$tr[[u]]$son[char_code]
  }

  if (ac$tr[[u]]$idx == 0) {
    ac$pidx <- ac$pidx + 1L
    ac$tr[[u]]$idx <- ac$pidx
  }

  list(ac = ac, idx = ac$tr[[u]]$idx)
}

# Build failure links
build <- function(ac) {
  q <- c()
  for (i in seq_along(VALID_CHARS)) {
    if (ac$tr[[1]]$son[i] != 0) {
      q <- c(q, ac$tr[[1]]$son[i])
    }
  }

  while (length(q) > 0) {
    u <- q[1]
    q <- q[-1]

    for (i in seq_along(VALID_CHARS)) {
      son_node_idx <- ac$tr[[u]]$son[i]
      fail_node_idx <- ac$tr[[u]]$fail

      if (son_node_idx != 0) {
        ac$tr[[son_node_idx]]$fail <- ac$tr[[fail_node_idx]]$son[i]
        ac$tr[[ac$tr[[son_node_idx]]$fail]]$du <-
          ac$tr[[ac$tr[[son_node_idx]]$fail]]$du + 1L
        q <- c(q, son_node_idx)
      } else {
        ac$tr[[u]]$son[i] <- ac$tr[[fail_node_idx]]$son[i]
      }
    }
  }

  ac
}

# Query text for patterns
query <- function(ac, text) {
  u <- 1L

  for (ch in strsplit(text, "")[[1]]) {
    char_code <- match(ch, VALID_CHARS)
    if (is.na(char_code)) next

    u <- ac$tr[[u]]$son[char_code]
    ac$tr[[u]]$ans <- ac$tr[[u]]$ans + 1L
  }

  ac
}

# Calculate final answers
calculate_final_answers <- function(ac) {
  ac$final_ans <- integer(ac$pidx + 1L)

  q <- c()
  for (i in 1:ac$tot) {
    if (ac$tr[[i]]$du == 0) {
      q <- c(q, i)
    }
  }

  while (length(q) > 0) {
    u <- q[length(q)]
    q <- q[-length(q)]

    idx <- ac$tr[[u]]$idx
    if (idx != 0) {
      ac$final_ans[idx] <- ac$tr[[u]]$ans
    }

    v <- ac$tr[[u]]$fail
    if (v > 1) {
      ac$tr[[v]]$ans <- ac$tr[[v]]$ans + ac$tr[[u]]$ans
      ac$tr[[v]]$du <- ac$tr[[v]]$du - 1L
      if (ac$tr[[v]]$du == 0) {
        q <- c(q, v)
      }
    }
  }

  ac
}

# Test function
test_aho_corasick <- function() {
  max_nodes <- 200000L + 6L
  n <- 5L

  ac <- create_ac_automaton(max_nodes)
  ids <- integer(n + 1L)

  input <- c("a", "bb", "aa", "abaa", "abaaa")
  text <- "abaaabaa"

  for (i in 1:n) {
    pattern <- input[i]
    result <- insert(ac, pattern)
    ac <- result$ac
    ids[i + 1L] <- result$idx
  }

  ac <- build(ac)
  ac <- query(ac, text)
  ac <- calculate_final_answers(ac)

  for (i in 1:n) {
    uniqueid <- ids[i]
    cat("Number of instances of", input[i], ":",
        ac$final_ans[uniqueid + 1L], "\n")
  }
}

# Run test
test_aho_corasick()
