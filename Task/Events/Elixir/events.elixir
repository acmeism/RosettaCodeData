defmodule Events do
  def log(msg) do
    time = Time.utc_now |> to_string |> String.slice(0..7)
    IO.puts "#{time} => #{msg}"
  end

  def task do
    log("Task start")
    receive do
      :go -> :ok
    end
    log("Task resumed")
  end

  def main do
    log("Program start")
    {pid,ref} = spawn_monitor(__MODULE__,:task,[])
    log("Program sleeping")
    Process.sleep(1000)
    log("Program signalling event")
    send(pid, :go)
    receive do
      {:DOWN,^ref,_,_,_} -> :task_is_down
    end
  end
end

Events.main
