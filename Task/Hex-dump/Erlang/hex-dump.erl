%%% ============================================================
%%% hex_dump.erl
%%%
%%% Educational example of a canonical hex dump implementation
%%% in Erlang, including a UTF-16 little-endian demonstration.
%%%
%%% Shows:
%%%   • binary slicing
%%%   • recursion over fixed-size blocks
%%%   • hex formatting
%%%   • ASCII preview column
%%%   • UTF-16 encoded sample with BOM
%%% ============================================================

-module(hex_dump).

%% Public functions exported from this module
-export([
    hexdump/1,
    hexdump/2,
    hexdump/3,
    demo/0
]).

%% Number of bytes displayed per output line
-define(BYTES_PER_LINE, 16).

%%% ============================================================
%%% Public API
%%% ============================================================

%% ------------------------------------------------------------
%% hexdump/1
%%
%% Dump the entire binary from offset 0 to the end.
%% ------------------------------------------------------------
hexdump(Bin) ->
    hexdump(Bin, 0, byte_size(Bin)).

%% ------------------------------------------------------------
%% hexdump/2
%%
%% Dump from a given byte offset to the end of the binary.
%% ------------------------------------------------------------
hexdump(Bin, Offset) ->
    hexdump(Bin, Offset, byte_size(Bin) - Offset).

%% ------------------------------------------------------------
%% hexdump/3
%%
%% Dump Length bytes starting at Offset.
%%
%% 1. Slice the requested portion of the binary
%% 2. Format it in 16-byte blocks
%% 3. Join the lines with newlines
%% ------------------------------------------------------------
hexdump(Bin, Offset, Length) ->
    Slice = binary:part(Bin, Offset, Length),
    Lines = format_blocks(Slice, Offset, 0),
    string:join(Lines, "\n").

%%% ============================================================
%%% Block formatting
%%% ============================================================

%% ------------------------------------------------------------
%% format_blocks/3
%%
%% Recursively splits the binary into 16-byte chunks and formats
%% each chunk as one canonical hex dump line.
%%
%% Base case: empty binary → no more lines
%% ------------------------------------------------------------
format_blocks(<<>>, _BaseOffset, _Index) ->
    [];

%% ------------------------------------------------------------
%% Recursive case
%% ------------------------------------------------------------
format_blocks(Bin, BaseOffset, Index) ->

    %% Determine size of the current block
    %% (16 bytes except possibly the last line)
    BlockSize = min(?BYTES_PER_LINE, byte_size(Bin)),

    %% Split into current block and remaining bytes
    <<Block:BlockSize/binary, Rest/binary>> = Bin,

    %% Compute displayed offset for this line
    LineOffset = BaseOffset + Index * ?BYTES_PER_LINE,

    %% Format one line
    Line = format_line(LineOffset, Block),

    %% Recurse on remaining bytes
    [Line | format_blocks(Rest, BaseOffset, Index + 1)].

%%% ============================================================
%%% Line formatting
%%% ============================================================

%% ------------------------------------------------------------
%% format_line/2
%%
%% Produces:
%%   00000000  ff fe 52 00 ...  |..R.|
%% ------------------------------------------------------------
format_line(Offset, Block) ->

    %% Create hex column (left side)
    Hex = hex_column(Block),

    %% Create ASCII preview column (right side)
    Ascii = ascii_column(Block),

    %% Format into a single printable string
    lists:flatten(
        io_lib:format(
            "~8.16.0b  ~s  |~s|",
            [Offset, Hex, Ascii]
        )
    ).

%%% ============================================================
%%% Hex column generation
%%% ============================================================

%% ------------------------------------------------------------
%% hex_column/1
%%
%% Converts a binary block into:
%%   "ff fe 52 00 6f 00 ..."
%% ------------------------------------------------------------
hex_column(Block) ->

    %% Convert binary to list of byte integers
    Bytes = binary_to_list(Block),

    %% Convert each byte to two-digit hex
    HexBytes = [byte_hex(B) || B <- Bytes],

    %% Pad with blanks so short lines align nicely
    Padded = pad_hex(HexBytes, ?BYTES_PER_LINE),

    %% Insert extra space between byte groups
    format_hex_groups(Padded).

%% ------------------------------------------------------------
%% byte_hex/1
%%
%% Converts a single byte into "00".."ff"
%% ------------------------------------------------------------
byte_hex(B) ->
    lists:flatten(io_lib:format("~2.16.0b", [B])).

%% ------------------------------------------------------------
%% pad_hex/2
%%
%% Ensures each line has 16 hex positions
%% (adds blank entries for short final lines)
%% ------------------------------------------------------------
pad_hex(List, N) when length(List) >= N ->
    List;

pad_hex(List, N) ->
    pad_hex(List ++ ["  "], N).

%% ------------------------------------------------------------
%% format_hex_groups/1
%%
%% Splits into two groups of 8 bytes for readability
%% ------------------------------------------------------------
format_hex_groups(Bytes) ->
    {Left, Right} = lists:split(8, Bytes),

    string:join(Left, " ")
    ++ "  "
    ++ string:join(Right, " ").

%%% ============================================================
%%% ASCII preview column
%%% ============================================================

%% ------------------------------------------------------------
%% ascii_column/1
%%
%% Printable bytes show as characters.
%% Everything else becomes '.'.
%% ------------------------------------------------------------
ascii_column(Block) ->
    Bytes = binary_to_list(Block),
    [printable(B) || B <- Bytes].

%% ------------------------------------------------------------
%% printable/1
%%
%% ASCII range 32–126 are visible characters.
%% Others replaced with dot.
%% ------------------------------------------------------------
printable(B) when B >= 32, B =< 126 ->
    B;

printable(_) ->
    $. .

%%% ============================================================
%%% Demonstration with UTF-16 little-endian
%%% ============================================================

demo() ->

    %% UTF-16LE Byte Order Mark = FF FE
    %% Erlang automatically encodes the string into UTF-16LE
    %% including surrogate pairs for the emoji.
    Sample =
        <<16#FF,16#FE,
          "Rosetta Code is a programming chrestomathy site 😀."
            /utf16-little>>,

    io:format("FULL UTF-16LE DUMP:~n~s~n~n",
              [hexdump(Sample)]),

    io:format("OFFSET 8, LENGTH 48:~n~s~n",
              [hexdump(Sample, 8, 48)]).


