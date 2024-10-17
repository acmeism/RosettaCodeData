defmodule ArithhGeom do
  def mean(a,g,tol) when abs(a-g) <= tol, do: a
  def mean(a,g,tol) do
    mean((a+g)/2,:math.pow(a*g, 0.5),tol)
  end
end

IO.puts ArithhGeom.mean(1,1/:math.sqrt(2),0.0000000001)
