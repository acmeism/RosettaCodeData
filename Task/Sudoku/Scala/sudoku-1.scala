object SudokuSolver extends App {

  class Solver {

    var solution = new Array[Int](81)   //listOfFields toArray

    val fp2m: Int => Tuple2[Int,Int] = pos => Pair(pos/9+1,pos%9+1) //get row, col from array position
    val setAll = (1 to 9) toSet //all possibilities

    val arrayGroups = new Array[List[List[Int]]](81)
    val sv: Int => Int = (row: Int) => (row-1)*9 //start value group row
    val ev: Int => Int = (row: Int) => sv(row)+8 //end value group row
    val fgc: (Int,Int) => Int = (i,col) => i*9+col-1 //get group col
    val fgs: Int => (Int,Int) = p => Pair(p, p/(27)*3+p%9/3) //get group square box
    for (pos <- 0 to 80) {
      val (row,col) = fp2m(pos)
      val gRow = (sv(row) to ev(row)).toList
      val gCol = ((0 to 8) toList) map (fgc(_,col))
      val gSquare = (0 to 80 toList) map fgs filter (_._2==(fgs(pos))._2) map (_._1)
      arrayGroups(pos) = List(gRow,gCol,gSquare)
    }
    val listGroups = arrayGroups toList

    val fpv4s: (Int) => List[Int] = pos => {   //get possible values for solving
      val setRow = (listGroups(pos)(0) map (solution(_))).toSet
      val setCol = listGroups(pos)(1).map(solution(_)).toSet
      val setSquare = listGroups(pos)(2).map(solution(_)).toSet
      val setG = setRow++setCol++setSquare--Set(0)
      val setPossible = setAll--setG
      setPossible.toList.sortWith(_<_)
    }


    //solve the riddle: Nil ==> solution does not exist
    def solve(listOfFields: List[Int]): List[Int] = {
      solution = listOfFields toArray

      def checkSol(uncheckedSol: List[Int]): List[Int] = {
        if (uncheckedSol == Nil) return Nil
        solution = uncheckedSol toArray
        val check = (0 to 80).map(fpv4s(_)).filter(_.size>0)
        if (check == Nil) return uncheckedSol
        return Nil
      }

      val f1: Int => Pair[Int,Int] = p => Pair(p,listOfFields(p))
      val numFields = (0 to 80 toList) map f1 filter (_._2==0)
      val iter = numFields map ((_: (Int,Int))._1)
      var p_iter = 0

      val first: () => Int = () => {
        val ret = numFields match {
          case Nil => -1
          case _   => numFields(0)._1
        }
        ret
      }

      val last: () => Int = () => {
        val ret = numFields match {
          case Nil => -1
          case _   => numFields(numFields.size-1)._1
        }
        ret
      }

      val hasPrev: () => Boolean = () => p_iter > 0
      val prev: () => Int = () => {p_iter -= 1; iter(p_iter)}
      val hasNext: () => Boolean = () => p_iter < iter.size-1
      val next: () => Int = () => {p_iter += 1; iter(p_iter)}
      val fixed: Int => Boolean = pos => listOfFields(pos) != 0
      val possiArray = new Array[List[Int]](numFields.size)
      val firstUF = first() //first unfixed
      if (firstUF < 0) return checkSol(solution.toList) //that is it!
      var pif = iter(p_iter) //pos in fields
      val lastUF = last() //last unfixed
      val (row,col) = fp2m(pif)
      possiArray(p_iter) = fpv4s(pif).toList.sortWith(_<_)

      while(pif <= lastUF) {
        val (row,col) = fp2m(pif)
        if (possiArray(p_iter) == null) possiArray(p_iter) = fpv4s(pif).toList.sortWith(_<_)
        val possis = possiArray(p_iter)
        if (possis.isEmpty) {
          if (hasPrev()) {
            possiArray(p_iter) = null
            solution(pif) = 0
            pif = prev()
          } else {
            return Nil
          }
        } else {
          solution(pif) = possis(0)
          possiArray(p_iter) = (possis.toSet - possis(0)).toList.sortWith(_<_)
          if (hasNext()) {
            pif = next()
          } else {
            return checkSol(solution.toList)
          }
        }
      }
      checkSol(solution.toList)
    }
  }

  val f2Str: List[Int] => String = fields => {
    val sepLine = "+---+---+---+"
    val sepPoints = Set(2,5,8)
    val fs: (Int, Int) => String = (i, v) => v.toString.replace("0"," ")+(if (sepPoints.contains(i%9)) "|" else "")
    sepLine+"\n"+(0 to fields.size-1).map(i => (if (i%9==0) "|" else "")+fs(i,fields(i))+(if (i%9==8) if (sepPoints.contains(i/9)) "\n"+sepLine+"\n" else "\n" else "")).foldRight("")(_+_)
  }

  val solver = new Solver()

  val riddle = List(3,9,4,0,0,2,6,7,0,
                    0,0,0,3,0,0,4,0,0,
                    5,0,0,6,9,0,0,2,0,
                    0,4,5,0,0,0,9,0,0,
                    6,0,0,0,0,0,0,0,7,
                    0,0,7,0,0,0,5,8,0,
                    0,1,0,0,6,7,0,0,8,
                    0,0,9,0,0,8,0,0,0,
                    0,2,6,4,0,0,7,3,5)

  println("riddle:")
  println(f2Str(riddle))
  var solution = solver.solve(riddle)

  println("solution:")
  println(solution match {case Nil => "no solution!!!" case _ => f2Str(solution)})

}
