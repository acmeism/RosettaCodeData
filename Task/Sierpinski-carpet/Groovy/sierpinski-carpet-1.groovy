def base3 = { BigInteger i -> i.toString(3) }

def sierpinskiCarpet = { int order ->
    StringBuffer sb = new StringBuffer()
    def positions = 0..<(3**order)
    def digits = 0..<([order,1].max())

    positions.each { i ->
        String i3 = base3(i).padLeft(order, '0')

        positions.each { j ->
            String j3 = base3(j).padLeft(order, '0')

            sb << (digits.any{ i3[it] == '1' && j3[it] == '1' } ? '  ' : order.toString().padRight(2) )
        }
        sb << '\n'
    }
    sb.toString()
}
