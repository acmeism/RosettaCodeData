import esMain from 'es-main';
import { BigFloat, set_precision as SetPrecision } from 'bigfloat-esnext';

const Iterations = 52;

export const demo = function() {
  SetPrecision(-75);
  console.log("N." + "Integral part of Nth term".padStart(45) + " ×10^ =Actual value of Nth term");
  for (let i=0; i<10; i++) {
    let line = `${i}. `;
    line += `${integral(i)} `.padStart(45);
    line += `${tenExponent(i)} `.padStart(5);
    line += nthTerm(i);
    console.log(line);
  }

  let pi = approximatePi(Iterations);
  SetPrecision(-70);
  pi = pi.dividedBy(100000).times(100000);
  console.log(`\nPi after ${Iterations} iterations: ${pi}`)
}

export const bigFactorial = n => n <= 1n ? 1n : n * bigFactorial(n-1n);

// the nth integer term
export const integral = function(i) {
  let n = BigInt(i);
  const polynomial  = 532n * n * n + 126n * n + 9n;
  const numerator   = 32n * bigFactorial(6n * n) * polynomial;
  const denominator = 3n * bigFactorial(n) ** 6n;
  return numerator / denominator;
}

// the exponent for 10 in the nth term of the series
export const tenExponent = n => 3n - 6n * (BigInt(n) + 1n);

// the nth term of the series
export const nthTerm = n =>
  new BigFloat(integral(n)).dividedBy(new BigFloat(10n ** -tenExponent(n)))

// the sum of the first n terms
export const sumThrough = function(n) {
  let sum = new BigFloat(0);
  for (let i=0; i<=n; ++i) {
    sum = sum.plus(nthTerm(i));
  }
  return sum;
}

// the approximation to pi after n terms
export const approximatePi  = n =>
   new BigFloat(1).dividedBy(sumThrough(n)).sqrt();

if (esMain(import.meta))
   demo();
