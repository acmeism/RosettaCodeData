def fib
    phi = (1 + Math.sqrt(5)) / 2
    ((phi**self - (-1 / phi)**self) / Math.sqrt(5)).to_i
end
