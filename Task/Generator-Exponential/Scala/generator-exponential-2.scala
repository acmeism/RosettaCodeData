def filtered2(s:Stream[Int], c:Stream[Int]):Stream[Int]=(s, c) match {
   case (sh#::_, ch#::ct) if (sh>ch) => filtered2(s, ct)
   case (sh#::st, ch#::_) if (sh<ch) => sh #:: filtered2(st, c)
   case (_#::st, _) => filtered2(st, c)
}
