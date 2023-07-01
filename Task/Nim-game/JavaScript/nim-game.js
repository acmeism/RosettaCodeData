class Nim {
	constructor(tokens, printFun) {
		this.startTokens = tokens;
		this.tokens = tokens;
		this.printFun = printFun;
	}

	playerTurn(take) {
		take = Math.round(take);

		if (take < 1 || take > 3) {
			this.printFun("take must be between 1 and 3.\n")
			return false;
		}
		this.tokens -= take;
		this.printFun("Player takes " + take + " tokens.");
		this.printRemaining()

		if (this.tokens === 0) {
			this.printFun("Player wins!\n");
		}
		return true;
	}

	computerTurn() {
		let take = this.tokens % 4;
		this.tokens -= take;
		this.printFun("Computer takes " + take + " tokens.");
		this.printRemaining();

		if (this.tokens === 0) {
			this.printFun("Computer wins.\n");
		}

	}

	printRemaining() {
		this.printFun(this.tokens + " tokens remaining.\n");
	}
}


let game = new Nim(12, console.log);
while (true) {
	if (game.playerTurn(parseInt(prompt("How many tokens would you like to take?")))){
		game.computerTurn();
	}
	if (game.tokens == 0) {
		break;
	}
}
