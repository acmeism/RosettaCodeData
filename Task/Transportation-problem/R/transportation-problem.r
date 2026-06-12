library(lpSolve)

# cost matrix
costs <- matrix(c(3, 5, 7,
                  3, 2, 5), nrow = 2, byrow = TRUE)

# constraints for suppliers
row.signs <- rep("<=", 2)
row.rhs <- c(25, 35)
# constraints for customers
col.signs <- rep("=", 3)
col.rhs <- c(20, 30, 10)

# minimum cost (objective value)
lp.transport(costs, "min", row.signs, row.rhs, col.signs, col.rhs)
# solution matrix
sol = lp.transport(costs, "min", row.signs, row.rhs, col.signs, col.rhs)$solution
rownames(sol) <- c("Supplier 1", "Supplier 2")
colnames(sol) <- c("Customer 1", "Customer 2", "Customer 3")
sol
