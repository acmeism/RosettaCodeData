object SudokuSolver extends App {

  object Solver {
    var solution = new Array[Int](81)

    val fap: (Int, Int) => Int = (row, col) => (row)*9+col //function array position

    def solve(listOfFields: List[Int]): List[Int] = {
      solution = listOfFields toArray

      val mRowSubset = new Array[Boolean](81)
      val mColSubset = new Array[Boolean](81)
      val mBoxSubset = new Array[Boolean](81)

      def initSubsets: Unit = {
        for (row <- 0 to 8) {
          for (col <- 0 to 8) {
            val value = solution(fap(row, col))
            if (value != 0)
              setSubsetValue(row, col, value, true)
          }
        }
      }

      def setSubsetValue(r: Int, c: Int, value: Int, present: Boolean): Unit = {
        mRowSubset(fap(r, value - 1)) = present
        mColSubset(fap(c, value - 1)) = present
        mBoxSubset(fap(computeBoxNo(r, c), value - 1)) = present
      }

      def computeBoxNo(r: Int, c: Int): Int = {
        val boxRow = r / 3
        val boxCol = c / 3
        return boxRow * 3 + boxCol
      }

      def isValid(r: Int, c: Int, value: Int): Boolean = {
        val vVal = value - 1
        val isPresent = mRowSubset(fap(r, vVal)) || mColSubset(fap(c, vVal)) || mBoxSubset(fap(computeBoxNo(r, c), vVal))
        return !isPresent
      }

      def solve(row: Int, col: Int): Boolean = {
        var r = row
        var c = col

        if (r == 9) {
          r = 0
          c += 1
          if (c == 9)
            return true
        }

        if(solution(fap(r,c)) != 0)
          return solve(r+1,c)
        for(value <- 1 to 9)
          if(isValid(r, c, value)) {
            solution(fap(r,c)) = value
            setSubsetValue(r, c, value, true)
            if(solve(r+1,c))
              return true
            setSubsetValue(r, c, value, false)
          }
        solution(fap(r,c)) = 0
        return false
      }

      def checkSol: Boolean = {
        initSubsets
        if ((mRowSubset.exists(_==false)) || (mColSubset.exists(_==false)) || (mBoxSubset.exists(_==false))) return false
        true
      }

      initSubsets
      val ret = solve(0,0)
      if (ret)
        if (checkSol) return solution.toList else Nil
      else
        return Nil
    }
  }

  val f2Str: List[Int] => String = fields => {
    val f2Stri: List[Int] => String = fields => {
      val sepLine = "+---+---+---+"
      val sepPoints = Set(2,5,8)
      val fs: (Int, Int) => String = (i, v) => v.toString.replace("0"," ")+(if (sepPoints.contains(i%9)) "|" else "")
      val s = sepLine+"\n"+(0 to fields.size-1).map(i => (if (i%9==0) "|" else "")+fs(i,fields(i))+(if (i%9==8) if (sepPoints.contains(i/9)) "\n"+sepLine+"\n" else "\n" else "")).foldRight("")(_+_)
      s
    }
    val s = fields match {case Nil => "no solution!!!" case _ => f2Stri(fields)}
    s
  }

  val elapsedtime: (=> Unit) => Long = f => {val s = System.currentTimeMillis; f; (System.currentTimeMillis - s)/1000}

  var sol = List[Int]()

  val sudokus = List(
      ("riddle used in Ada section:",
       "394..267....3..4..5..69..2..45...9..6.......7..7...58..1..67..8..9..8....264..735"),
      ("riddle used in Bracmat section:",
       "..............3.85..1.2.......5.7.....4...1...9.......5......73..2.1........4...9"),
      ("riddle from Groovy section: 4th exceptionally difficult example in Wikipedia: ~80 seconds",
       "..3......4...8..36..8...1...4..6..73...9..........2..5..4.7..686........7..6..5.."),
      ("riddle used in Ada section with incorrect modifactions - it should fail:",
       "3943.267....3..4..5..69..2..45...9..6.......7..7...58..1..67..8..9..8....264..735"),
      ("riddle constructed with mess - it should fail too:",
       "123456789456789123789123456.45..89..6.......72.7...58.31..67..8..9..8....264..735"))

  for (sudoku <- sudokus) {
    val desc = sudoku._1
    val riddle = sudoku._2.replace(".","0").toList.map(_.toString.toInt)
    println(desc+"\n"+f2Str(riddle)+"\n"
      +"elapsed time: "+elapsedtime(sol = Solver.solve(riddle))+" sec"+"\n"+"solution:"+"\n"+f2Str(sol)
      +("\n"*2))
  }
}
