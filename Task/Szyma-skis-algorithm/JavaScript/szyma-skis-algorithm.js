const { Mutex } = require('async-mutex');


let dict_ = {}; // Use a regular object as a dictionary
let critical_value = 1;
const lock_object = new Mutex();

function flag(id_) {
    return dict_[id_] || 0; // Return 0 if the key doesn't exist (default behavior)
}

async function run_szymanski(id_, allszy) {
    const others = allszy.filter(t => t !== id_);
    dict_[id_] = 1; // Standing outside waiting room

    while (others.some(t => flag(t) >= 3)) {
        await new Promise(resolve => setTimeout(resolve, 0.001)); // Async sleep
    }
    dict_[id_] = 3; // Standing in doorway

    if (others.some(t => flag(t) === 1)) {
        dict_[id_] = 2; // Waiting for other processes to enter
        while (!others.some(t => flag(t) === 4)) {
            await new Promise(resolve => setTimeout(resolve, 0.001)); // Async sleep
        }
    }

    dict_[id_] = 4; // The door is closed

    for (const t of others) {
        if (t >= id_) {
            continue;
        }
        while (flag(t) > 1) {
            await new Promise(resolve => setTimeout(resolve, 0.001)); // Async sleep
        }
    }

    // critical section
    await lock_object.runExclusive(async () => {
        critical_value += id_ * 3;
        critical_value = Math.floor(critical_value / 2);
        console.log(`Thread ${id_} changed the critical value to ${critical_value}.`);
    });
    // end critical section

    // Exit protocol
    for (const t of others) {
        if (t <= id_) {
            continue;
        }
        while (![0, 1, 4].includes(flag(t))) {
            await new Promise(resolve => setTimeout(resolve, 0.001)); // Async sleep
        }
    }
    dict_[id_] = 0; // Leave. Reopen door if nobody is still in the waiting room
}

async function test_szymanski(n) {
    const allszy = Array.from({ length: n }, (_, i) => i + 1);
    const promises = allszy.map(i => run_szymanski(i, allszy));

    await Promise.all(promises);
}

async function main() {
    await test_szymanski(20);
}

main();
