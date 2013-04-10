def e := makeEvent()

{
    when (e.wait()) -> {
        println("[2] Received event.")
    }
    println("[2] Waiting for event...")
}

{
    timer.whenPast(timer.now() + 1000, def _() {
        println("[1] Signaling event.")
        e.signal()
    })
    println("[1] Waiting 1 second...")
}
