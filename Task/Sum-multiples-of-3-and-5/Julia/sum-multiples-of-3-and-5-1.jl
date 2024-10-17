multsum(n, m, lim) = sum(0:n:lim-1) + sum(0:m:lim-1) - sum(0:lcm(n,m):lim-1)
