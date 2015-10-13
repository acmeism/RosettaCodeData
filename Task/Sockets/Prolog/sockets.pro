start(Port) :- socket('AF_INET',Socket),
               socket_connect(Socket, 'AF_INET'(localhost,Port), Input, Output),
               write(Output, 'hello socket world'),
               flush_output(Output),
               close(Output),
               close(Input).
