	function inventorySequence(maxTerm) {
	    let term = 0;
	    const result = [term];
	    const inventory = { 0: 1 };
	    while (result[result.length - 1] < maxTerm) {
	        const count = inventory[term] ?? 0;
	        term = (count === 0) ? 0 : term + 1;
	        inventory[count] = (inventory[count] || 0) + 1;
	        result.push(count);
	    }
	    return result;
	}
	function main() {
	    const inventorySequenceList = inventorySequence(10_000);
	    let thousands = 1_000;
	    console.log("The first 100 numbers of the inventory sequence:");
	    for (let i = 0; i < inventorySequenceList.length; i++) {
	        const number = inventorySequenceList[i];
	        if (i < 100) {
	            // Mimics String.format("%2d", number) with padding
	            const formattedNum = number.toString().padStart(2, ' ');
	            process.stdout.write(formattedNum + (i % 20 === 19 ? "\n" : " "));
	        } else if (i === 100) {
	            console.log();
	        } else if (number >= thousands) {
	            console.log(`The first element ≥ ${thousands} is ${number} which occurs at index ${i}`);
	            thousands += 1_000;
	        }
	    }
	}
	main();
