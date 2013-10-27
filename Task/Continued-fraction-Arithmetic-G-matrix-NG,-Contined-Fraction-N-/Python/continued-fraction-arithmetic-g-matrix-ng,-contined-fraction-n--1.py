class NG:
  def __init__(self, a1, a, b1, b):
    self.a1, self.a, self.b1, self.b = a1, a, b1, b

  def ingress(self, n):
    self.a, self.a1 = self.a1, self.a + self.a1 * n
    self.b, self.b1 = self.b1, self.b + self.b1 * n

  @property
  def needterm(self):
    return (self.b == 0 or self.b1 == 0) or not self.a//self.b == self.a1//self.b1

  @property
  def egress(self):
    n = self.a // self.b
    self.a,  self.b  = self.b,  self.a  - self.b  * n
    self.a1, self.b1 = self.b1, self.a1 - self.b1 * n
    return n

  @property
  def egress_done(self):
    if self.needterm: self.a, self.b = self.a1, self.b1
    return self.egress

  @property
  def done(self):
    return self.b == 0 and self.b1 == 0
