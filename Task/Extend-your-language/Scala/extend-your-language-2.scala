scala> if2(true)(true) {
     |   1
     | } else1 {
     |   9
     | } else2 {
     |   11
     | } orElse {
     |   45
     | }
res0: Int = 1

scala> if2(false)(true) {
     |   "Luffy"
     | } else1 {
     |   "Nami"
     | } else2 {
     |   "Sanji"
     | } orElse {
     |   "Zoro"
     | }
res1: java.lang.String = Sanji
