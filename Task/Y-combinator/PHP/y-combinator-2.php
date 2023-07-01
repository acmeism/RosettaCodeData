function Y($f) {
  return function() use($f) {
    return call_user_func_array($f(Y($f)), func_get_args());
  };
}
