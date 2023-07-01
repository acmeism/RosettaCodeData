/** Dummy task: Retrieve http://localhost/ and return the content. */
def theJob() {
    return when (def text := <http://localhost/> <- getText()) -> {
        text
    }
}

/** Repeatedly run 'action' and wait for it until five seconds have elapsed. */
def repeatForFiveSeconds(action) {
    def stopTime := timer.now() + 5000
    def loop() {
        if (timer.now() < stopTime) {
            when (action <- ()) -> {
                loop()
            }
        }
    }
    loop()
}

def whenever := <import:org.erights.e.elib.slot.whenever>

def [signal, &rate] := makeRateCounter(timer, 1000)

# Prepare to report the rate info.
whenever([&rate], fn {
    println(`Rate: ${rate*1000} requests/sec`)
}, fn {true})

# Do some stuff to be counted.
repeatForFiveSeconds(fn {
    signal()
    theJob()
})
