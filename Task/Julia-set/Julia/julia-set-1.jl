function iter(z,c)
  n = 0
  while (abs2(z)<4)  z = z^2+c ; n+=1 end
  return n
end

coord(i,j,w,h,a,b) = 2*a*(i-1)/(w-1) - a + im * (2*b*(j-1)/(h-1) - b)

palette(n) = string(min(3n,255)," ", min(n,255)," ", 0);

julia(c) = (w,h,a,b,i,j) -> palette(iter(coord(i,j,w,h,a,b), c))

writeppm(f; width=600,height=300,a=2,b=1,file="julia.ppm") =
  open(file, "w") do out
    write(out, string("P3\n", width, " ", height, "\n255\n"))
    writedlm(out, [f(width,height,a,b,i,j) for j = 1:height, i = 1:width], '\n')
  end
