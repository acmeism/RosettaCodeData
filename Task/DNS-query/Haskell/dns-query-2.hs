procedure main(A)
   host := gethost( A[1] | "www.kame.net") | stop("can't translate")
   write(host.name, ": ", host.addresses)
end
