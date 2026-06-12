class Resistor :
	def __init__(self, resistance, a=None, b=None, symbol='r') :
		self.resistance = resistance
		self.a = a
		self.b = b
		self.symbol = symbol
	def res(self) : return self.resistance
	def setVoltage(self, voltage) : self.voltage = voltage
	def current(self) : return self.voltage / self.res()
	def effect(self) : return self.current() * self.voltage
	def report(self,level="") :
		print(f"{self.res():8.3f} {self.voltage:8.3f} {self.current():8.3f} {self.effect():8.3f}  {level}{self.symbol}")
		if self.a: self.a.report(level + "| ")
		if self.b: self.b.report(level + "| ")
	def __add__(self,other) : return Serial(self,other)
	def __mul__(self,other) : return Parallel(self,other)

class Serial(Resistor) :
	def __init__(self, a, b) : super().__init__(0, a, b, '+')
	def res(self) : return self.a.res() + self.b.res()
	def setVoltage(self, voltage) :
		ra = self.a.res()
		rb = self.b.res()
		self.a.setVoltage(ra/(ra+rb) * voltage)
		self.b.setVoltage(rb/(ra+rb) * voltage)
		self.voltage = voltage

class Parallel(Resistor) :
	def __init__(self,a,b) : super().__init__(0, a, b, '*')
	def res(self) : return 1 / (1 / self.a.res() + 1 / self.b.res())
	def setVoltage(self, voltage):
		self.a.setVoltage(voltage)
		self.b.setVoltage(voltage)
		self.voltage = voltage

[R1,R2,R3,R4,R5,R6,R7,R8,R9,R10] = [Resistor(res) for res in [6,8,4,8,4,6,8,10,6,2]]
node = ((((R8+R10) * R9 + R7) * R6 + R5) * R4 + R3) * R2 + R1
node.setVoltage(18)
print("     Ohm     Volt   Ampere     Watt  Network tree")
node.report()
