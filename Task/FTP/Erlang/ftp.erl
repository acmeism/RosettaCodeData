%%%-------------------------------------------------------------------
%%% To execute in shell, Run the following commands:-
%%% >c("ftp_example").
%%% >ftp_example:run().
%%%-------------------------------------------------------------------
-module(ftp_example).

-export([run/0]).

run() ->
    Host = "ftp.easynet.fr",
    Opts = [{mode, passive}],
    User = "anonymous",
    Password = "",

    Directory = "/debian/",
    File = "README.html",

    %%% Open connection with FTP Server
    io:format("Opening connection with host ~p ~n", [Host]),
    {ok, Pid} = ftp:open(Host, Opts),

    %%% Login as Anonymous user
    io:format("Logging in as user ~p ~n", [User]),
    ftp:user(Pid, User, Password),

    %%% Change Directory to "/debian/"
    io:format("Changing Directory to  ~p ~n", [Directory]),
    ftp:cd(Pid, Directory),

    %%% Listing contents of current Directory
    io:format("Contents of Current Directory ~n"),
    {ok, Listing} = ftp:ls(Pid),
    io:format("~p ~n", [Listing]),

    %%% Download file "README.html"
    io:format("Downloading File ~p to current directory ~n", [File]),
    ftp:recv(Pid, File),

    %%% Close connection
    io:format("Closing connection to FTP Server"),
    ftp:close(Pid).
