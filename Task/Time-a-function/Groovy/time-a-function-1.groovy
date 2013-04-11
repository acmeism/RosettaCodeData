import java.lang.management.ManagementFactory
import java.lang.management.ThreadMXBean

def threadMX = ManagementFactory.threadMXBean
assert threadMX.currentThreadCpuTimeSupported
threadMX.threadCpuTimeEnabled = true

def clockCpuTime = { Closure c ->
    def start = threadMX.currentThreadCpuTime
    c.call()
    (threadMX.currentThreadCpuTime - start)/1000000
}
