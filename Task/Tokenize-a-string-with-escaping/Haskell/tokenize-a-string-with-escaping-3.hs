main = runConduit $
  yieldMany "one^|uno||three^^^^|four^^^|^cuatro|"
  .| splitEscC '|' '^'
  .| mapM_C print
