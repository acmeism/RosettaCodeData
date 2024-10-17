let floodFill ~img (i, j) newColor =
  let oldColor = get_pixel ~img ~pt:(i, j) in
  let width, height = get_dims ~img in

  let rec aux (i, j) =
    if 0 <= i && i < height
    && 0 <= j && j < width
    && (get_pixel ~img ~pt:(i, j)) = oldColor
    then begin
      put_pixel img newColor i j;
      aux (i-1, j);
      aux (i+1, j);
      aux (i, j-1);
      aux (i, j+1);
    end;
  in
  aux (i, j)
