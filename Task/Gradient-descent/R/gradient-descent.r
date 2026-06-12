# Define the function f(x, y)
f <- function(p) {
  x <- p[1]
  y <- p[2]
  return((x - 1)^2 * exp(-y^2) + y * (y + 2) * exp(-2 * x^2))
}

# Partial derivative with respect to x
dfdx <- function(p) {
  x <- p[1]
  y <- p[2]
  return(2 * (x - 1) * exp(-y^2) - 4 * x * y * (y + 2) * exp(-2 * x^2))
}

# Partial derivative with respect to y
dfdy <- function(p) {
  x <- p[1]
  y <- p[2]
  return(-2 * y * (x - 1)^2 * exp(-y^2) + 2 * (y + 1) * exp(-2 * x^2))
}

# Gradient descent function
gradient_descent <- function(minimum, alpha, epsilon) {
  # Calculate initial values
  minimum_function_value <- f(minimum)
  gradient <- c(dfdx(minimum), dfdy(minimum))

  # Calculate the step size for the first iteration
  delta_gradient <- sqrt(gradient[1]^2 + gradient[2]^2)
  step_size <- alpha / delta_gradient

  while (delta_gradient > epsilon) {
    # Calculate the next value for the minimum point
    minimum <- c(minimum[1] - step_size * gradient[1],
                 minimum[2] - step_size * gradient[2])

    # Calculate next gradient
    gradient <- c(dfdx(minimum), dfdy(minimum))

    # Calculate the step size for the next iteration
    delta_gradient <- sqrt(gradient[1]^2 + gradient[2]^2)
    step_size <- alpha / delta_gradient

    # Calculate the next function value
    function_value <- f(minimum)

    # Prepare for the next iteration
    if (function_value > minimum_function_value) {
      alpha <- alpha / 2
    } else {
      minimum_function_value <- function_value
    }
  }

  return(minimum)
}

# Main execution
epsilon <- 0.0000001
alpha <- 0.1
initial_point <- c(0.1, -1.0)  # Initial estimate for the location of minimum point

minimum <- gradient_descent(initial_point, alpha, epsilon)

cat("Using the gradient descent method the minimum point occurs at:\n")
cat(sprintf("x = %.6f, %.6f for which f(x, y) = %.6f\n",
            minimum[1], minimum[2], f(minimum)))
