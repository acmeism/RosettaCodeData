var deepcopy = function(o){
  return eval(uneval(o));
};
var src = {foo:0,bar:[0,1]};
src['baz'] = src;
print(uneval(src));
var dst = deepcopy(src);
print(uneval(src));
