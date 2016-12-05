define mandelbrotBailout => 16
define mandelbrotMaxIterations => 1000

define mandelbrotIterate(x, y) => {
	local(cr = #y - 0.5,
		ci = #x,
		zi = 0.0,
		zr = 0.0,
		i = 0,
		temp, zr2, zi2)

	{
		++#i;
		#temp = #zr * #zi
		#zr2 = #zr * #zr
		#zi2 = #zi * #zi
				
		#zi2 + #zr2 > mandelbrotBailout?
			return #i
		#i > mandelbrotMaxIterations?
			return 0

		#zr = #zr2 - #zi2 + #cr
		#zi = #temp + #temp + #ci
		
		currentCapture->restart
	}()
}

define mandelbrotTest() => {
	local(x, y = -39.0)
	{
		stdout('\n')
		#x = -39.0
		{
			mandelbrotIterate(#x / 40.0, #y / 40.0) == 0?
				stdout('*')
				| stdout(' ');
			++#x
			#x <= 39.0?
				currentCapture->restart
		}();
		++#y
		
		#y <= 39.0?
			currentCapture->restart
	}()
	stdout('\n')
}

mandelbrotTest
