// Test1 is visible to Test2, but not vice versa.
// The local variables A, B, and C invisible to the outside world.

procedure Test1;
var A,B,C: integer;
begin
end;

procedure Test2;
var A,B,C: integer;
begin
end;


// Test1 is visible to all code that follows it.
// Test2 is invisible to the ouside world

procedure Test1;
var A,B,C: integer;

	procedure Test2;
	var A,B,C: integer;
	begin
	end;

begin
end;


// Item1 and Test1 are only visible inside the object
// Item2 and Test2 are additional to inhered objects
// Item3 and Test3 are visible to the outside world
// Item4 is visible to the outside world and the IDE


type TMyObject = class(TObject)
 private
  Item1: integer
  procedure Test1;
 protected
  Item2: integer
  procedure Test2;
 public
  Item3: integer
  procedure Test3;
 published
  property Item4: integer read FItem4 write FItem4;
 end;
