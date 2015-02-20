object MaximumTrianglePathSum extends App {
    // Solution:
    def sum(triangle: Array[Array[Int]]) =
        triangle.reduceRight((upper, lower) =>
            upper zip (lower zip lower.tail)
            map {case (above, (left, right)) => above + Math.max(left, right)}
        ).head

    // Tests:
    def triangle = """
                          55
                        94 48
                       95 30 96
                     77 71 26 67
    """
    def parse(s: String) = s.trim.split("\\s+").map(_.toInt)
    def parseLines(s: String) = s.trim.split("\n").map(parse)
    def parseFile(f: String) = scala.io.Source.fromFile(f).getLines.map(parse).toArray
    println(sum(parseLines(triangle)))
    println(sum(parseFile("triangle.txt")))
}
