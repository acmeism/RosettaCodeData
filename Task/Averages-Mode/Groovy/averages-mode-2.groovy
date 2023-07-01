def random = new Random()
def sourceList = [ 'Lamp', 42.0, java.awt.Color.RED, new Date(), ~/pattern/]
(0..10).each {
    def a = (0..10).collect { sourceList[random.nextInt(5)] }
    println "${mode(a)}    ==    mode(${a})"
}
