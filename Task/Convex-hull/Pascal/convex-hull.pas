{$mode ISO}

program convex_hull_task (output);

{ Convex hulls, by Andrew's monotone chain algorithm.

  For a description of the algorithm, see
  https://en.wikibooks.org/w/index.php?title=Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain&stableid=40169 }

const max_points = 1000;
type points_range = 0 .. max_points - 1;

type point =
  record
    x, y : real
  end;
type point_array = array [points_range] of point;

var ciura_gaps : array [1 .. 8] of integer;

var example_points : point_array;
var hull           : point_array;
var hull_size      : integer;
var index          : integer;

function make_point (x, y : real) : point;
begin
  make_point.x := x;
  make_point.y := y;
end;

{ The cross product as a signed scalar. }
function cross (u, v : point) : real;
begin
  cross := (u.x * v.y) - (u.y * v.x)
end;

function point_subtract (u, v : point) : point;
begin
  point_subtract := make_point (u.x - v.x, u.y - v.y)
end;

function point_equal (u, v : point) : boolean;
begin
  point_equal := (u.x = v.x) and (u.y = v.y)
end;

procedure sort_points (num_points : integer;
                       var points : point_array);
{ Sort first in ascending order by x-coordinates, then in
  ascending order by y-coordinates. Any decent sort algorithm will
  suffice; for the sake of interest, here is the Shell sort of
  https://en.wikipedia.org/w/index.php?title=Shellsort&oldid=1084744510 }
var
  i, j, k, gap, offset : integer;
  temp                 : point;
  done                 : boolean;
begin
  for k := 1 to 8 do
    begin
      gap := ciura_gaps[k];
      for offset := 0 to gap - 1 do
        begin
          i := offset;
          while i <= num_points - 1 do
            begin
              temp := points[i];
              j := i;
              done := false;
              while not done do
                begin
                  if j < gap then
                    done := true
                  else if points[j - gap].x < temp.x then
                    done := true
                  else if ((points[j - gap].x = temp.x)
                             and (points[j - gap].y < temp.y)) then
                    done := true
                  else
                    begin
                      points[j] := points[j - gap];
                      j := j - gap
                    end
                end;
              points[j] := temp;
              i := i + gap
            end
        end
    end
end; { sort_points }

procedure delete_neighbor_duplicates (var n  : integer;
                                      var pt : point_array);

  procedure delete_trailing_duplicates;
  var
    i    : integer;
    done : boolean;
  begin
    i := n - 1;
    done := false;
    while not done do
      begin
        if i = 0 then
          begin
            n := 1;
            done := true
          end
        else if not point_equal (pt[i - 1], pt[i]) then
          begin
            n := i + 1;
            done := true
          end
        else
          i := i + 1
      end
  end;

  procedure delete_nontrailing_duplicates;
  var
    i, j, num_deleted : integer;
    done              : boolean;
  begin
    i := 0;
    while i < n - 1 do
      begin
        j := i + 1;
        done := false;
        while not done do
          begin
            if j = n then
              done := true
            else if not point_equal (pt[j], pt[i]) then
              done := true
            else
              j := j + 1
          end;
        if j <> i + 1 then
          begin
            num_deleted := j - i - 1;
            while j <> n do
              begin
                pt[j - num_deleted] := pt[j];
                j := j + 1
              end;
            n := n - num_deleted
          end;
        i := i + 1
      end
  end;

begin
  delete_trailing_duplicates;
  delete_nontrailing_duplicates
end; { delete_neighbor_duplicates }

procedure construct_lower_hull (n             : integer;
                                pt            : point_array;
                                var hull_size : integer;
                                var hull      : point_array);
var
  i, j : integer;
  done : boolean;
begin
  j := 1;
  hull[0] := pt[0];
  hull[1] := pt[1];
  for i := 2 to n - 1 do
    begin
      done := false;
      while not done do
        begin
          if j = 0 then
            begin
              j := j + 1;
              hull[j] := pt[i];
              done := true
            end
          else if 0.0 < cross (point_subtract (hull[j],
                                               hull[j - 1]),
                               point_subtract (pt[i],
                                               hull[j - 1])) then
            begin
              j := j + 1;
              hull[j] := pt[i];
              done := true
            end
          else
            j := j - 1
        end
    end;
  hull_size := j + 1
end; { construct_lower_hull }

procedure construct_upper_hull (n             : integer;
                                pt            : point_array;
                                var hull_size : integer;
                                var hull      : point_array);
var
  i, j : integer;
  done : boolean;
begin
  j := 1;
  hull[0] := pt[n - 1];
  hull[1] := pt[n - 2];
  for i := n - 3 downto 0 do
    begin
      done := false;
      while not done do
        begin
          if j = 0 then
            begin
              j := j + 1;
              hull[j] := pt[i];
              done := true
            end
          else if 0.0 < cross (point_subtract (hull[j],
                                               hull[j - 1]),
                               point_subtract (pt[i],
                                               hull[j - 1])) then
            begin
              j := j + 1;
              hull[j] := pt[i];
              done := true
            end
          else
            j := j - 1
        end
    end;
  hull_size := j + 1
end; { construct_upper_hull }

procedure contruct_hull (n             : integer;
                         pt            : point_array;
                         var hull_size : integer;
                         var hull      : point_array);
var
  i                                : integer;
  lower_hull_size, upper_hull_size : integer;
  lower_hull, upper_hull           : point_array;
begin
  { A side note: the calls to construct_lower_hull and
    construct_upper_hull could be done in parallel. }
  construct_lower_hull (n, pt, lower_hull_size, lower_hull);
  construct_upper_hull (n, pt, upper_hull_size, upper_hull);

  hull_size := lower_hull_size + upper_hull_size - 2;

  for i := 0 to lower_hull_size - 2 do
    hull[i] := lower_hull[i];
  for i := 0 to upper_hull_size - 2 do
    hull[lower_hull_size - 1 + i] := upper_hull[i]
end; { contruct_hull }

procedure find_convex_hull (n             : integer;
                            points        : point_array;
                            var hull_size : integer;
                            var hull      : point_array);
var
  pt    : point_array;
  numpt : integer;
  i     : integer;
begin
  for i := 0 to n - 1 do
    pt[i] := points[i];
  numpt := n;

  sort_points (numpt, pt);
  delete_neighbor_duplicates (numpt, pt);

  if numpt = 0 then
    hull_size := 0
  else if numpt <= 2 then
    begin
      hull_size := numpt;
      for i := 0 to numpt - 1 do
        hull[i] := pt[i]
    end
  else
    contruct_hull (numpt, pt, hull_size, hull)
end; { find_convex_hull }

begin
  ciura_gaps[1] := 701;
  ciura_gaps[2] := 301;
  ciura_gaps[3] := 132;
  ciura_gaps[4] := 57;
  ciura_gaps[5] := 23;
  ciura_gaps[6] := 10;
  ciura_gaps[7] := 4;
  ciura_gaps[8] := 1;

  example_points[0] := make_point (16, 3);
  example_points[1] := make_point (12, 17);
  example_points[2] := make_point (0, 6);
  example_points[3] := make_point (-4, -6);
  example_points[4] := make_point (16, 6);
  example_points[5] := make_point (16, -7);
  example_points[6] := make_point (16, -3);
  example_points[7] := make_point (17, -4);
  example_points[8] := make_point (5, 19);
  example_points[9] := make_point (19, -8);
  example_points[10] := make_point (3, 16);
  example_points[11] := make_point (12, 13);
  example_points[12] := make_point (3, -4);
  example_points[13] := make_point (17, 5);
  example_points[14] := make_point (-3, 15);
  example_points[15] := make_point (-3, -9);
  example_points[16] := make_point (0, 11);
  example_points[17] := make_point (-9, -3);
  example_points[18] := make_point (-4, -2);
  example_points[19] := make_point (12, 10);

  find_convex_hull (19, example_points, hull_size, hull);

  for index := 0 to hull_size - 1 do
    writeln (hull[index].x, ' ', hull[index].y)
end.

{--------------------------------------------------------------------}
{ The Emacs Pascal mode is intolerable.
  Until I can find a substitute: }
{ local variables:  }
{ mode: fundamental }
{ end:              }
