	function flipStack(stack, index) {
	    const newStack = [...stack];
	    let start = 0;
	    let end = index - 1;
	    while (start < end) {
	        const temp = newStack[start];
	        newStack[start] = newStack[end];
	        newStack[end] = temp;
	        start++;
	        end--;
	    }
	    return newStack;
	}
	function pancake(number) {

	    const initialStack = Array.from({ length: number }, (_, i) => i + 1);

	    const stackFlips = {};
	    const initialKey = initialStack.join(',');
	    stackFlips[initialKey] = 0;

	    const queue = [initialStack];
	    while (queue.length > 0) {
	        const stack = queue.shift();
	        const key = stack.join(',');

	        const flips = stackFlips[key] + 1;

	        for (let i = 2; i <= number; ++i) {
	            const flipped = flipStack(stack, i);
	            const flippedKey = flipped.join(',');

	            if (stackFlips[flippedKey] === undefined) {
	                stackFlips[flippedKey] = flips;
	                queue.push(flipped);
	            }
	        }
	    }

	    let maxFlips = -1;
	    let worstStackKey = null;
	    for (const key in stackFlips) {
	        if (stackFlips[key] > maxFlips) {
	            maxFlips = stackFlips[key];
	            worstStackKey = key;
	        }
	    }

	    return {
	        stack: worstStackKey.split(',').map(Number),
	        flips: maxFlips
	    };
	}

	for (let n = 1; n <= 8; ++n) {
	    const result = pancake(n);

	    const flipsStr = String(result.flips).padStart(2, ' ');

	    console.log(`pancake(${n}) = ${flipsStr}. Example [${result.stack.join(', ')}]`);
	}
