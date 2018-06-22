% This module provides basic operations on ppm files:
% Read from file, create ppm in memory (from generic bitmap) and save to file.
% Writing PPM files was introduced in roseta code task 'Bitmap/Write a PPM file'
% but the same code is included here to provide whole set of operations on ppm
% needed for purposes of this task.

-module(ppm).

-export([ppm/1, write/2, read/1]).

% constants for writing ppm file
-define(WHITESPACE, <<10>>).
-define(SPACE, <<32>>).

% constants for reading ppm file
-define(WHITESPACES, [9, 10, 13, 32]).
-define(PPM_HEADER, "P6").

% data structure introduced in task Bitmap (module ros_bitmap.erl)
-record(bitmap, {
    mode = rgb,
    pixels = nil,
    shape = {0, 0}
  }).

%%%%%%%%% API %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read ppm file from file
read(Filename) ->
    {ok, File} = file:read_file(Filename),
    parse(File).

% create ppm image from bitmap record
ppm(Bitmap) ->
    {Width, Height} = Bitmap#bitmap.shape,
    Pixels = ppm_pixels(Bitmap),
    Maxval = 255,  % original ppm format maximum
    list_to_binary([
      header(), width_and_height(Width, Height), maxval(Maxval), Pixels]).

% write bitmap as ppm file
write(Bitmap, Filename) ->
    Ppm = ppm(Bitmap),
    {ok, File} = file:open(Filename, [binary, write]),
    file:write(File, Ppm),
    file:close(File).

%%%%%%%%% Reading PPM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parse(Binary) ->
    {?PPM_HEADER, Data} = get_next_token(Binary),
    {Width, HeightAndRest} = get_next_token(Data),
    {Height, MaxValAndRest} = get_next_token(HeightAndRest),
    {_MaxVal, RawPixels} = get_next_token(MaxValAndRest),
    Shape = {list_to_integer(Width), list_to_integer(Height)},
    Pixels = load_pixels(RawPixels),
    #bitmap{pixels=Pixels, shape=Shape}.

% load binary as a list of RGB triplets
load_pixels(Binary) when is_binary(Binary)->
    load_pixels([], Binary).
load_pixels(Acc, <<>>) ->
    array:from_list(lists:reverse(Acc));
load_pixels(Acc, <<R, G, B, Rest/binary>>) ->
    load_pixels([<<R,G,B>>|Acc], Rest).

is_whitespace(Byte) ->
    lists:member(Byte, ?WHITESPACES).

% get next part of PPM file, skip whitespaces, and return the rest of a binary
get_next_token(Binary) ->
    get_next_token("", true, Binary).
get_next_token(CurrentToken, false, <<Byte, Rest/binary>>) ->
    case is_whitespace(Byte) of
        true ->
            {lists:reverse(CurrentToken), Rest};
        false ->
            get_next_token([Byte | CurrentToken], false, Rest)
    end;
get_next_token(CurrentToken, true, <<Byte, Rest/binary>>) ->
    case is_whitespace(Byte) of
        true ->
            get_next_token(CurrentToken, true, Rest);
        false ->
            get_next_token([Byte | CurrentToken], false, Rest)
    end.

%%%%%%%%% Writing PPM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
header() ->
    [<<"P6">>, ?WHITESPACE].

width_and_height(Width, Height) ->
    [encode_decimal(Width), ?SPACE, encode_decimal(Height), ?WHITESPACE].

maxval(Maxval) ->
   [encode_decimal(Maxval), ?WHITESPACE].

ppm_pixels(Bitmap) ->
    % 24 bit color depth
    array:to_list(Bitmap#bitmap.pixels).

encode_decimal(Number) ->
    integer_to_list(Number).
