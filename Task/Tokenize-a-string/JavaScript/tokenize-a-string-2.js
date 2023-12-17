const Tokeniser = (function () {
	const numberRegex = /-?(\d+\.d+|\d+\.|\.\d+|\d+)((e|E)(\+|-)?\d+)?/g;
	return {
		settings: {
			operators: ["<", ">", "=", "+", "-", "*", "/", "?", "!"],
			separators: [",", ".", ";", ":", " ", "\t", "\n"],
			groupers: ["(", ")", "[", "]", "{", "}", '"', '"', "'", "'"],
			keepWhiteSpacesAsTokens: false,
			trimTokens: true
		},
		isNumber: function (value) {
			if (typeof value === "number") {
				return true;
			} else if (typeof value === "string") {
				return numberRegex.test(value);
			}
			return false;
		},
		closeGrouper: function (grouper) {
			if (this.settings.groupers.includes(grouper)) {
				return this.settings.groupers[this.settings.groupers.indexOf(grouper) + 1];
			}
			return null;
		},
		tokenType: function (char) {
			if (this.settings.operators.includes(char)) {
				return "operator";
			} else if (this.settings.separators.includes(char)) {
				return "separator";
			} else if (this.settings.groupers.includes(char)) {
				return "grouper";
			}
			return "other";
		},
		parseString: function (str) {
			if (typeof str !== "string") {
				if (str === null) {
					return "null";
				} if (typeof str === "object") {
					str = JSON.stringify(str);
				} else {
					str = str.toString();
				}
			}
			let tokens = [], _tempToken = "";
			for (let i = 0; i < str.length; i++) {
				if (this.tokenType(_tempToken) !== this.tokenType(str[i]) || this.tokenType(str[i]) === "separator") {
					if (_tempToken.trim() !== "") {
						tokens.push(this.settings.trimTokens ? _tempToken.trim() : _tempToken);
					} else if (this.settings.keepWhiteSpacesAsTokens) {
						tokens.push(_tempToken);
					}
					_tempToken = str[i];
					if (this.tokenType(_tempToken) === "separator") {
						if (_tempToken.trim() !== "") {
							tokens.push(this.settings.trimTokens ? _tempToken.trim() : _tempToken);
						} else if (this.settings.keepWhiteSpacesAsTokens) {
							tokens.push(_tempToken);
						}
						_tempToken = "";
					}
				} else {
					_tempToken += str[i];
				}
			}
			if (_tempToken.trim() !== "") {
				tokens.push(this.settings.trimTokens ? _tempToken.trim() : _tempToken);
			} else if (this.settings.keepWhiteSpacesAsTokens) {
				tokens.push(_tempToken);
			}
			return tokens.filter((token) => token !== "");
		}
	};
})();
