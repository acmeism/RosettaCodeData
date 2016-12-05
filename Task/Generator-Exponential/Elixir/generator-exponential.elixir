defmodule Generator do
  def filter( source_pid, remove_pid ) do
    first_remove = next( remove_pid )
    spawn( fn -> filter_loop(source_pid, remove_pid, first_remove) end )
  end

  def next( pid ) do
    send(pid, {:next, self})
    receive do
      x -> x
    end
  end

  def power( m ), do: spawn( fn -> power_loop(m, 0) end )

  def task do
    squares_pid = power( 2 )
    cubes_pid = power( 3 )
    filter_pid = filter( squares_pid, cubes_pid )
    for _x <- 1..20, do: next(filter_pid)
    for _x <- 1..10, do: next(filter_pid)
  end

  defp filter_loop( pid1, pid2, n2 ) do
    receive do
      {:next, pid} ->
        {n, new_n2} = filter_loop_next( next(pid1), n2, pid1, pid2 )
        send( pid, n )
        filter_loop( pid1, pid2, new_n2 )
    end
  end

  defp filter_loop_next( n1, n2, pid1, pid2 ) when n1 > n2, do:
       filter_loop_next( n1, next(pid2), pid1, pid2 )
  defp filter_loop_next( n, n, pid1, pid2 ), do:
       filter_loop_next( next(pid1), next(pid2), pid1, pid2 )
  defp filter_loop_next( n1, n2, _pid1, _pid2 ), do: {n1, n2}

  defp power_loop( m, n ) do
    receive do
      {:next, pid} -> send( pid, round(:math.pow(n, m) ) )
    end
    power_loop( m, n + 1 )
  end
end

IO.inspect Generator.task
