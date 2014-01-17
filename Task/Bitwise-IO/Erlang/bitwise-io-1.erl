-module(bitwise_io).
-compile([export_all]).

%% Erlang allows for easy manipulation of bitstrings. Here I'll
%% present a function that can take a message of 8-bit ASCII
%% characters and remove the MSB, leaving the same message in 7-bits.

compress(Message) ->
    << <<X:7>> || <<X:8>> <= Message >>.

%% Here we decompress the message.

decompress(Message) ->
    << <<X:8>> || <<X:7>> <= Message >>.

%% Now a test to demonstrate that this conversion works:

test_bitstring_conversion() ->
    Message = <<"Hello, Rosetta Code!">>,
    io:format("~p: ~B~n",[Message, bit_size(Message)]),
    Compressed = compress(Message),
    io:format("~p: ~B~n",[Compressed, bit_size(Compressed)]),
    Decompressed = decompress(Compressed),
    io:format("~p: ~B~n",[Decompressed, bit_size(Decompressed)]),
    io:format("~p = ~p ? ~p~n",[Message, Decompressed,
                                Message =:= Decompressed]).

%% Now to show this on file output, we'll write the compressed version
%% to a file. Now, erlang's file:write_file expects objects that are
%% multiples of 8bits. We'll add padding to allow the writing to
%% complete, and then discard the padding when reading the file back
%% in.

test_file_io() ->
    Message = <<"Hello, Rosetta Code!">>,
    FileName = "bitwise_io.dat",
    Compressed = compress(Message),
    PaddingSize = (8 - (bit_size(Compressed) rem 8)) rem 8,
    PaddedCompressed = <<Compressed:(bit_size(Compressed))/bitstring,
                         0:PaddingSize>>,
    file:write_file(FileName,PaddedCompressed),
    {ok, ReadIn} = file:read_file(FileName),
    UnpaddedSize = bit_size(ReadIn) - 7,
    Unpadded =
        case UnpaddedSize rem 7 =:= 0 of
            true ->
                <<T:(UnpaddedSize)/bitstring,_:7>> = ReadIn,
                T;
            false ->
                << <<X:7>> || <<X:7>> <= ReadIn >>
        end,
    Decompressed = decompress(Unpadded),
    io:format("~p~n",[Decompressed]).
