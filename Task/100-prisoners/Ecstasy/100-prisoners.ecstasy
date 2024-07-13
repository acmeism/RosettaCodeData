module OneHundredPrisoners {
    @Inject Console console;

    void run() {
        console.print($"# of executions: {attempts}");
        console.print($"Optimal play success rate: {simulate(tryOpt)}%");
        console.print($" Random play success rate: {simulate(tryRnd)}%");
    }

    Int attempts = 10000;

    Dec simulate(function Boolean(Int[]) allFoundNumber) {
        Int[] drawers  = new Int[100](i->i);
        Int   pardoned = 0;
        for (Int i : 1..attempts) {
            if (allFoundNumber(drawers.shuffled())) {
                ++pardoned;
            }
        }
        return (pardoned * 1000000 / attempts).toDec() / 10000;
    }

    Boolean tryRnd(Int[] drawers) {
        Inmates: for (Int inmate : 0..<100) {
            Int[] choices = drawers.shuffled();
            for (Int attempt : 0..<50) {
                if (drawers[choices[attempt]] == inmate) {
                    continue Inmates;
                }
            }
            return False;
        }
        return True;
    }

    Boolean tryOpt(Int[] drawers) {
        Inmates: for (Int inmate : 0..<100) {
            Int choice = inmate;
            for (Int attempt : 0..<50) {
                if (drawers[choice] == inmate) {
                    continue Inmates;
                }
                choice = drawers[choice];
            }
            return False;
        }
        return True;
    }
}
