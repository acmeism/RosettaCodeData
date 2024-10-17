function sayHi()
	println("Hi")
end

function rep(f, n)
	for i = 1:n f() end
end

rep(sayHi, 3)
