const factorial = n => n  <= 1 ? 1 : n * factorial(n - 1);
const M = n => (n - (n % 2 !== 0)) / 2;
const gaussLegendre = (fn, a, b, n) => {
	// coefficients of the Legendre polynomial
	const coef = [...Array(M(n) + 1)].map((v, m) => v = (-1) ** m * factorial(2 * n - 2 * m) / (2 ** n * factorial(m) * factorial(n - m) * factorial(n - 2 * m)));
	// the polynomial function
	const f = x => coef.map((v, i) => v * x ** (n - 2 * i)).reduce((sum, item) => sum + item, 0);
	const terms = coef.length - (n % 2 === 0);
	// coefficients of the derivative polybomial
	const dcoef = [...Array(terms)].map((v, i) => v = n - 2 * i).map((val, i) => val * coef[i]);
	// the derivative polynomial function
	const df = x => dcoef.map((v, i) => v * x ** (n - 1 - 2 * i)).reduce((sum, item) => sum + item, 0);
	const guess = [...Array(n)].map((v, i) => Math.cos(Math.PI * (i + 1 - 1 / 4) / (n + 1 / 2)));
	// Newton Raphson
	const roots = guess.map(xo => [...Array(100)].reduce(x => x - f(x) / df(x), xo));
	const weights = roots.map(v => 2 / ((1 - v ** 2) * df(v) ** 2));
	return (b - a) / 2 * weights.map((v, i) => v * fn((b - a) * roots[i] / 2 + (a + b) / 2)).reduce((sum, item) => sum + item, 0);
}
console.log(gaussLegendre(x => Math.exp(x), -3, 3, 5));
