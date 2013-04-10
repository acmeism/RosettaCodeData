#!/usr/bin/escript
file_exists(Filename) ->
  { Flag, _ } = file:read_file_info(Filename), Flag == ok.

dir_exists(Filename) ->
  { Flag, Info } = file:read_file_info(Filename),
  (Flag == ok) andalso (element(3, Info) == directory).

print_result(Flag, Filename) ->
  Tail = if
    Flag -> "exists";
    true -> "does not exist"
  end,
  io:put_chars(lists:concat([Filename, " ", Tail, "\n"])).

check_file(Filename) -> print_result(file_exists(Filename), Filename).
check_dir(Filename) -> print_result(dir_exists(Filename), Filename).

main(_) ->
  check_file("input.txt"),
  check_dir("docs"),
  check_file("/input.txt"),
  check_dir("/docs").
