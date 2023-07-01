PI = 3.141592653589793
TWO_PI = 6.283185307179586

def normalize2deg(a):
  while a < 0: a += 360
  while a >= 360: a -= 360
  return a
def normalize2grad(a):
  while a < 0: a += 400
  while a >= 400: a -= 400
  return a
def normalize2mil(a):
  while a < 0: a += 6400
  while a >= 6400: a -= 6400
  return a
def normalize2rad(a):
  while a < 0: a += TWO_PI
  while a >= TWO_PI: a -= TWO_PI
  return a

def deg2grad(a): return a * 10.0 / 9.0
def deg2mil(a): return a * 160.0 / 9.0
def deg2rad(a): return a * PI / 180.0

def grad2deg(a): return a * 9.0 / 10.0
def grad2mil(a): return a * 16.0
def grad2rad(a): return a * PI / 200.0

def mil2deg(a): return a * 9.0 / 160.0
def mil2grad(a): return a / 16.0
def mil2rad(a): return a * PI / 3200.0

def rad2deg(a): return a * 180.0 / PI
def rad2grad(a): return a * 200.0 / PI
def rad2mil(a): return a * 3200.0 / PI
