define function doors ()
  let n = 100;
  let doors = make(<vector>, size: n, fill: #f);
  for (x from 0 below n)
    for (y from x below n by x + 1)
      doors[y] := ~doors[y]
    end
  end;
  format-out("open: ");
  for (x from 0 below n)
    if (doors[x])
      format-out("%d ", x + 1)
    end
  end
end function;
