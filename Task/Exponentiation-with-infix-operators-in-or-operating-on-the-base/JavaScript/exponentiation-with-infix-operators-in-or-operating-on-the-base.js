function exp_test(x, p) {
  const syntax = ["-x ** p", "-(x) ** p", "(-x) ** p", "-(x ** p)"];
  for (let i = 0; i < 4; i++) {
    console.log(`${syntax[i]}, x = ${x}, p = ${p}:`);
    try {
      console.log(eval(syntax[i]));
    } catch {
      console.log("Not syntactically valid");
    }
  }
}

const xa = [5, -5, 5, -5];
const pa = [2, 2, 3, 3];
for (let i = 0; i < 4; i++) {
  exp_test(xa[i], pa[i]);
}
