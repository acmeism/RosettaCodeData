function timesTable(){
	let output = "";
	const size = 12;
	for(let i = 1; i <= size; i++){
		output += i.toString().padStart(3);
		output += i !== size ? " " : "\n";
	}
	for(let i = 0; i <= size; i++)
		output += i !== size ? "════" : "╕\n";

	for(let i = 1; i <= size; i++){
		for(let j = 1; j <= size; j++){
			output += j < i
				? "    "
				: (i * j).toString().padStart(3) + " ";
		}
		output += `│ ${i}\n`;
	}
	return output;
}
