function func1 ()
  return func2()
end

function func2 ()
  return func1()
end

func1()
