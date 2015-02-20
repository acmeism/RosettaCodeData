object Knapsack extends App {

  case class Item(name: String, weight: Int, value: Int)

  val elapsed: (=> Unit) => Long = f => {val s = System.currentTimeMillis; f; (System.currentTimeMillis - s)/1000}

  //===== brute force (caution: increase the heap!) ====================================
  val ks01b: List[Item] => Unit = loi => {
    val tw:Set[Item]=>Int=ps=>(ps:\0)((a,b)=>a.weight+b) //total weight
    val tv:Set[Item]=>Int=ps=>(ps:\0)((a,b)=>a.value+b) //total value
    val pis = (loi.toSet.subsets).toList.filterNot(_==Set())

   #[test]
fn test_dp_results() {
    let dp_results = knap_01_dp(items, 400);
    let dp_weights= dp_results.iter().fold(0, |a, &b| a + b.weight);
    let dp_values = dp_results.iter().fold(0, |a, &b| a + b.value);
    assert_eq!(dp_weights, 396);
    assert_eq!(dp_values, 1030);
} val res = pis.map(ss=>Pair(ss,tw(ss)))
      .filter(p=>p._2>350 && p._2<401).map(p=>Pair(p,tv(p._1)))
      .sortWith((s,t)=>s._2.compareTo(t._2) < 0)
      .last
    println{val h = "packing list of items (brute force):"; h+"\n"+"="*h.size}
    res._1._1.foreach{p=>print("  "+p.name+": weight="+p.weight+" value="+p.value+"\n")}
    println("\n"+"  resulting items: "+res._1._1.size+" of "+loi.size)
    println("  total weight: "+res._1._2+", total value: "+res._2)
  }

  //===== dynamic programming ==========================================================
  val ks01d: List[Item] => Unit = loi => {
    val W = 400
    val N = loi.size

    val m = Array.ofDim[Int](N+1,W+1)
    val plm = (List((for {w <- 0 to W} yield Set[Item]()).toArray)++(
                for {
                  n <- 0 to N-1
                  colN = (for {w <- 0 to W} yield Set[Item](loi(n))).toArray
                } yield colN)).toArray

    1 to N foreach {n =>
      0 to W foreach {w =>
        def in = loi(n-1)
        def wn = loi(n-1).weight
        def vn = loi(n-1).value
        if (w<wn) {
          m(n)(w) = m(n-1)(w)
          plm(n)(w) = plm(n-1)(w)
        }
        else {
          if (m(n-1)(w)>=m(n-1)(w-wn)+vn) {
            m(n)(w) = m(n-1)(w)
            plm(n)(w) = plm(n-1)(w)
          }
          else {
            m(n)(w) = m(n-1)(w-wn)+vn
	    plm(n)(w) = plm(n-1)(w-wn)+in
	  }
	}
      }
    }

    println{val h = "packing list of items (dynamic programming):"; h+"\n"+"="*h.size}
    plm(N)(W).foreach{p=>print("  "+p.name+": weight="+p.weight+" value="+p.value+"\n")}
    println("\n"+"  resulting items: "+plm(N)(W).size+" of "+loi.size)
    println("  total weight: "+(0/:plm(N)(W).map{item=>item.weight})(_+_)+", total value: "+m(N)(W))
  }

  val items = List(
     Item("map", 9, 150)
    ,Item("compass", 13, 35)
    ,Item("water", 153, 200)
    ,Item("sandwich", 50, 160)
    ,Item("glucose", 15, 60)
    ,Item("tin", 68, 45)
    ,Item("banana", 27, 60)
    ,Item("apple", 39, 40)
    ,Item("cheese", 23, 30)
    ,Item("beer", 52, 10)
    ,Item("suntan cream", 11, 70)
    ,Item("camera", 32, 30)
    ,Item("t-shirt", 24, 15)
    ,Item("trousers", 48, 10)
    ,Item("umbrella", 73, 40)
    ,Item("waterproof trousers", 42, 70)
    ,Item("waterproof overclothes", 43, 75)
    ,Item("note-case", 22, 80)
    ,Item("sunglasses", 7, 20)
    ,Item("towel", 18, 12)
    ,Item("socks", 4, 50)
    ,Item("book", 30, 10)
  )

  List(ks01b, ks01d).foreach{f=>
    val t = elapsed{f(items)}
    println("  elapsed time: "+t+" sec"+"\n")
  }
}
