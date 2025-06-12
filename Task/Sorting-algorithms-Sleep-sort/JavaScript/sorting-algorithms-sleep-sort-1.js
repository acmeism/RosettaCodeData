Object.defineProperty(Array.prototype, "timeoutSort", {
    value(f) {
        this.forEach(n => setTimeout(() => f(n), 5 * n))
    }
})
