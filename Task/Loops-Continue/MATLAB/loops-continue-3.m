for i = 1:10
  printf(' %2d',  i);
  if ( mod(i, 5) == 0 )
    printf('\n');
    continue
  end
end
