implicit def IntToFac(i : Int) = new {
  def ! = (2 to i).foldLeft(BigInt(1))(_ * _)
}
