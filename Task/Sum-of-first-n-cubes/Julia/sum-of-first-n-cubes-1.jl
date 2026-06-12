cubesumstil(N = 49, s = 0) = (foreach(n -> print(lpad(s += n^3, 8), n % 10 == 9 ? "\n" : ""), 0:N))

cubesumstil()
