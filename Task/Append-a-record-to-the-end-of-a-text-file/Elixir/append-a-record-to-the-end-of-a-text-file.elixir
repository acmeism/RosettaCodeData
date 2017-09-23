defmodule Gecos do
  defstruct [:fullname, :office, :extension, :homephone, :email]

  defimpl String.Chars do
    def to_string(gecos) do
      [:fullname, :office, :extension, :homephone, :email]
      |> Enum.map_join(",", &Map.get(gecos, &1))
    end
  end
end

defmodule Passwd do
  defstruct [:account, :password, :uid, :gid, :gecos, :directory, :shell]

  defimpl String.Chars do
    def to_string(passwd) do
      [:account, :password, :uid, :gid, :gecos, :directory, :shell]
      |> Enum.map_join(":", &Map.get(passwd, &1))
    end
  end
end

defmodule Appender do
  def write(filename) do
    jsmith = %Passwd{
      account: "jsmith",
      password: "x",
      uid: 1001,
      gid: 1000,
      gecos: %Gecos{
        fullname: "Joe Smith",
        office: "Room 1007",
        extension: "(234)555-8917",
        homephone: "(234)555-0077",
        email: "jsmith@rosettacode.org"
      },
      directory: "/home/jsmith",
      shell: "/bin/bash"
    }

    jdoe = %Passwd{
      account: "jdoe",
      password: "x",
      uid: 1002,
      gid: 1000,
      gecos: %Gecos{
        fullname: "Jane Doe",
        office: "Room 1004",
        extension: "(234)555-8914",
        homephone: "(234)555-0044",
        email: "jdoe@rosettacode.org"
      },
      directory: "/home/jdoe",
      shell: "/bin/bash"
    }

    xyz = %Passwd{
      account: "xyz",
      password: "x",
      uid: 1003,
      gid: 1000,
      gecos: %Gecos{
        fullname: "X Yz",
        office: "Room 1003",
        extension: "(234)555-8913",
        homephone: "(234)555-0033",
        email: "xyz@rosettacode.org"
      },
      directory: "/home/xyz",
      shell: "/bin/bash"
    }

    File.open!(filename, [:write], fn file ->
      IO.puts(file, jsmith)
      IO.puts(file, jdoe)
    end)

    File.open!(filename, [:append], fn file ->
      IO.puts(file, xyz)
    end)

    IO.puts File.read!(filename)
  end
end

Appender.write("passwd.txt")
