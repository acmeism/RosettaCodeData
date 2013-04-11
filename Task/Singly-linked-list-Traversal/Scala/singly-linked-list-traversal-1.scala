def traverse1[T](xs: Seq[T]): Unit = xs match {
  case s if s.isEmpty => ()
  case _ => { Console.println(xs.head);
              traverse1(xs.tail)
  }
}
