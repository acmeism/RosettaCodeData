:- initialization chat_server(5000).

chat_server(Port) :-
      tcp_socket(Socket),
      tcp_bind(Socket, Port),
      tcp_listen(Socket, 5),
      tcp_open_socket(Socket, AcceptFd, _),
      dispatch(AcceptFd).

dispatch(AcceptFd) :-
        tcp_accept(AcceptFd, Socket, _),
        thread_create(process_client(Socket, _), _, [detached(true)]),
        dispatch(AcceptFd).

process_client(Socket, _) :-
        setup_call_cleanup(
            tcp_open_socket(Socket, Str),
            handle_connection(Str),
            close(Str)).

% a connection was made, get the username and add the streams so the
% client can be broadcast to.
handle_connection(Str) :-
      send_msg(Str, msg_welcome, []),
      repeat,
      send_msg(Str, msg_username, []),
      read_line_to_string(Str, Name),
      connect_user(Name, Str), !.

% connections are stored here
:- dynamic(connected/2).

connect_user(Name, Str) :-
      connected(Name, _),
      send_msg(Str, msg_username_taken, []),
      fail.
connect_user(Name, Str) :-
      \+ connected(Name, _),
      send_msg(Str, msg_welcome_name, Name),

      % make sure that the connection is removed when the client leaves.
      setup_call_cleanup(
          assert(connected(Name, Str)),
          (
              broadcast(Name, msg_joined, Name),
              chat_loop(Name, Str), !,
              broadcast(Name, msg_left, Name)
          ),
          retractall(connected(Name, _))
      ).

% wait for a line to be sent then broadcast to the rest of the clients
% finish this goal when the client disconnects (end of stream)
chat_loop(Name, Str) :-
      read_line_to_string(Str, S),
      dif(S, end_of_file),
      broadcast(Name, msg_by_user, [Name, S]),
      chat_loop(Name, Str).
chat_loop(_, Str) :- at_end_of_stream(Str).

% send a message to all connected clients except Name (the sender)
broadcast(Name, Msg, Params) :-
    forall(
        (connected(N, Str), dif(N, Name)),
        (send_msg(Str, Msg, Params), send_msg(Str, msg_new_line, []))
    ).

send_msg(St, MsgConst, Params) :-
      call(MsgConst, Msg),
      format(St, Msg, Params),
      flush_output(St).

% constants for the various message types that are sent
msg_welcome('Welcome to Chatalot\n\r').
msg_username('Please enter your nickname: ').
msg_welcome_name('Welcome ~p\n\r').
msg_joined(' -- "~w" has joined the chat --').
msg_left(' -- "~w" has left the chat. --').
msg_username_taken('That username is already taken, choose another\n\r').
msg_new_line('\n\r').
msg_by_user('~w> ~w').
