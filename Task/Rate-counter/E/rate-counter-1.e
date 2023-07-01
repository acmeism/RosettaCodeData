def makeLamportSlot := <import:org.erights.e.elib.slot.makeLamportSlot>

The rate counter:

/** Returns a function to call to report the event being counted, and an
    EverReporter slot containing the current rate, as a float64 in units of
    events per millisecond. */
def makeRateCounter(timer, reportPeriod) {
    var count := 0
    var start := timer.now()
    def &rate := makeLamportSlot(nullOk[float64], null)

    def signal() {
        def time := timer.now()
        count += 1
        if (time >= start + reportPeriod) {
            rate := count / (time - start)
            start := time
            count := 0
        }
    }

    return [signal, &rate]
}
