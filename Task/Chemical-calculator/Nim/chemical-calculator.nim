#? replace(sub = "\t", by = "  ")

import tables, strutils, sequtils, math

let ATOMIC_MASS = {"H":1.008, "C":12.011, "O":15.999, "Na":22.98976928, "S":32.06, "Uue":315.0}.toTable

proc pass1(s:string): seq[string] = # "H2O" => @["H","*","2","+","O"]
	result.add "0"
	var i = 0
	proc member(a:char,c:char): bool = i < s.len and a <= s[i] and s[i] <= c
	proc next(): char =
		i += 1
		s[i-1]
	while i < s.len:
		if s[i] == '(':	
			result = result.concat @["+","("]
			discard next()
		elif s[i] == ')': result.add $next()
		elif member('0','9'):
			var number = ""
			result.add "*"
			while member('0','9'): number &= $next()
			result.add number
		elif member('A','Z'):
			if i>0 and s[i-1] != '(': result.add "+"
			var name = ""
			name.add next()
			while member('a','z'): name.add next()
			result.add name

proc pass2(s:string): seq[string] = # "H2O" => @["H", "2", "*", "O", "+"]
	let ops = "+*"
	var tokens = pass1 s
	var stack: seq[string]
	var op: string

	for token in tokens:
		case token
		of "(": stack.add token
		of ")":
			while stack.len > 0:
				op = stack.pop()
				if op == "(": break
				result.add op
		else:
			if token in ops:
				while stack.len > 0:
					op = stack[^1]
					if not (op in ops): break
					if ops.find(token) >= ops.find(op): break
					discard stack.pop()
					result.add op
				stack.add token
			else: result.add token

	while stack.len > 0: result.add stack.pop()

proc pass3(s:string): Table[string,int] = # "H2O" => { H:2, O:1 }
	let rpn: seq[string] = pass2 s
	var stack: seq[Table[string,int]] = @[]
	for item in rpn:
		if item == "+":
			let h1:Table[string,int] = stack.pop()
			let h2:Table[string,int] = stack.pop()
			var res: Table[string,int] = initTable[string,int]()
			for key in h1.keys:
				if key != "factor":
					res[key] = h1[key]
			for key in h2.keys:
				if key != "factor":
					if h1.haskey key:
						res[key] = h1[key] + h2[key]
					else:
						res[key] = h2[key]
			stack.add res
		elif item == "*":
			let top: Table[string,int] = stack.pop() #
			let hash: Table[string,int] = stack.pop()
			let factor: int = top["factor"]
			var res: Table[string,int] = initTable[string,int]()
			for key in hash.keys:
				let str : string = key
				let value: int = hash[key]
				res[key] = value * factor
			stack.add res
		elif ATOMIC_MASS.haskey(item):
			let res : Table[string,int] = {item: 1}.toTable
			stack.add res
		else: # number
			let factor : int = parseInt item
			let res : Table[string,int] = {"factor": factor}.toTable
			stack.add res
	return stack.pop()

proc pass4(s: string) : float = # "H2O" => 18.015
	let atoms: Table[string,int] = pass3 s
	for key in atoms.keys:
		let count : int = atoms[key]
		result += float(count) * ATOMIC_MASS[key]
	round result,3

let molar_mass = pass4

assert 18.015 == molar_mass "H2O"
assert 34.014 == molar_mass "H2O2"
assert 34.014 == molar_mass "(HO)2"
assert 142.036 == molar_mass "Na2SO4"
assert 84.162 == molar_mass "C6H12"
assert 186.295 == molar_mass "COOH(C(CH3)2)3CH3"
assert 176.124 == molar_mass "C6H4O2(OH)4" # Vitamin C
assert 386.664 == molar_mass "C27H46O" # Cholesterol
assert 315 == molar_mass "Uue"
