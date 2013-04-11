> print(A, useSource=FALSE)
function (k, x1, x2, x3, x4, x5)
{
    .caller <- parent.frame()
    eval(substitute({
        Aout <- NULL
        B <- function() {
            k <<- k - 1
            Bout <- Aout <<- A(k, B(), x1, x2, x3, x4)
        }
        if (k <= 0) Aout <- x4 + x5 else B()
        Aout
    }, list(x1 = substitute(evalq(., .caller), list(. = substitute(x1))),
        x2 = substitute(evalq(., .caller), list(. = substitute(x2))),
        x3 = substitute(evalq(., .caller), list(. = substitute(x3))),
        x4 = substitute(evalq(., .caller), list(. = substitute(x4))),
        x5 = substitute(evalq(., .caller), list(. = substitute(x5))))))
}
