puts (1..1000).inject{ |sum, x| sum + 1.0 / x ** 2 }
