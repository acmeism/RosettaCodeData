apply(data.frame(letters[1:3], LETTERS[1:3], 1:3), 1,
      function(row) { cat(row, "\n", sep='') })
