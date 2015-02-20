def presents = ['A partridge in a pear tree.', 'Two turtle doves', 'Three french hens', 'Four calling birds',
        'Five golden rings', 'Six geese a-laying', 'Seven swans a-swimming', 'Eight maids a-milking',
        'Nine ladies dancing', 'Ten lords a-leaping', 'Eleven pipers piping', 'Twelve drummers drumming']
['first', 'second', 'third', 'forth', 'fifth', 'sixth', 'seventh', 'eight', 'ninth', 'tenth', 'eleventh', 'Twelfth'].eachWithIndex{ day, dayIndex ->
    println "On the $day day of Christmas"
    println 'My true love gave to me:'
    (dayIndex..0).each { p ->
        print presents[p]
        println p == 1 ? ' and' : ''
    }
    println()
}
