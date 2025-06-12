// Define enums and their string representations
const Attrib = { Color: 0, Man: 1, Drink: 2, Animal: 3, Smoke: 4 };
const Attrib_str = ["Color", "Man", "Drink", "Animal", "Smoke"];

const Colors = { Red: 0, Green: 1, White: 2, Yellow: 3, Blue: 4 };
const Colors_str = ["Red", "Green", "White", "Yellow", "Blue"];

const Mans = { English: 0, Swede: 1, Dane: 2, German: 3, Norwegian: 4 };
const Mans_str = ["English", "Swede", "Dane", "German", "Norwegian"];

const Drinks = { Tea: 0, Coffee: 1, Milk: 2, Beer: 3, Water: 4 };
const Drinks_str = ["Tea", "Coffee", "Milk", "Beer", "Water"];

const Animals = { Dog: 0, Birds: 1, Cats: 2, Horse: 3, Zebra: 4 };
const Animals_str = ["Dog", "Birds", "Cats", "Horse", "Zebra"];

const Smokes = { PallMall: 0, Dunhill: 1, Blend: 2, BlueMaster: 3, Prince: 4 };
const Smokes_str = ["PallMall", "Dunhill", "Blend", "BlueMaster", "Prince"];

function printHouses(ha) {
    const attr_names = [Colors_str, Mans_str, Drinks_str, Animals_str, Smokes_str];

    let output = "House".padEnd(10);
    for (const name of Attrib_str) {
        output += name.padEnd(10);
    }
    console.log(output);

    for (let i = 0; i < 5; i++) {
        output = String(i).padEnd(10);
        for (let j = 0; j < 5; j++) {
            output += attr_names[j][ha[i][j]].padEnd(10);
        }
        console.log(output);
    }
}

// House number specific rules
const housenos = [
    { houseno: 2, a: Attrib.Drink, v: Drinks.Milk },     // Cond 9: In the middle house they drink milk.
    { houseno: 0, a: Attrib.Man, v: Mans.Norwegian }     // Cond 10: The Norwegian lives in the first house.
];

// Attribute pair rules
const pairs = [
    { a1: Attrib.Man, v1: Mans.English, a2: Attrib.Color, v2: Colors.Red },        // Cond 2: The English man lives in the red house.
    { a1: Attrib.Man, v1: Mans.Swede, a2: Attrib.Animal, v2: Animals.Dog },        // Cond 3: The Swede has a dog.
    { a1: Attrib.Man, v1: Mans.Dane, a2: Attrib.Drink, v2: Drinks.Tea },           // Cond 4: The Dane drinks tea.
    { a1: Attrib.Color, v1: Colors.Green, a2: Attrib.Drink, v2: Drinks.Coffee },   // Cond 6: drink coffee in the green house.
    { a1: Attrib.Smoke, v1: Smokes.PallMall, a2: Attrib.Animal, v2: Animals.Birds },  // Cond 7: The man who smokes Pall Mall has birds.
    { a1: Attrib.Smoke, v1: Smokes.Dunhill, a2: Attrib.Color, v2: Colors.Yellow }, // Cond 8: In the yellow house they smoke Dunhill.
    { a1: Attrib.Smoke, v1: Smokes.BlueMaster, a2: Attrib.Drink, v2: Drinks.Beer }, // Cond 13: The man who smokes Blue Master drinks beer.
    { a1: Attrib.Man, v1: Mans.German, a2: Attrib.Smoke, v2: Smokes.Prince }       // Cond 14: The German smokes Prince
];

// Next to rules
const nexttos = [
    { a1: Attrib.Smoke, v1: Smokes.Blend, a2: Attrib.Animal, v2: Animals.Cats },   // Cond 11: The man who smokes Blend lives in the house next to the house with cats.
    { a1: Attrib.Smoke, v1: Smokes.Dunhill, a2: Attrib.Animal, v2: Animals.Horse }, // Cond 12: In a house next to the house where they have a horse, they smoke Dunhill.
    { a1: Attrib.Man, v1: Mans.Norwegian, a2: Attrib.Color, v2: Colors.Blue },     // Cond 15: The Norwegian lives next to the blue house.
    { a1: Attrib.Smoke, v1: Smokes.Blend, a2: Attrib.Drink, v2: Drinks.Water }     // Cond 16: They drink water in a house next to the house where they smoke Blend.
];

// Left of rules
const leftofs = [
    { a1: Attrib.Color, v1: Colors.Green, a2: Attrib.Color, v2: Colors.White }     // Cond 5: The green house is immediately to the left of the white house.
];

function invalid(ha) {
    // Check leftofs global rules
    for (const rule of leftofs) {
        if (ha[0][rule.a2] === rule.v2 || ha[4][rule.a1] === rule.v1) {
            return true;
        }
    }

    // Check rules for each house
    for (let i = 0; i < 5; i++) {
        // Check pair rules
        for (const rule of pairs) {
            if (ha[i][rule.a1] >= 0 && ha[i][rule.a2] >= 0 &&
                ((ha[i][rule.a1] === rule.v1 && ha[i][rule.a2] !== rule.v2) ||
                 (ha[i][rule.a1] !== rule.v1 && ha[i][rule.a2] === rule.v2))) {
                return true;
            }
        }

        // Check next to rules
        for (const rule of nexttos) {
            if (ha[i][rule.a1] === rule.v1) {
                if (i === 0 && ha[i + 1][rule.a2] >= 0 && ha[i + 1][rule.a2] !== rule.v2) {
                    return true;
                } else if (i === 4 && ha[i - 1][rule.a2] !== rule.v2) {
                    return true;
                } else if (i > 0 && i < 4 &&
                           ha[i + 1][rule.a2] >= 0 && ha[i + 1][rule.a2] !== rule.v2 &&
                           ha[i - 1][rule.a2] !== rule.v2) {
                    return true;
                }
            }
        }

        // Check left of rules for this house
        for (const rule of leftofs) {
            if (i > 0 && ha[i][rule.a1] >= 0 &&
                ((ha[i - 1][rule.a1] === rule.v1 && ha[i][rule.a2] !== rule.v2) ||
                 (ha[i - 1][rule.a1] !== rule.v1 && ha[i][rule.a2] === rule.v2))) {
                return true;
            }
        }
    }
    return false;
}

function search(used, ha, hno, attr) {
    let nexthno, nextattr;
    if (attr < 4) {
        nextattr = attr + 1;
        nexthno = hno;
    } else {
        nextattr = 0;
        nexthno = hno + 1;
    }

    if (ha[hno][attr] !== -1) {
        search(used, ha, nexthno, nextattr);
    } else {
        for (let i = 0; i < 5; i++) {
            if (used[attr][i]) continue;
            used[attr][i] = true;
            ha[hno][attr] = i;

            if (!invalid(ha)) {
                if (hno === 4 && attr === 4) {
                    printHouses(ha);
                } else {
                    search(used, ha, nexthno, nextattr);
                }
            }

            used[attr][i] = false;
            ha[hno][attr] = -1;
        }
    }
}

function main() {
    // Initialize arrays
    const used = Array(5).fill().map(() => Array(5).fill(false));
    const ha = Array(5).fill().map(() => Array(5).fill(-1));

    // Apply house number specific rules
    for (const rule of housenos) {
        ha[rule.houseno][rule.a] = rule.v;
        used[rule.a][rule.v] = true;
    }

    // Start the search
    search(used, ha, 0, 0);
}

// Run the program
main();
