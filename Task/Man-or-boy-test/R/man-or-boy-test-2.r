call.by.name <- function(...) {
  cl <- as.list(match.call())
  sublist <- lapply(cl[2:(length(cl)-1)],
                    function(name) substitute(substitute(evalq(.,.caller),
                                                         list(.=substitute(name))),
                                              list(name=name)))
  names(sublist) <- enquote(cl[2:(length(cl)-1)])
  subcall <- do.call("call", c("list", lapply(sublist, enquote)))
  fndef <- cl[[length(cl)]]
  fndef[[3]] <- substitute({
    .caller <- parent.frame()
    eval(substitute(body, subcall))
  }, list(body=fndef[[3]], subcall=subcall))
  eval.parent(fndef)
}
