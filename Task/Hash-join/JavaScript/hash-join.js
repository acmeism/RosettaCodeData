(() => {
    'use strict';

    // hashJoin :: [Dict] -> [Dict] -> String -> [Dict]
    let hashJoin = (tblA, tblB, strJoin) => {

        let [jA, jB] = strJoin.split('='),
            M = tblB.reduce((a, x) => {
                let id = x[jB];
                return (
                    a[id] ? a[id].push(x) : a[id] = [x],
                    a
                );
            }, {});

        return tblA.reduce((a, x) => {
            let match = M[x[jA]];
            return match ? (
                a.concat(match.map(row => dictConcat(x, row)))
            ) : a;
        }, []);
    },

    // dictConcat :: Dict -> Dict -> Dict
    dictConcat = (dctA, dctB) => {
        let ok = Object.keys;
        return ok(dctB).reduce(
            (a, k) => (a['B_' + k] = dctB[k]) && a,
            ok(dctA).reduce(
                (a, k) => (a['A_' + k] = dctA[k]) && a, {}
            )
        );
    };


    // TEST
    let lstA = [
        { age: 27, name: 'Jonah' },
        { age: 18, name: 'Alan' },
        { age: 28, name: 'Glory' },
        { age: 18, name: 'Popeye' },
        { age: 28, name: 'Alan' }
    ],
    lstB = [
        { character: 'Jonah', nemesis: 'Whales' },
        { character: 'Jonah', nemesis: 'Spiders' },
        { character: 'Alan', nemesis: 'Ghosts' },
        { character:'Alan', nemesis: 'Zombies' },
        { character: 'Glory', nemesis: 'Buffy' },
        { character: 'Bob', nemesis: 'foo' }
    ];

    return hashJoin(lstA, lstB, 'name=character');

})();
