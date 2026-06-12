#!/usr/bin/env -S deno run -RN
// @ts-check

/**
 * @typedef MarkovParams
 * @property {string} input The input string to generate Markov chains from
 * @property {number} contextSize The number of tokens to use as context
 * @property {string} delimiter The delimiter between tokens
 * @property {boolean} [wrap=true] Copies the first `contextSize` tokens and appends them after EoF, which enables
 * 	Markov chains of unlimited length without terminating, even if there is no other rule for the tokens preceding EoF.
 * 	For example:
 * 	```js
 * 	const params = { input: 'abbbc', contextSize: 2, delimiter: '' }
 * 	new Markov({ ...params, wrap: false }).rules // { ab: ['b'], bb: ['b', 'c'] }
 * 	// No rule for `bc`, so output must terminate once `bc` is generated.
 * 	new Markov({ ...params, wrap: true }).rules // { ab: ['b'], bb: ['b', 'c'], bc: ['a'], ca: ['b'] }
 * 	// All generatable sequences of tokens now have rules, so output can continue indefinitely.
 * 	```
 */

/** A Markov chain generator */
export class Markov {
	/** @param {MarkovParams} params */
	constructor({ input, contextSize, delimiter, wrap }) {
		/** @type {Record<string, [string, ...string[]]>} */
		const rules = {}
		const tokens = input.split(delimiter)

		if (wrap ?? true) tokens.push(...tokens.slice(0, contextSize))

		for (let i = contextSize; i < tokens.length; ++i) {
			const token = tokens[i]
			const key = tokens.slice(i - contextSize, i).join(delimiter)
			if (Object.hasOwn(rules, key)) rules[key].push(token)
			else rules[key] = [token]
		}

		/** @readonly */ this.delimiter = delimiter
		/** @readonly */ this.rules = rules
	}

	/** Generates a Markov chain token-by-token. */
	*tokens() {
		const tokens = choose(Object.keys(this.rules)).split(this.delimiter)
		yield* tokens

		while (true) {
			const key = tokens.join(this.delimiter)

			// If rules doesn't have `key` prop then EoF (this can never happen if `wrap=true`)
			if (!Object.hasOwn(this.rules, key)) return

			const token = choose(this.rules[key])
			yield token

			for (let i = 0; i < tokens.length; ++i) {
				tokens[i] = tokens[i + 1] ?? token
			}
		}
	}
}

/** @template T @param {T[]} arr */
function choose(arr) {
	return arr[Math.floor(Math.random() * arr.length)]
}

/** @param {string} input */
function normalizeInput(input) {
	return input.replaceAll(/\s+/g, ' ').trim() + ' '
}

if (import.meta.main) {
	const process = await import('node:process')

	const [/* runtime */, /* script */ , filePathOrUrl, _contextSize, _numTokens, _delimiter] = process.argv

	if (filePathOrUrl == null) {
		console.error('Usage: markov <filePathOrUrl> [contextSize] [numTokens] [delimiter]')
		process.exit(1)
	}

	const contextSize = parseInt(_contextSize ?? 2)
	const numTokens = parseInt(_numTokens ?? 200)
	const delimiter = _delimiter ?? ' '

	const input = normalizeInput(await (await fetch(new URL(filePathOrUrl, import.meta.url))).text())
	const markov = new Markov({ input, contextSize, delimiter })
	const str = markov.tokens().take(numTokens).toArray().join(markov.delimiter)

	console.log(str)
}
