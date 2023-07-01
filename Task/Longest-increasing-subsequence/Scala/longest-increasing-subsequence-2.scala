def powerset[A](s: List[A]) = (0 to s.size).map(s.combinations(_)).reduce(_++_)
def isSorted(l:List[Int])(f: (Int, Int) => Boolean) = l.view.zip(l.tail).forall(x => f(x._1,x._2))
def sequence(set: List[Int])(f: (Int, Int) => Boolean) = powerset(set).filter(_.nonEmpty).filter(x => isSorted(x)(f)).toList.maxBy(_.length)

sequence(set)(_<_)
sequence(set)(_>_)
