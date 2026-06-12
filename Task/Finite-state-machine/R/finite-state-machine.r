prompts <- list("ready" = list("(D)eposit or (Q)uit? ",
                               c("D" = "waiting",
                                 "Q" = "exit")),
                "waiting" = list("(S)elect or (R)efund? ",
                                 c("S" = "dispensing",
                                   "R" = "refunding")),
                "dispensing" = list("(R)emove product. ",
                                    c("R" = "ready")),
                "refunding" = list("", "ready"))

fsm <- function() {
  state <- "ready"
  while (state != "exit") {
    cat("Machine is ", state, ".", sep="")
    transition <- prompts[[state]][[2]]
    repeat {
      input <- readline(prompt = prompts[[state]][[1]])
      valids <- names(transition)
      if (is.null(valids)) valids <- ""
      if (input %in% valids) break
    }
    if (identical(valids, "")) {
      state <- transition
    } else {
      state <- transition[input]
    }
  }
}

fsm()
