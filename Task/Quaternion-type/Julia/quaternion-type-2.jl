julia> q = Quaternion(1,0,0,0)
julia> q  = Quaternion (1, 2, 3, 4)
       q1 = Quaternion(2, 3, 4, 5)
       q2 = Quaternion(3, 4, 5, 6)
       r = 7.

julia> norm(q)
5.477225575051661

julia> -q
-1 - 2i - 3j - 4k

julia> conj(q)
1 - 2i - 3j - 4k

julia> r + q, q + r
(8.0 + 2.0i + 3.0j + 4.0k,8.0 + 2.0i + 3.0j + 4.0k)

julia> q1 + q2
5 + 7i + 9j + 11k

julia> r*q, q*r
(7.0 + 14.0i + 21.0j + 28.0k,7.0 + 14.0i + 21.0j + 28.0k)

julia> q1*q2, q2*q1, q1*q2 != q2*q1
(-56 + 16i + 24j + 26k,-56 + 18i + 20j + 28k,true)
