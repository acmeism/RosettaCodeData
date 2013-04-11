sleepTest(1000)
print '''
Hmmm. That was... less than satisfying.
How about this instead?
'''
Thread.start {
    (0..5).each {
        println it
        sleep(1000)
    }
}
sleepTest(5000)
