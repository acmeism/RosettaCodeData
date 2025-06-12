const states = ["Alabama", "Alaska", "Arizona", "Arkansas",
    "California", "Colorado", "Connecticut",
    "Delaware",
    "Florida", "Georgia", "Hawaii",
    "Idaho", "Illinois", "Indiana", "Iowa",
    "Kansas", "Kentucky", "Louisiana",
    "Maine", "Maryland", "Massachusetts", "Michigan",
    "Minnesota", "Mississippi", "Missouri", "Montana",
    "Nebraska", "Nevada", "New Hampshire", "New Jersey",
    "New Mexico", "New York", "North Carolina", "North Dakota",
    "Ohio", "Oklahoma", "Oregon",
    "Pennsylvania", "Rhode Island",
    "South Carolina", "South Dakota", "Tennessee", "Texas",
    "Utah", "Vermont", "Virginia",
    "Washington", "West Virginia", "Wisconsin", "Wyoming"];

function play(states) {
    console.log(states.length, "states:");

    // get list of unique state names
    const set = new Set(states);

    // make parallel arrays for unique state names and letter histograms
    const s = Array.from(set);
    const h = Array(s.length).fill().map(() => Array(26).fill(0));

    // fill histograms
    s.forEach((state, i) => {
        for (const c of state) {
            const charCode = c.toLowerCase().charCodeAt(0) - 'a'.charCodeAt(0);
            if (charCode >= 0 && charCode < 26) {
                h[i][charCode]++;
            }
        }
    });

    // use map to find matches. map key is sum of histograms of
    // two different states. map value is indexes of the two states.
    const m = new Map();

    for (let i1 = 0; i1 < h.length; i1++) {
        const h1 = h[i1];
        for (let i2 = i1 + 1; i2 < h.length; i2++) {
            // sum histograms
            const b = Array(26).fill(0);
            for (let i = 0; i < 26; i++) {
                b[i] = h1[i] + h[i2][i];
            }

            const k = b.join(','); // make key from buffer

            // Check for existing pairs with the same histogram sum
            if (m.has(k)) {
                const pairs = m.get(k);
                // Check each pair against current pair
                for (const pair of pairs) {
                    if (i1 !== pair.i1 && i1 !== pair.i2 && i2 !== pair.i1 && i2 !== pair.i2) {
                        console.log(`${s[i1]}, ${s[i2]} = ${s[pair.i1]}, ${s[pair.i2]}`);
                    }
                }
            } else {
                m.set(k, []);
            }

            // store this pair in the map whether printed or not
            m.get(k).push({ i1, i2 });
        }
    }
}

function main() {
    play(states);
    play([...states, "New Kory", "Wen Kory", "York New", "Kory New", "New Kory"]);
}

main();
