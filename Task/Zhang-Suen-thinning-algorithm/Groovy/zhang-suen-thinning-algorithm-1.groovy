def zhangSuen(text) {
    def image = text.split('\n').collect { line -> line.collect { it == '#' ? 1 : 0} }
    def p2, p3, p4, p5, p6, p7, p8, p9
    def step1 = { (p2 * p4 * p6 == 0) && (p4 * p6 * p8 == 0) }
    def step2 = { (p2 * p4 * p8 == 0) && (p2 * p6 * p8 == 0) }
    def reduce = { step ->
        def toWhite = []
        image.eachWithIndex{ line, y ->
            line.eachWithIndex{ pixel, x ->
                if (!pixel) return
                (p2, p3, p4, p5, p6, p7, p8, p9) = [image[y-1][x], image[y-1][x+1], image[y][x+1], image[y+1][x+1], image[y+1][x], image[y+1][x-1], image[y][x-1], image[y-1][x-1]]
                def a = [[p2,p3],[p3,p4],[p4,p5],[p5,p6],[p6,p7],[p7,p8],[p8,p9],[p9,p2]].collect { a1, a2 -> (a1 == 0 && a2 ==1) ? 1 : 0 }.sum()
                def b = [p2, p3, p4, p5, p6, p7, p8, p9].sum()
                if (a != 1 || b < 2 || b > 6) return

                if (step.call()) toWhite << [y,x]
            }
        }
        toWhite.each { y, x -> image[y][x] = 0 }
        !toWhite.isEmpty()
    }

    while (reduce(step1) | reduce(step2));
    image.collect { line -> line.collect { it ? '#' : '.' }.join('') }.join('\n')
}
