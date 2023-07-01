J_n_S <- function(stones  ="aAAbbbb", jewels = "aA") {
  stones <- unlist(strsplit(stones, split = "")) # obtain a character vector
  jewels <- unlist(strsplit(jewels, split = ""))
  count <- sum(stones %in% jewels)
}

print(J_n_S("aAAbbbb", "aA"))
print(J_n_S("ZZ", "z"))
print(J_n_S("lgGKJGljglghGLGHlhglghoIPOgfdtrdDCHnvbnmBVC", "fFgGhH"))
