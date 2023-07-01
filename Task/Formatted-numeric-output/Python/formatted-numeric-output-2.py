from math import pi, exp
r = exp(pi)-pi
print(r)
print("e={0:e} f={0:f} g={0:g} G={0:G} s={0!s} r={0!r}!".format(r))
print("e={0:9.4e} f={0:9.4f} g={0:9.4g}!".format(-r))
print("e={0:9.4e} f={0:9.4f} g={0:9.4g}!".format(r))
print("e={0:-9.4e} f={0:-9.4f} g={0:-9.4g}!".format(r))
print("e={0:09.4e} f={0:09.4f} g={0:09.4g}!".format(-r))
print("e={0:09.4e} f={0:09.4f} g={0:09.4g}!".format(r))
print("e={0:-09.4e} f={0:-09.4f} g={0:-09.4g}!".format(r))
