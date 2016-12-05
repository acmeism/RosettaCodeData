function arrToObj(keys, vals) {
  return keys.reduce(function(map, key, index) {
    map[key] = vals[index];
    return map;
  }, {});
}
