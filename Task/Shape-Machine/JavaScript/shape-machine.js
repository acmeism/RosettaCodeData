let x = Number(prompt("Enter any real number:")), iters = 0;

while (++iters) {
  let x_new = 0.86 * (x + 3);
  let delta = Math.abs(x_new - x);
  if (delta < 10 ** -15) {
    console.log(x_new);
    console.log(`${iters} iterations before convergence`);
    break;
  }
  x = x_new;
}
