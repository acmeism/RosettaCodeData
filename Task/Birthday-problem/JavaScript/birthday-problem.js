function equalBirthdays(nSharers, groupSize, nRepetitions) {
    // Create a seeded random number generator similar to Java's
    let seed = 1;
    const rand = () => {
        seed = (seed * 9301 + 49297) % 233280;
        return seed / 233280;
    };

    let eq = 0;

    for (let i = 0; i < nRepetitions; i++) {
        const group = new Array(365).fill(0);
        for (let j = 0; j < groupSize; j++) {
            group[Math.floor(rand() * group.length)]++;
        }
        eq += group.some(c => c >= nSharers) ? 1 : 0;
    }

    return (eq * 100.0) / nRepetitions;
}

function main() {
    let groupEst = 2;

    for (let sharers = 2; sharers < 6; sharers++) {
        // Coarse.
        let groupSize = groupEst + 1;
        while (equalBirthdays(sharers, groupSize, 100) < 50.0) {
            groupSize++;
        }

        // Finer.
        const inf = Math.floor(groupSize - (groupSize - groupEst) / 4.0);
        for (let gs = inf; gs < groupSize + 999; gs++) {
            const eq = equalBirthdays(sharers, groupSize, 250);
            if (eq > 50.0) {
                groupSize = gs;
                break;
            }
        }

        // Finest.
        for (let gs = groupSize - 1; gs < groupSize + 999; gs++) {
            const eq = equalBirthdays(sharers, gs, 50000);
            if (eq > 50.0) {
                groupEst = gs;
                console.log(`${sharers} independent people in a group of ${gs} share a common birthday. (${eq.toFixed(1)})`);
                break;
            }
        }
    }
}

main();
