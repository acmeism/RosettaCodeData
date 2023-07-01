def log = ''
(1..40).each {Integer value -> log +=(value %3 == 0) ? (value %5 == 0)? 'FIZZBUZZ\n':(value %7 == 0)? 'FIZZBAXX\n':'FIZZ\n'
                                    :(value %5 == 0) ? (value %7 == 0)? 'BUZBAXX\n':'BUZZ\n'
                                    :(value %7 == 0) ?'BAXX\n'
                                    :(value+'\n')}
println log
