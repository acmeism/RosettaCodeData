console.log(
  range(5).map(function(a) {
    return Array(a + 1).join('*');
  }).join('\n')
);
