prob = c(aleph=1/5, beth=1/6, gimel=1/7, daleth=1/8, he=1/9, waw=1/10, zayin=1/11, heth=1759/27720)
  # Note that R doesn't actually require the weights
  # vector for rmultinom to sum to 1.
hebrew = c(rmultinom(1, 1e6, prob))
d = data.frame(
    Requested = prob,
    Obtained = hebrew/sum(hebrew))
print(d)
