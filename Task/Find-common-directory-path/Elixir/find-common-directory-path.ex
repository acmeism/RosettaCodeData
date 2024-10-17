defmodule RC do
  def common_directory_path(dirs, separator \\ "/") do
    dir1 = Enum.min(dirs) |> String.split(separator)
    dir2 = Enum.max(dirs) |> String.split(separator)
    Enum.zip(dir1,dir2) |> Enum.take_while(fn {a,b} -> a==b end)
                        |> Enum.map_join(separator, fn {a,a} -> a end)
  end
end

dirs = ~w( /home/user1/tmp/coverage/test /home/user1/tmp/covert/operator /home/user1/tmp/coven/members )
IO.inspect RC.common_directory_path(dirs)
