console.log([...Array(1000).keys()].filter(x => /^[^1]*1[^1]*1[^1]*$/.test(x)).join(" "));
