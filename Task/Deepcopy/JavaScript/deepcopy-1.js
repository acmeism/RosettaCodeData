var deepcopy = function(o){
  return JSON.parse(JSON.stringify(src));
};

var src = {foo:0,bar:[0,1]};
print(JSON.stringify(src));
var dst = deepcopy(src);
print(JSON.stringify(src));
