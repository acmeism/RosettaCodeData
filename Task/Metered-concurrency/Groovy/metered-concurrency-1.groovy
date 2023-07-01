class CountingSemaphore {
    private int count = 0
    private final int max

    CountingSemaphore(int max) { this.max = max }

    synchronized int acquire() {
        while (count >= max) { wait() }
        ++count
    }

    synchronized int release() {
        if (count) { count--; notifyAll() }
        count
    }

    synchronized int getCount() { count }
}
