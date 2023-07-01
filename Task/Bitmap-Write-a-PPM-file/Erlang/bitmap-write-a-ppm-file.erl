-module(ppm).

-export([ppm/1, write/2]).

-define(WHITESPACE, <<10>>).
-define(SPACE, <<32>>).

% data structure introduced in task Bitmap (module ros_bitmap.erl)
-record(bitmap, {
    pixels = nil,
    shape = {0, 0}
  }).

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

%%%%%%%%%%%% four parts of ppm file %%%%%%%%%%%%%%%%%%%%%%
header() ->
    [<<"P6">>, ?WHITESPACE].

width_and_height(Width, Height) ->
    [encode_decimal(Width), ?SPACE, encode_decimal(Height), ?WHITESPACE].

maxval(Maxval) ->
   [encode_decimal(Maxval), ?WHITESPACE].

ppm_pixels(Bitmap) ->
    % 24 bit color depth
    array:to_list(Bitmap#bitmap.pixels).

%%%%%%%%%%%% Internals %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
encode_decimal(Number) ->
    integer_to_list(Number).
