defmodule Standard_deviation do
  def add_sample( pid, n ), do: send( pid, {:add, n} )

  def create, do: spawn_link( fn -> loop( [] ) end )

  def destroy( pid ), do: send( pid, :stop )

  def get( pid ) do
    send( pid, {:get, self()} )
    receive do
      { :get, value, _pid } -> value
    end
  end

  def task do
    pid = create()
    for x <- [2,4,4,4,5,5,7,9], do: add_print( pid, x, add_sample(pid, x) )
    destroy( pid )
  end

  defp add_print( pid, n, _add ) do
    IO.puts "Standard deviation #{ get(pid) } when adding #{ n }"
  end

  defp loop( ns ) do
    receive do
      {:add, n} -> loop( [n | ns] )
      {:get, pid} ->
        send( pid, {:get, loop_calculate( ns ), self()} )
        loop( ns )
      :stop -> :ok
    end
  end

  defp loop_calculate( ns ) do
    average = loop_calculate_average( ns )
    :math.sqrt( loop_calculate_average( for x <- ns, do: :math.pow(x - average, 2) ) )
  end

  defp loop_calculate_average( ns ), do: Enum.sum( ns ) / length( ns )
end

Standard_deviation.task
