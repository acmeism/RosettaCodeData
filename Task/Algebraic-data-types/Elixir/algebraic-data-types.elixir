defmodule RBtree do
  def find(nil, _), do: :not_found
  def find({ key, value, _, _, _ }, key), do: { :found, { key, value } }
  def find({ key1, _, _, left, _ }, key) when key < key1, do: find(left, key)
  def find({ key1, _, _, _, right }, key) when key > key1, do: find(right, key)

  def new(key, value), do: ins(nil, key, value) |> make_black

  def insert(tree, key, value), do: ins(tree, key, value) |> make_black

  defp ins(nil, key, value),
    do: { key, value, :r, nil, nil }
  defp ins({ key, _, color, left, right }, key, value),
    do: { key, value, color, left, right }
  defp ins({ ky, vy, cy, ly, ry }, key, value) when key < ky,
    do: balance({ ky, vy, cy, ins(ly, key, value), ry })
  defp ins({ ky, vy, cy, ly, ry }, key, value) when key > ky,
    do: balance({ ky, vy, cy, ly, ins(ry, key, value) })

  defp make_black({ key, value, _, left, right }),
    do: { key, value, :b, left, right }

  defp balance({ kx, vx, :b, lx, { ky, vy, :r, ly, { kz, vz, :r, lz, rz } } }),
    do: { ky, vy, :r, { kx, vx, :b, lx, ly }, { kz, vz, :b, lz, rz } }
  defp balance({ kx, vx, :b, lx, { ky, vy, :r, { kz, vz, :r, lz, rz }, ry } }),
    do: { kz, vz, :r, { kx, vx, :b, lx, lz }, { ky, vy, :b, rz, ry } }
  defp balance({ kx, vx, :b, { ky, vy, :r, { kz, vz, :r, lz, rz }, ry }, rx }),
    do: { ky, vy, :r, { kz, vz, :b, lz, rz }, { kx, vx, :b, ry, rx } }
  defp balance({ kx, vx, :b, { ky, vy, :r, ly, { kz, vz, :r, lz, rz } }, rx }),
    do: { kz, vz, :r, { ky, vy, :b, ly, lz }, { kx, vx, :b, rz, rx } }
  defp balance(t),
    do: t
end

RBtree.new(0,3)        |> IO.inspect
|> RBtree.insert(1,5)  |> IO.inspect
|> RBtree.insert(2,-1) |> IO.inspect
|> RBtree.insert(3,7)  |> IO.inspect
|> RBtree.insert(4,-3) |> IO.inspect
|> RBtree.insert(5,0)  |> IO.inspect
|> RBtree.insert(6,-1) |> IO.inspect
|> RBtree.insert(7,0)  |> IO.inspect
|> RBtree.find(4)      |> IO.inspect
