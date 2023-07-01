/* distributed_programming_server2.wren */

class TaxComputer {
    static tax(amount, rate) {
        if (amount < 0) Fiber.abort("Negative values not allowed.")
        return amount * rate
    }
}
