REAL sqrt 2 = sqrt(2), degrees = pi/180, width = 800-15, height = 600-15;

PROC raise exception = ([]STRING args)VOID: (
  putf(stand error, ($gx$, args, $l$));
  stop
);

STRUCT (REAL x, y, heading, BOOL pen down) turtle;

PROC turtle init = VOID: (
  draw erase (window);
  turtle := (0.5, 0.5, 0, TRUE);
  draw move (window, x OF turtle, y OF turtle);
  draw colour name(window, "white")
);

PROC turtle left = (REAL left turn)VOID:
  heading OF turtle +:= left turn;

PROC turtle right = (REAL right turn)VOID:
  heading OF turtle -:= right turn;

PROC turtle forward = (REAL distance)VOID:(
  x OF turtle +:= distance * cos(heading OF turtle) / width * height;
  y OF turtle +:= distance * sin(heading OF turtle);
  IF pen down OF turtle THEN
    draw line
  ELSE
    draw move
  FI (window, x OF turtle, y OF turtle)
);

STRUCT ( INT count, depth, current shade, upb lines, upb colours ) morph;

PROC morph init = (INT depth)VOID: (
  count OF morph := 0;
  depth OF morph := depth;
  current shade OF morph := -1;
  upb lines OF morph := 2**depth;
  upb colours OF morph := 16
);

PROC morph colour = VOID: (
  INT colour sectors = 3; # RGB #
  INT candidate shade = ENTIER ( count OF morph / upb lines OF morph * upb colours OF morph );
  IF candidate shade /= current shade OF morph THEN
    current shade OF morph := candidate shade;
    REAL colour sector = colour sectors * candidate shade / upb colours OF morph - 0.5;
    REAL shade = colour sector - ENTIER colour sector;
    CASE ENTIER colour sector + 1 # of 3 # IN
      draw colour (window, 1 - shade, shade, 0),
      draw colour (window, 0, 1 - shade, shade)
    OUT
      draw colour (window, shade, 0, 1 - shade)
    ESAC
  FI;
  count OF morph +:= 1
);

PROC dragon init = VOID: (
  pen down OF turtle := FALSE;
    turtle forward(23/64); turtle right(90*degrees);
    turtle forward (1/8);  turtle right(90*degrees);
  pen down OF turtle := TRUE
);

PROC dragon = (REAL in step, in length, PROC(REAL)VOID zig, zag)VOID: (
  IF in step <= 0 THEN
    morph colour;
    turtle forward(in length)
  ELSE
    REAL step = in step - 1;
    REAL length = in length / sqrt 2;

    zig(45*degrees);
    dragon(step, length, turtle right, turtle left);
    zag(90*degrees);
    dragon(step, length, turtle left, turtle right);
    zig(45*degrees)
  FI
);

PROC window init = VOID: (
  STRING aspect; FILE f; associate(f, aspect); putf(f, ($g(-4)"x"g(-3)$, width, height));
  IF NOT draw device (window, "X", aspect)THEN
    raise exception("cannot initialise X draw device") FI;
  IF open (window, "Dragon Curve", stand draw channel) /= 0 THEN
    raise exception("cannot open Dragon Curve window") FI
);

FILE window; window init;
  INT cycle length = 18;
  FOR snap shot TO cycle length DO
    INT depth := (snap shot - 2) MOD cycle length;
    turtle init; dragon init; morph init(depth);
# move to initial turtle location #
    dragon(depth, 7/8, turtle right, turtle left);
    draw show (window);
    VOID(system("sleep 1"))
  OD;
close (window)
