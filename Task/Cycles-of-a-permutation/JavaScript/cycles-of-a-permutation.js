class Permutation {
  constructor(lettersSize) {
    this.lettersCount = lettersSize;
  }

  createOneLine(source, destination) {
    let result = [];
    for (const ch of destination) {
      result.push(source.indexOf(ch) + 1);
    }

    while (result[result.length - 1] === result.length) {
      result.pop();
    }

    return result;
  }

  oneLineToCycles(oneLine) {
    let cycles = [];
    let used = new Set();

    for (let number = 1; used.size < oneLine.length; number++) {
      if (!used.has(number)) {
        let index = this.indexOf(oneLine, number) + 1;
        if (index > 0) {
          let cycle = [number];

          while (number !== index) {
            cycle.push(index);
            index = this.indexOf(oneLine, index) + 1;
          }

          if (cycle.length > 1) {
            cycles.push(cycle);
          }

          cycle.forEach(n => used.add(n));
        }
      }
    }

    return cycles;
  }

  cyclesToOneLine(cycles) {
    let oneLine = Array.from({ length: this.lettersCount }, (_, i) => i + 1);

    for (let number = 1; number <= this.lettersCount; number++) {
      for (const cycle of cycles) {
        const index = this.indexOf(cycle, number);
        if (index >= 0) {
          oneLine[number - 1] = cycle[(cycle.length + index - 1) % cycle.length];
          break;
        }
      }
    }

    return oneLine;
  }

  cyclesInverse(cycles) {
    let cyclesInverse = JSON.parse(JSON.stringify(cycles)); // Deep copy

    for (let cycle of cyclesInverse) {
      cycle.push(cycle[0]);
      cycle.shift();
      cycle.reverse();
    }

    return cyclesInverse;
  }

  oneLineInverse(oneLine) {
    let oneLineInverse = Array(oneLine.length).fill(0);

    for (let number = 1; number <= oneLine.length; number++) {
      oneLineInverse[number - 1] = this.indexOf(oneLine, number) + 1;
    }

    return oneLineInverse;
  }

  combinedCycles(cyclesOne, cyclesTwo) {
    let combinedCycles = [];
    let used = new Set();

    for (let number = 1; used.size < this.lettersCount; number++) {
      if (!used.has(number)) {
        let combined = this.next(cyclesTwo, this.next(cyclesOne, number));
        let cycle = [number];

        while (number !== combined) {
          cycle.push(combined);
          combined = this.next(cyclesTwo, this.next(cyclesOne, combined));
        }

        if (cycle.length > 1) {
          combinedCycles.push(cycle);
        }

        cycle.forEach(n => used.add(n));
      }
    }

    return combinedCycles;
  }

  oneLinePermuteString(text, oneLine) {
    let permuted = "";

    for (const index of oneLine) {
      permuted += text[index - 1];
    }

    permuted += text.substring(permuted.length);

    return permuted;
  }

  cyclesPermuteString(text, cycles) {
    let permuted = text.split('');

    for (const cycle of cycles) {
      for (const number of cycle) {
        permuted[this.next(cycles, number) - 1] = text[number - 1];
      }
    }

    return permuted.join('');
  }

  signature(oneLine) {
    let cycles = this.oneLineToCycles(oneLine);
    let evenCount = 0;

    for (const cycle of cycles) {
      if (cycle.length % 2 === 0) {
        evenCount++;
      }
    }

    return (evenCount % 2 === 0) ? "+1" : "-1";
  }

  order(oneLine) {
    let cycles = this.oneLineToCycles(oneLine);

    let lcm = 1;
    for (const cycle of cycles) {
      const size = cycle.length;
      lcm = (lcm * size) / this.gcd(size, lcm);
    }

    return lcm;
  }

  // Helper methods
  indexOf(numbers, digit) {
    const index = numbers.indexOf(digit);
    return index === -1 ? -1 : index;
  }

  next(cycles, number) {
    for (const cycle of cycles) {
      const index = cycle.indexOf(number);
      if (index !== -1) {
        return cycle[(index + 1) % cycle.length];
      }
    }
    return number;
  }

  gcd(a, b) {
    while (b) {
      [a, b] = [b, a % b];
    }
    return a;
  }
}

function toString(oneLine) {
  let result = "(";
  for (const number of oneLine) {
    result += number + " ";
  }
  return result.substring(0, result.length - 1) + ") ";
}

function cyclesString(cycles) {
  let result = "";
  for (const cycle of cycles) {
    result += toString(cycle);
  }
  return result;
}

function main() {
  const MONDAY = 0, TUESDAY = 1, WEDNESDAY = 2, THURSDAY = 3, FRIDAY = 4, SATURDAY = 5, SUNDAY = 6;

  const dayNames = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"];

  const letters = [
    "HANDYCOILSERUPT", "SPOILUNDERYACHT", "DRAINSTYLEPOUCH",
    "DITCHSYRUPALONE", "SOAPYTHIRDUNCLE", "SHINEPARTYCLOUD", "RADIOLUNCHTYPES"
  ];

  const previousDay = (today) => {
    return (dayNames.length + today - 1) % dayNames.length;
  };

  const permutation = new Permutation(letters[0].length);

  console.log("On Thursdays Alf and Betty should rearrange their letters using these cycles:");
  const oneLineWedThu = permutation.createOneLine(letters[WEDNESDAY], letters[THURSDAY]);
  const cyclesWedThu = permutation.oneLineToCycles(oneLineWedThu);
  console.log(cyclesString(cyclesWedThu));
  console.log(`So that ${letters[WEDNESDAY]} becomes ${letters[THURSDAY]}`);

  console.log("\nOr they could use the one line notation:");
  console.log(toString(oneLineWedThu));

  console.log("\nTo revert to the Wednesday arrangement they should use these cycles:");
  const cyclesThuWed = permutation.cyclesInverse(cyclesWedThu);
  console.log(cyclesString(cyclesThuWed));

  console.log("\nOr with the one line notation:");
  const oneLineThuWed = permutation.oneLineInverse(oneLineWedThu);
  console.log(toString(oneLineThuWed));
  console.log(`So that ${letters[THURSDAY]} becomes ${permutation.oneLinePermuteString(letters[THURSDAY], oneLineThuWed)}`);

  console.log("\nStarting with the Sunday arrangement and applying each of the daily");
  console.log("arrangements consecutively, the arrangements will be:");
  console.log(`\n      ${letters[SUNDAY]}\n`);

  for (let today = 0; today < dayNames.length; today++) {
    const dayOneLine = permutation.createOneLine(letters[previousDay(today)], letters[today]);
    console.log(`${dayNames[today].padStart(11)}: ${permutation.oneLinePermuteString(letters[previousDay(today)], dayOneLine)}`);
    if (dayNames[today] === "SATURDAY") {
      console.log("");
    }
  }

  console.log("\nTo go from Wednesday to Friday in a single step they should use these cycles:");
  const oneLineThuFri = permutation.createOneLine(letters[THURSDAY], letters[FRIDAY]);
  const cyclesThuFri = permutation.oneLineToCycles(oneLineThuFri);
  const cyclesWedFri = permutation.combinedCycles(cyclesWedThu, cyclesThuFri);
  console.log(cyclesString(cyclesWedFri));
  console.log(`So that ${letters[WEDNESDAY]} becomes ${permutation.cyclesPermuteString(letters[WEDNESDAY], cyclesWedFri)}`);

  console.log("\nThese are the signatures of the permutations:\n");
  for (let today = 0; today < dayNames.length; today++) {
    const oneLine = permutation.createOneLine(letters[previousDay(today)], letters[today]);
    console.log(`${dayNames[today].padStart(11)}: ${permutation.signature(oneLine)}`);
  }

  console.log("\nThese are the orders of the permutations:\n");
  for (let today = 0; today < dayNames.length; today++) {
    const oneLine = permutation.createOneLine(letters[previousDay(today)], letters[today]);
    console.log(`${dayNames[today].padStart(11)}: ${permutation.order(oneLine)}`);
  }

  console.log("\nApplying the Friday cycle to a string 10 times:");
  let previous = "STOREDAILYPUNCH";
  console.log(`\n 0 ${previous}\n`);

  for (let i = 1; i <= 10; i++) {
    previous = permutation.cyclesPermuteString(previous, cyclesThuFri);
    console.log(`${i.toString().padStart(2)} ${previous}`);
    if (i === 9) {
      console.log("");
    }
  }
}

main();
