#!/usr/bin/env node
/*jslint nodejs:true */

function main() {
	var program = __filename;
	console.log("Program: " + program);
}

if (!module.parent) { main(); }
