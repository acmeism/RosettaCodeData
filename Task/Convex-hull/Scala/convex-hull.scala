object convex_hull{
    def get_hull(points:List[(Double,Double)], hull:List[(Double,Double)]):List[(Double,Double)] = points match{
        case Nil  =>            join_tail(hull,hull.size -1)
        case head :: tail =>    get_hull(tail,reduce(head::hull))
    }
    def reduce(hull:List[(Double,Double)]):List[(Double,Double)] = hull match{
        case p1::p2::p3::rest => {
            if(check_point(p1,p2,p3))      hull
            else                           reduce(p1::p3::rest)
        }
        case _ =>                          hull
    }
    def check_point(pnt:(Double,Double), p2:(Double,Double),p1:(Double,Double)): Boolean = {
        val (x,y) = (pnt._1,pnt._2)
        val (x1,y1) = (p1._1,p1._2)
        val (x2,y2) = (p2._1,p2._2)
        ((x-x1)*(y2-y1) - (x2-x1)*(y-y1)) <= 0
    }
    def m(p1:(Double,Double), p2:(Double,Double)):Double = {
        if(p2._1 == p1._1 && p1._2>p2._2)       90
        else if(p2._1 == p1._1 && p1._2<p2._2)  -90
        else if(p1._1<p2._1)                    180 - Math.toDegrees(Math.atan(-(p1._2 - p2._2)/(p1._1 - p2._1)))
        else                                    Math.toDegrees(Math.atan((p1._2 - p2._2)/(p1._1 - p2._1)))
    }
    def join_tail(hull:List[(Double,Double)],len:Int):List[(Double,Double)] = {
        if(m(hull(len),hull(0)) > m(hull(len-1),hull(0)))   join_tail(hull.slice(0,len),len-1)
        else                                                hull
    }
    def main(args:Array[String]){
        val points = List[(Double,Double)]((16,3), (12,17), (0,6), (-4,-6), (16,6), (16,-7), (16,-3), (17,-4), (5,19), (19,-8), (3,16), (12,13), (3,-4), (17,5), (-3,15), (-3,-9), (0,11), (-9,-3), (-4,-2), (12,10))
        val sorted_points = points.sortWith(m(_,(0.0,0.0)) < m(_,(0.0,0.0)))
        println(f"Points:\n" + points + f"\n\nConvex Hull :\n" +get_hull(sorted_points,List[(Double,Double)]()))
    }
}
