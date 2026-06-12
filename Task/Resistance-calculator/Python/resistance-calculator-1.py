class Resistor :
	def __init__(self, resistance, a=None, b=None, symbol='r'):
		self.resistance = resistance
		self.a = a
		self.b = b
		self.symbol = symbol
	def res(self) : return self.resistance
	def setVoltage(self, voltage): self.voltage = voltage
	def current(self) : return self.voltage / self.res()
	def effect(self) : return self.current() * self.voltage
	def report(self,level=""):
		print(f"{self.res():8.3f} {self.voltage:8.3f} {self.current():8.3f} {self.effect():8.3f}  {level}{self.symbol}")
		if self.a: self.a.report(level + "| ")
		if self.b: self.b.report(level + "| ")

class Serial(Resistor) :
	def __init__(self, a, b) : super().__init__(0, b, a, '+')
	def res(self) : return self.a.res() + self.b.res()
	def setVoltage(self, voltage) :
		ra = self.a.res()
		rb = self.b.res()
		self.a.setVoltage(ra/(ra+rb) * voltage)
		self.b.setVoltage(rb/(ra+rb) * voltage)
		self.voltage = voltage

class Parallel(Resistor) :
	def __init__(self,a,b) : super().__init__(0, b, a, '*')
	def res(self) : return 1 / (1 / self.a.res() + 1 / self.b.res())
	def setVoltage(self, voltage) :
		self.a.setVoltage(voltage)
		self.b.setVoltage(voltage)
		self.voltage = voltage

def build(s) :
	stack = []
	for word in s.split(' '):
		if   word == "+": stack.append(Serial(stack.pop(), stack.pop()))
		elif word == "*": stack.append(Parallel(stack.pop(), stack.pop()))
		else:             stack.append(Resistor(float(word)))
	return stack.pop()

node = build("10 2 + 6 * 8 + 6 * 4 + 8 * 4 + 8 * 6 +")
print("     Ohm     Volt   Ampere     Watt  Network tree")
node.setVoltage(18.0)
node.report()
