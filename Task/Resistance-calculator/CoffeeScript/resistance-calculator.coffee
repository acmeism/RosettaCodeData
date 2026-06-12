nd = (num) -> num.toFixed(3).padStart 8

class Resistor
	constructor : (@resistance,@a=null,@b=null,@symbol='r') ->
	res : -> @resistance
	setVoltage : (@voltage) ->
	current : -> @voltage / @res()
	effect : -> @current() * @voltage
	report : (level) ->
		print "#{nd @res()} #{nd @voltage} #{nd @current()} #{nd @effect()}  #{level}#{@symbol}"
		if @a then @a.report level + "| "
		if @b then @b.report level + "| "

class Serial extends Resistor
	constructor : (a,b) -> super 0,a,b,'+'
	res : -> @a.res() + @b.res()
	setVoltage : (@voltage) ->
		ra = @a.res()
		rb = @b.res()
		@a.setVoltage ra/(ra+rb) * @voltage
		@b.setVoltage rb/(ra+rb) * @voltage

class Parallel extends Resistor
	constructor : (a,b) -> super 0,a,b,'*'
	res : -> 1 / (1 / @a.res() + 1 / @b.res())
	setVoltage : (@voltage) ->
		@a.setVoltage @voltage
		@b.setVoltage @voltage

build = (s) ->
	stack = []
	for word in s.split ' '
		if      word == '+' then stack.push new Serial stack.pop(), stack.pop()
		else if word == '*' then stack.push new Parallel stack.pop(), stack.pop()
		else                     stack.push new Resistor parseFloat word
	stack.pop()

node = build "10 2 + 6 * 8 + 6 * 4 + 8 * 4 + 8 * 6 +"
node.setVoltage 18.0
print "     Ohm     Volt   Ampere     Watt  Network tree"
node.report ""
