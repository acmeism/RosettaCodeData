! diffusion grid time step
where     (edge_type(1:n,1:m) == center)
   anew(1:n,1:m) = (a(1:n,1:m) + a(0:n-1,1:m) + a(2:n+1,1:m) + a(1:n,0:m-1) + a(1:n,2:m+1)) / 5

elsewhere (edge_type(1:n,1:m) == left)
   anew(1:n,1:m) = (a(1:n,1:m) + 2*a(2:n+1,1:m) + a(1:n,0:m-1) + a(1:n,2:m+1)) / 5

elsewhere (edge_type(1:n,1:m) == right)
   anew(1:n,1:m) = (a(1:n,1:m) + 2*a(0:n-1,1:m) + a(1:n,0:m-1) + a(1:n,2:m+1)) / 5

elsewhere (edge_type(1:n,1:m) == top)
   anew(1:n,1:m) = (a(1:n,1:m) + a(0:n-1,1:m) + a(2:n+1,1:m) + 2*a(1:n,2:m+1)) / 5

elsewhere (edge_type(1:n,1:m) == bottom)
   anew(1:n,1:m) = (a(1:n,1:m) + a(0:n-1,1:m) + a(2:n+1,1:m) + 2*a(1:n,0:m-1)) / 5

elsewhere (edge_type(1:n,1:m) == left_top)
   anew(1:n,1:m) = (a(1:n,1:m) + 2*a(2:n+1,1:m) + 2*a(1:n,2:m+1)) / 5

elsewhere (edge_type(1:n,1:m) == right_top)
   anew(1:n,1:m) = (a(1:n,1:m) + 2*a(0:n-1,1:m) + 2*a(1:n,2:m+1)) / 5

elsewhere (edge_type(1:n,1:m) == left_bottom)
   anew(1:n,1:m) = (a(1:n,1:m) + 2*a(2:n+1,1:m) + 2*a(1:n,0:m-1)) / 5

elsewhere (edge_type(1:n,1:m) == right_bottom)
   anew(1:n,1:m) = (a(1:n,1:m) + 2*a(0:n-1,1:m) + 2*a(1:n,0:m-1)) / 5

elsewhere      ! sink/source, does not change
   anew(1:n,1:m) = a(1:n,1:m)
end where
