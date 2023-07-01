lm.impl <- function(formula) {
  mf <- model.frame(formula)
  X <- model.matrix(mf)
  Y <- model.response(mf)
  qr.coef(qr(X), Y)
}


lm(y ~ x + I(x^2))

# Call:
# lm(formula = y ~ x + I(x^2))
#
# Coefficients:
# (Intercept)            x       I(x^2)
#      128.81      -143.16        61.96

lm.impl(y ~ x + I(x^2))

# (Intercept)           x      I(x^2)
#   128.81280  -143.16202    61.96033
