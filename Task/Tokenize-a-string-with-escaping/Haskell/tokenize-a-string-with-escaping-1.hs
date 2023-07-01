splitEsc :: (Foldable t1, Eq t) => t -> t -> t1 t -> [[t]]
splitEsc sep esc = reverse . map reverse . snd . foldl process (0, [[]])
  where process (st, r:rs) ch
          | st == 0 && ch == esc               = (1,      r:rs)
          | st == 0 && ch == sep               = (0,   []:r:rs)
          | st == 1 && sep == esc && ch /= sep = (0, [ch]:r:rs)
          | otherwise                          = (0, (ch:r):rs)
