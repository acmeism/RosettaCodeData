def totientPrd(num: Int): Int = {
  @tailrec
  def dTrec(f: Int, n: Int): Int = if(n%f == 0) dTrec(f, n/f) else n

  @tailrec
  def tTrec(ac: Int, i: Int, n: Int): Int = if(n != 1){
    if(n%i == 0) tTrec(ac*(i - 1)/i, i + 1, dTrec(i, n))
    else tTrec(ac, i + 1, n)
  }else{
    ac
  }

  tTrec(num, 2, num)
}
