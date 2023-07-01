@Grab(group = 'org.codehaus.gpars', module = 'gpars', version = '1.2.1')
import groovyx.gpars.GParsPool

GParsPool.withPool args.size(), {
    args.eachParallel {
        sleep(it.toInteger() * 10)
        println it
    }
}
