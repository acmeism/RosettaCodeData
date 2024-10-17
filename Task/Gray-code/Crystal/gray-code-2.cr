(0..31).each do |n|
  gr = gray_encode n
  bin = gray_decode gr
  printf "%2d : %05b => %05b => %05b : %2d\n", n, n, gr, bin, bin
end
