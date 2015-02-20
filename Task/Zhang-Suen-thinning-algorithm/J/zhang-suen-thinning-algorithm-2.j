zhangSuenX=: verb define
  img=. isBlackPx y
  whilst. 0 < +/ , msk1 +.&-. msk2 do.
    msk1=. (-.@:*. [: frameImg cond1 neighbrs) img
    img=. msk1 * img
    msk2=. (-.@:*. [: frameImg cond2 neighbrs) img
    img=. msk2 * img
  end.
  toImage img
)
