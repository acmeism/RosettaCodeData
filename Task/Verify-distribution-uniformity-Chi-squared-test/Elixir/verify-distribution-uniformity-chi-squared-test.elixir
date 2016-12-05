defmodule Verify do
  defp gammaInc_Q(a, x) do
    a1 = a-1
    f0  = fn t -> :math.pow(t, a1) * :math.exp(-t) end
    df0 = fn t -> (a1-t) * :math.pow(t, a-2) * :math.exp(-t) end
    y = while_loop(f0, x, a1)
    n = trunc(y / 3.0e-4)
    h = y / n
    hh = 0.5 * h
    sum = Enum.reduce(n-1 .. 0, 0, fn j,sum ->
      t = h * j
      sum + f0.(t) + hh * df0.(t)
    end)
    h * sum / gamma_spounge(a, make_coef)
  end

  defp while_loop(f, x, y) do
    if f.(y)*(x-y) > 2.0e-8 and y < x, do: while_loop(f, x, y+0.3), else: min(x, y)
  end

  @a  12
  defp make_coef do
    coef0 = [:math.sqrt(2.0 * :math.pi)]
    {_, coef} = Enum.reduce(1..@a-1, {1.0, coef0}, fn k,{k1_factrl,c} ->
      h = :math.exp(@a-k) * :math.pow(@a-k, k-0.5) / k1_factrl
      {-k1_factrl*k, [h | c]}
    end)
    Enum.reverse(coef) |> List.to_tuple
  end

  defp gamma_spounge(z, coef) do
    accm = Enum.reduce(1..@a-1, elem(coef,0), fn k,res -> res + elem(coef,k) / (z+k) end)
    accm * :math.exp(-(z+@a)) * :math.pow(z+@a, z+0.5) / z
  end

  def chi2UniformDistance(dataSet) do
    expected = Enum.sum(dataSet) / length(dataSet)
    Enum.reduce(dataSet, 0, fn d,sum -> sum + (d-expected)*(d-expected) end) / expected
  end

  def chi2Probability(dof, distance) do
    1.0 - gammaInc_Q(0.5*dof, 0.5*distance)
  end

  def chi2IsUniform(dataSet, significance\\0.05) do
    dof = length(dataSet) - 1
    dist = chi2UniformDistance(dataSet)
    chi2Probability(dof, dist) > significance
  end
end

dsets = [ [ 199809, 200665, 199607, 200270, 199649 ],
          [ 522573, 244456, 139979,  71531,  21461 ] ]

Enum.each(dsets, fn ds ->
  IO.puts "Data set:#{inspect ds}"
  dof = length(ds) - 1
  IO.puts "  degrees of freedom: #{dof}"
  distance = Verify.chi2UniformDistance(ds)
  :io.fwrite "  distance:           ~.4f~n", [distance]
  :io.fwrite "  probability:        ~.4f~n", [Verify.chi2Probability(dof, distance)]
  :io.fwrite "  uniform?            ~s~n", [(if Verify.chi2IsUniform(ds), do: "Yes", else: "No")]
end)
