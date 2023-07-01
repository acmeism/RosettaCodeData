  function r = isnum(a)
    r = ~isnan(str2double(a))
  end

% tests
disp(isnum(123)) % 1
disp(isnum("123")) % 1
disp(isnum("foo123")) % 0
disp(isnum("123bar")) % 0
disp(isnum("3.1415")) % 1
