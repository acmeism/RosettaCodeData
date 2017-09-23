object kaprekar{
    // PART 1
    val co_base = ((x:Int,base:Int) => (x%(base-1) == (x*x)%(base-1)))
    //PART 2
    def get_cands(n:Int,base:Int):List[Int] = {
        if(n==1)                                List[Int]()
        else if (co_base(n,base))               n :: get_cands(n-1,base)
        else                                    get_cands(n-1,base)
    }
    def main(args:Array[String]) : Unit = {
        //PART 3
        val base = 31
        println("Candidates for Kaprekar numbers found by casting out method with base %d:".format(base))
        println(get_cands(1000,base))
    }
}
