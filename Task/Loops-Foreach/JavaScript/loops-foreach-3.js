console.log(
  "alpha beta gamma delta".split(' ').reduce(
    function (a, x, i, lst) {
      return lst.length - i + '. ' + x + '\n' + a;
    }, ''
  )
)
