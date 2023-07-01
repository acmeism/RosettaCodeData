program perlinNoise;
//Perlin Noise
//http://rosettacode.org/mw/index.php?title=Perlin_noise#Go
uses
  sysutils;
type
  float64 = double;
const
  p{ermutation} : array[0..255] of byte = (
    151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225,
    140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148,
    247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32,
    57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175,
    74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122,
    60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54,
    65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169,
    200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64,
    52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212,
    207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213,
    119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
    129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104,
    218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241,
    81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157,
    184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93,
    222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180);
function fade(t:float64):float64;inline;
begin
  fade := ((t*6-15)*t + 10) * t*t*t;
end;

function lerp(t, a, b:float64):float64;inline;
Begin
 lerp := t*(b-a)+a;
end;

function grad(hash:integer; x, y, z: float64):float64;
Begin
    case (hash AND 15) of
      0:
        grad :=  x + y;
      1:
        grad :=  y - x;
      2:
        grad :=  x - y;
      3:
        grad :=  -x - y;
      4:
        grad :=  x + z;
      5:
        grad :=  z - x;
      6:
        grad :=  x - z;
      7:
        grad :=  -x - z;
      8:
        grad :=  y + z;
      9:
        grad :=  z - y;
      10:
        grad :=  y - z;
      11:
        grad :=  -y - z;
      12:
        grad :=  x + y;
      13:
        grad :=  z - y;
      14:
        grad :=  y - x;
      15:
      grad :=  -y - z;
  end;
end;

function noise(x, y, z: float64):float64;
var
  u,v,w : float64;
  a,b,c,A0,A1,A2,B0,B1,B2 : Integer;
Begin
    a := trunc(x) AND 255;
    b := trunc(y) AND 255;
    c := trunc(z) AND 255;
    x := frac(x);
    y := frac(y);
    z := frac(z);
    u := fade(x);
    v := fade(y);
    w := fade(z);

    A0 := p[ a] + b;
    A1 := p[A0] + c;
    A2 := p[A0+1] + c;
    B0 := p[ a+1] + b;
    B1 := p[B0] + c;
    B2 := p[B0+1] + c;

    noise:= lerp(w, lerp(v, lerp(u, grad(p[A1], x, y, z),
        grad(p[B1], x-1, y, z)),
        lerp(u, grad(p[A2], x, y-1, z),
            grad(p[B2], x-1, y-1, z))),
        lerp(v, lerp(u, grad(p[A1+1], x, y, z-1),
            grad(p[B1+1], x-1, y, z-1)),
            lerp(u, grad(p[A2+1], x, y-1, z-1),
                grad(p[B2+1], x-1, y-1, z-1))))
end;

Begin
 writeln(noise(3.14, 42, 7):20:17);
end.
