# Define regular expression types
EmptyExpr <- function() list(type = 'EmptyExpr')
EpsilonExpr <- function() list(type = 'EpsilonExpr')
CarExpr <- function(c) list(type = 'CarExpr', c = c)
UnionExpr <- function(e, f) list(type = 'UnionExpr', e = e, f = f)
ConcatExpr <- function(e, f) list(type = 'ConcatExpr', e = e, f = f)
StarExpr <- function(e) list(type = 'StarExpr', e = e)

# Simplify regular expressions
simplify <- function(expr) {
  if (expr$type == 'EmptyExpr') {
    expr
  } else if (expr$type == 'EpsilonExpr') {
    expr
  } else if (expr$type == 'CarExpr') {
    expr
  } else if (expr$type == 'UnionExpr') {
    e <- simplify(expr$e)
    f <- simplify(expr$f)
    if (identical(e, f)) {
      e
    } else if (e$type == 'EmptyExpr') {
      f
    } else if (f$type == 'EmptyExpr') {
      e
    } else {
      list(type = 'UnionExpr', e = e, f = f)
    }
  } else if (expr$type == 'ConcatExpr') {
    e <- simplify(expr$e)
    f <- simplify(expr$f)
    if (e$type == 'EpsilonExpr') {
      f
    } else if (f$type == 'EpsilonExpr') {
      e
    } else if (e$type == 'EmptyExpr' || f$type == 'EmptyExpr') {
      EmptyExpr()
    } else {
      list(type = 'ConcatExpr', e = e, f = f)
    }
  } else if (expr$type == 'StarExpr') {
    e <- simplify(expr$e)
    if (e$type == 'EmptyExpr' || e$type == 'EpsilonExpr') {
      EpsilonExpr()
    } else {
      list(type = 'StarExpr', e = e)
    }
  } else {
    expr
  }
}

# Recursively simplify expressions with depth limit
recursiveSimplify <- function(expr, depth) {
  if (depth > 200) {
    return(expr)
  } else {
    simplified <- simplify(expr)
    if (identical(simplified, expr)) {
      return(simplified)
    } else {
      recursiveSimplify(simplified, depth + 1)
    }
  }
}

# String representation of the regular expression
sprintRE <- function(expr) {
  if (expr$type == 'EmptyExpr') {
    "0"
  } else if (expr$type == 'EpsilonExpr') {
    "1"
  } else if (expr$type == 'CarExpr') {
    as.character(expr$c)
  } else if (expr$type == 'UnionExpr') {
    paste0(sprintRE(expr$e), "+", sprintRE(expr$f))
  } else if (expr$type == 'ConcatExpr') {
    paste0("(", sprintRE(expr$e), ")(", sprintRE(expr$f), ")")
  } else if (expr$type == 'StarExpr') {
    paste0("(", sprintRE(expr$e), ")*")
  } else {
    ""
  }
}

# Brzozowski's Algorithm for NFA to DFA conversion
brzozowski <- function(a, b) {
  m <- length(a)
  tempA <- a
  tempB <- b

  for (n in seq(m, 1)) {
    tempB[[n]] <- (ConcatExpr(StarExpr(tempA[[n]][[n]]), tempB[[n]]))

    for (j in seq_len(n - 1)) {
      tempA[[n]][[j]] <- (ConcatExpr(StarExpr(tempA[[n]][[n]]), tempA[[n]][[j]]))
    }

    for (i in seq_len(n - 1)) {
      tempB[[i]] <- (UnionExpr(tempB[[i]], ConcatExpr(tempA[[i]][[n]], tempB[[n]])))

      for (j in seq_len(n - 1)) {
        tempA[[i]][[j]] <- (UnionExpr(
          tempA[[i]][[j]],
          ConcatExpr(tempA[[i]][[n]], tempA[[n]][[j]])
        ))
      }
    }

    for (i in seq_len(n - 1)) {
      tempA[[i]][[n]] <- EmptyExpr()
    }
  }

  tempB[[1]]
}

# Define an example NFA transition matrix
a <- list(
  list(EmptyExpr(), CarExpr("a"), CarExpr("b")),
  list(CarExpr("b"), EmptyExpr(), CarExpr("a")),
  list(CarExpr("a"), CarExpr("b"), EmptyExpr())
)

b <- list(EpsilonExpr(), EmptyExpr(), EmptyExpr())

# Convert NFA to DFA using Brzozowski's algorithm
dfaExpr <- brzozowski(a, b)

cat(sprintRE(dfaExpr), "\n\n", sep="")

# Apply recursive simplification and print the simplified result
simplifiedDFA <- recursiveSimplify(dfaExpr, 0)
cat(sprintRE(simplifiedDFA), "\n", sep="")
