comb m n = filter ((==m . length) $ filterM (const [True, False]) [0..n-1]
