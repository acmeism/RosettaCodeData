import operator
import functools

@functools.total_ordering
class Mod:
    __slots__ = ['val','mod']

    def __init__(self, val, mod):
        if not isinstance(val, int):
            raise ValueError('Value must be integer')
        if not isinstance(mod, int) or mod<=0:
            raise ValueError('Modulo must be positive integer')
        self.val = val % mod
        self.mod = mod

    def __repr__(self):
        return 'Mod({}, {})'.format(self.val, self.mod)

    def __int__(self):
        return self.val

    def __eq__(self, other):
        if isinstance(other, Mod):
            if self.mod == other.mod:
                return self.val==other.val
            else:
                return NotImplemented
        elif isinstance(other, int):
            return self.val == other
        else:
            return NotImplemented

    def __lt__(self, other):
        if isinstance(other, Mod):
            if self.mod == other.mod:
                return self.val<other.val
            else:
                return NotImplemented
        elif isinstance(other, int):
            return self.val < other
        else:
            return NotImplemented

    def _check_operand(self, other):
        if not isinstance(other, (int, Mod)):
            raise TypeError('Only integer and Mod operands are supported')
        if isinstance(other, Mod) and self.mod != other.mod:
            raise ValueError('Inconsistent modulus: {} vs. {}'.format(self.mod, other.mod))

    def __pow__(self, other):
        self._check_operand(other)
        # We use the built-in modular exponentiation function, this way we can avoid working with huge numbers.
        return Mod(pow(self.val, int(other), self.mod), self.mod)

    def __neg__(self):
        return Mod(self.mod - self.val, self.mod)

    def __pos__(self):
        return self # The unary plus operator does nothing.

    def __abs__(self):
        return self # The value is always kept non-negative, so the abs function should do nothing.

# Helper functions to build common operands based on a template.
# They need to be implemented as functions for the closures to work properly.
def _make_op(opname):
    op_fun = getattr(operator, opname)  # Fetch the operator by name from the operator module
    def op(self, other):
        self._check_operand(other)
        return Mod(op_fun(self.val, int(other)) % self.mod, self.mod)
    return op

def _make_reflected_op(opname):
    op_fun = getattr(operator, opname)
    def op(self, other):
        self._check_operand(other)
        return Mod(op_fun(int(other), self.val) % self.mod, self.mod)
    return op

# Build the actual operator overload methods based on the template.
for opname, reflected_opname in [('__add__', '__radd__'), ('__sub__', '__rsub__'), ('__mul__', '__rmul__')]:
    setattr(Mod, opname, _make_op(opname))
    setattr(Mod, reflected_opname, _make_reflected_op(opname))

def f(x):
    return x**100+x+1

print(f(Mod(10,13)))
# Output: Mod(1, 13)
