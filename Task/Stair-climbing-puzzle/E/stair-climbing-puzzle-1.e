var level := 41
var prob := 0.5001

def step() {
    def success := entropy.nextDouble() < prob
    level += success.pick(1, -1)
    return success
}
