def rFib
rFib = { it < 1 ? 0 : it == 1 ? 1 : rFib(it-1) + rFib(it-2) }
