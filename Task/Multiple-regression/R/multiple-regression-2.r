simpleMultipleReg <- function(formula) {

    ## parse and evaluate the model formula
    mf <- model.frame(formula)

    ## create design matrix
    X <- model.matrix(mf)

    ## create dependent variable
    Y <- model.response(mf)

    ## solve
    solve(t(X) %*% X) %*% t(X) %*% Y
}

simpleMultipleReg(y ~ x + I(x^2))
