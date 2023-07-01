	{ Pi }
	2 * arg(cmplx(0.0, maxReal))
	{ power, yields same data type as `base`, `exponent` has to be an `integer` }
	base pow exponent
	{ `real` power, `exponent` may be an `integer` or `real` value, yet `base` and }
	{ `exponent` are automatically promoted to an approximate `real` value, result }
	{ is `complex` if `base` is `complex`, otherwise a `real` value }
	base ** exponent
