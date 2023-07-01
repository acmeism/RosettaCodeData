on run

  concat([["alpha", "beta", "gamma"], ¬
    ["delta", "epsilon", "zeta"], ¬
    ["eta", "theta", "iota"]])

end run


-- concat :: [[a]] -> [a]
on concat(xxs)
  set lst to {}
  repeat with xs in xxs
    set lst to lst & xs
  end repeat
  return lst
end concat
