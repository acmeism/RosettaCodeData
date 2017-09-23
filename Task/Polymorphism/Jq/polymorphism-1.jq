def Point(x;y): {"type": "Point", "x": x, "y": y};
def Point(x): Point(x;0);
def Point: Point(0);

def Circle(x;y;r): {"type": "Circle", "x": x, "y": y, "r": r};
def Circle(x;y): Circle(x;y;0);
def Circle(x): Circle(x;0);
def Circle: Circle(0);

def print:
  if  .type == "Circle" then "\(.type)(\(.x); \(.y); \(.r))"
  elif .type == "Point" then "\(.type)(\(.x); \(.y))"
  else empty
  end;
