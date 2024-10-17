defmodule Mandelbrot do
  def set do
    xsize = 59
    ysize = 21
    minIm = -1.0
    maxIm = 1.0
    minRe = -2.0
    maxRe = 1.0
    stepX = (maxRe - minRe) / xsize
    stepY = (maxIm - minIm) / ysize
    Enum.each(0..ysize, fn y ->
      im = minIm + stepY * y
      Enum.map(0..xsize, fn x ->
        re = minRe + stepX * x
        62 - loop(0, re, im, re, im, re*re+im*im)
      end) |> IO.puts
    end)
  end

  defp loop(n, _, _, _, _, _) when n>=30, do: n
  defp loop(n, _, _, _, _, v) when v>4.0, do: n-1
  defp loop(n, re, im, zr, zi, _) do
    a = zr * zr
    b = zi * zi
    loop(n+1, re, im, a-b+re, 2*zr*zi+im, a+b)
  end
end

Mandelbrot.set
