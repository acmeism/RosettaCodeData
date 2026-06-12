#!/usr/bin/env node
'use strict';
export default function meaningOfLife() { return 42; }

function main() {
	console.log("Main: The meaning of life is " + meaningOfLife());
}

if (import.meta.url === `file://${process.argv[1]}`) { main(); }
