defmodule MeanAngle do
  def mean_angle(angles) do
    rad_angles = Enum.map(angles, &deg_to_rad/1)
    sines = rad_angles |> Enum.map(&:math.sin/1) |> Enum.sum
    cosines = rad_angles |> Enum.map(&:math.cos/1) |> Enum.sum

    rad_to_deg(:math.atan2(sines, cosines))
  end

  defp deg_to_rad(a) do
    (:math.pi/180) * a
  end

  defp rad_to_deg(a) do
    (180/:math.pi) * a
  end
end

IO.inspect MeanAngle.mean_angle([10, 350])
IO.inspect MeanAngle.mean_angle([90, 180, 270, 360])
IO.inspect MeanAngle.mean_angle([10, 20, 30])
