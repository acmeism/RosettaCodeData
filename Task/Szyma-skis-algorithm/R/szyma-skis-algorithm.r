# Define a list to simulate the shared dictionary
dict_ <- setNames(rep(0, 20), 1:20)
critical_value <- 1

flag <- function(id_) {
  dict_[[as.character(id_)]]
}

run_szymanski <- function(id_, allszy) {
  others <- allszy[allszy != id_]
  dict_[[as.character(id_)]] <<- 1  # Standing outside waiting room

  # Busy-wait simulation (not real threading)
  while (any(sapply(others, function(t) flag(t) >= 3))) {
    Sys.sleep(0.001)  # Simulate Thread.Yield()
  }

  dict_[[as.character(id_)]] <<- 3  # Standing in doorway

  if (any(sapply(others, function(t) flag(t) == 1))) {
    dict_[[as.character(id_)]] <<- 2  # Waiting for other processes to enter
    while (!any(sapply(others, function(t) flag(t) == 4))) {
      Sys.sleep(0.001)  # Simulate Thread.Yield()
    }
  }

  dict_[[as.character(id_)]] <<- 4  # The door is closed

  for (t in others) {
    if (t >= id_) next
    while (flag(t) > 1) {
      Sys.sleep(0.001)  # Simulate Thread.Yield()
    }
  }

  # Critical section
  critical_value <<- critical_value + id_ * 3
  critical_value <<- as.integer(critical_value / 2)
  message(paste("Thread", id_, "changed the critical value to", critical_value, "."))

  # Exit protocol
  for (t in others) {
    if (t <= id_) next
    while (!flag(t) %in% c(0, 1, 4)) {
      Sys.sleep(0.001)  # Simulate Thread.Yield()
    }
  }

  dict_[[as.character(id_)]] <<- 0  # Leave
}

test_szymanski <- function(n) {
  allszy <- 1:n
  for (i in allszy) {
    run_szymanski(i, allszy)
  }
}

test_szymanski(20)

