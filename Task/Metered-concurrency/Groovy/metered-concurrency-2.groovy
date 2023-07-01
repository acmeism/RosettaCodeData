def cs = new CountingSemaphore(4)
(1..12).each { threadID ->
    Thread.start {
        def id = "Thread #${(threadID as String).padLeft(2,'0')}"
        try {
            def sCount = cs.acquire()
            println("${id} has acquired Semaphore at count = ${sCount}")
            sleep(2000)
        } finally {
            println("${id} is releasing Semaphore at count = ${cs.count}")
            cs.release()
        }
    }
}
