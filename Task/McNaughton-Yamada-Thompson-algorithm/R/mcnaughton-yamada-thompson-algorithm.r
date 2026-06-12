# Initialize global variables
stateCounter <- 0
stateList <- list()

# Function to create a new state
createState <- function(label = NULL) {
  stateCounter <<- stateCounter + 1
  id <- paste0("state", stateCounter)
  stateList[[id]] <<- list(label = label, edge1 = NULL, edge2 = NULL)
  id
}

# Functions to set edges for a state
setEdge1 <- function(stateID, edgeID) {
  stateList[[stateID]]$edge1 <<- edgeID
}

setEdge2 <- function(stateID, edgeID) {
  stateList[[stateID]]$edge2 <<- edgeID
}

# Function to convert infix regex to postfix using the Shunting Yard algorithm
shunt <- function(infix) {
  specials <- list('*' = 60, '+' = 55, '?' = 50, '.' = 40, '|' = 20)
  postfix <- ""
  stack <- c()
  cList <- strsplit(infix, "")[[1]]
  for (c in cList) {
    if (c == "(") {
      stack <- c(stack, c)
    } else if (c == ")") {
      while (length(stack) > 0 && tail(stack, 1) != "(") {
        postfix <- paste0(postfix, tail(stack, 1))
        stack <- head(stack, -1)
      }
      if (length(stack) > 0) {
        stack <- head(stack, -1)  # Remove "("
      }
    } else if (c %in% names(specials)) {
      while (length(stack) > 0 && tail(stack, 1) %in% names(specials) &&
             specials[[c]] <= specials[[tail(stack, 1)]]) {
        postfix <- paste0(postfix, tail(stack, 1))
        stack <- head(stack, -1)
      }
      stack <- c(stack, c)
    } else {
      postfix <- paste0(postfix, c)
    }
  }
  while (length(stack) > 0) {
    postfix <- paste0(postfix, tail(stack, 1))
    stack <- head(stack, -1)
  }
  postfix
}

# Function to compile postfix regex into an NFA
compileRegex <- function(postfix) {
  nfaStack <- list()
  cList <- strsplit(postfix, "")[[1]]
  for (c in cList) {
    if (c == '*') {
      nfa1 <- tail(nfaStack, 1)[[1]]
      nfaStack <- head(nfaStack, -1)
      initial <- createState()
      accept <- createState()
      setEdge1(initial, nfa1$initial)
      setEdge2(initial, accept)
      setEdge1(nfa1$accept, nfa1$initial)
      setEdge2(nfa1$accept, accept)
      nfaStack <- c(nfaStack, list(list(initial = initial, accept = accept)))
    } else if (c == '.') {
      nfa2 <- tail(nfaStack, 1)[[1]]
      nfaStack <- head(nfaStack, -1)
      nfa1 <- tail(nfaStack, 1)[[1]]
      nfaStack <- head(nfaStack, -1)
      setEdge1(nfa1$accept, nfa2$initial)
      nfaStack <- c(nfaStack, list(list(initial = nfa1$initial, accept = nfa2$accept)))
    } else if (c == '|') {
      nfa2 <- tail(nfaStack, 1)[[1]]
      nfaStack <- head(nfaStack, -1)
      nfa1 <- tail(nfaStack, 1)[[1]]
      nfaStack <- head(nfaStack, -1)
      initial <- createState()
      accept <- createState()
      setEdge1(initial, nfa1$initial)
      setEdge2(initial, nfa2$initial)
      setEdge1(nfa1$accept, accept)
      setEdge1(nfa2$accept, accept)
      nfaStack <- c(nfaStack, list(list(initial = initial, accept = accept)))
    } else if (c == '+') {
      nfa1 <- tail(nfaStack, 1)[[1]]
      nfaStack <- head(nfaStack, -1)
      initial <- createState()
      accept <- createState()
      setEdge1(initial, nfa1$initial)
      setEdge1(nfa1$accept, nfa1$initial)
      setEdge2(nfa1$accept, accept)
      nfaStack <- c(nfaStack, list(list(initial = initial, accept = accept)))
    } else if (c == '?') {
      nfa1 <- tail(nfaStack, 1)[[1]]
      nfaStack <- head(nfaStack, -1)
      initial <- createState()
      accept <- createState()
      setEdge1(initial, nfa1$initial)
      setEdge2(initial, accept)
      setEdge1(nfa1$accept, accept)
      nfaStack <- c(nfaStack, list(list(initial = initial, accept = accept)))
    } else {
      # Literal character
      initial <- createState(c)
      accept <- createState()
      setEdge1(initial, accept)
      nfaStack <- c(nfaStack, list(list(initial = initial, accept = accept)))
    }
  }
  tail(nfaStack, 1)[[1]]
}

# Function to compute the epsilon closure of a state
followes <- function(stateID) {
  states <- c()
  stack <- c(stateID)
  while (length(stack) > 0) {
    s <- tail(stack, 1)
    stack <- head(stack, -1)
    if (!(s %in% states)) {
      states <- c(states, s)
      if (is.null(stateList[[s]]$label)) {
        if (!is.null(stateList[[s]]$edge1)) {
          stack <- c(stack, stateList[[s]]$edge1)
        }
        if (!is.null(stateList[[s]]$edge2)) {
          stack <- c(stack, stateList[[s]]$edge2)
        }
      }
    }
  }
  states
}

# Function to match a string against the regex
matchRegex <- function(infix, str) {
  postfix <- shunt(infix)
  stateCounter <<- 0  # Reset stateCounter
  stateList <<- list()  # Reset stateList
  nfa <- compileRegex(postfix)
  current <- followes(nfa$initial)
  cList <- strsplit(str, "")[[1]]
  for (c in cList) {
    nextStates <- c()
    for (state in current) {
      if (!is.null(stateList[[state]]$label) && stateList[[state]]$label == c) {
        nextStates <- union(nextStates, followes(stateList[[state]]$edge1))
      }
    }
    current <- nextStates
  }
  nfa$accept %in% current
}

# Test cases
infixes <- c("a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c")
strings <- c("", "abc", "abbc", "abcc", "abad", "abbbc")

for (infix in infixes) {
  for (str in strings) {
    result <- matchRegex(infix, str)
    cat(ifelse(result, "True ", "False "), infix, " ", str, "\n")
  }
  cat("\n")
}
