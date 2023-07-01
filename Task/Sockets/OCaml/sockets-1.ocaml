open Unix

let init_socket addr port =
  let inet_addr = (gethostbyname addr).h_addr_list.(0) in
  let sockaddr = ADDR_INET (inet_addr, port) in
  let sock = socket PF_INET SOCK_STREAM 0 in
  connect sock sockaddr;
  (* convert the file descriptor into high-level channels: *)
  let outchan = out_channel_of_descr sock in
  let inchan = in_channel_of_descr sock in
  (inchan, outchan)
