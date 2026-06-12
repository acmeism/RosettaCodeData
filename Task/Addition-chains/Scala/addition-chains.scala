object chains{

    def check_seq(pos:Int,seq:List[Int],n:Int,min_len:Int):(Int,Int) = {
        if(pos>min_len || seq(0)>n)             (min_len,0)
        else if(seq(0) == n)                    (pos,1)
        else if(pos<min_len)                    try_perm(0,pos,seq,n,min_len)
        else                                    (min_len,0)
    }

    def try_perm(i:Int,pos:Int,seq:List[Int],n:Int,min_len:Int):(Int,Int) = {
        if(i>pos)           return (min_len,0)
        val res1 = check_seq(pos+1,seq(0)+seq(i) :: seq,n,min_len)
        val res2 = try_perm(i+1,pos,seq,n,res1._1)
        if(res2._1 < res1._1)                   res2
        else if(res2._1 == res1._1)             (res2._1,res1._2 + res2._2)
        else {
            println("Try_perm exception")
            (0,0)
        }
    }
    val init_try_perm = (x:Int) => try_perm(0,0,List[Int](1),x,10)
    def find_brauer(num:Int): Unit = {
        val res = init_try_perm(num)
        println()
        println("N = %d".format(num))
        println("Minimum length of chains: L(n)= " + res._1 + f"\nNumber of minimum length Brauer chains: " + res._2)
    }
    def main(args:Array[String]) :Unit = {
        val nums = List(7,14,21,29,32,42,64)
        for (i <- nums)     find_brauer(i)
    }
}
