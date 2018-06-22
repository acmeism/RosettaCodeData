-module(sierpinski).
-author("zduchac").
-export([start/0]).

sierpinski(DC, Order) ->
    Size = 1 bsl Order,
    sierpinski(DC, Order, Size, 0, 0).

sierpinski(_, _, Size, _, Y) when Y =:= Size ->
    ok;
sierpinski(DC, Order, Size, X, Y) when X =:= Size ->
    sierpinski(DC, Order, Size, 0, Y + 1);
sierpinski(DC, Order, Size, X, Y) when X band Y =:= 0 ->
    wxDC:drawPoint(DC, {X, Y}),
    sierpinski(DC, Order, Size, X + 1, Y);
sierpinski(DC, Order, Size, X, Y) ->
    sierpinski(DC, Order, Size, X + 1, Y).

start() ->
    Wx = wx:new(),
    Frame = wxFrame:new(Wx, -1, "Raytracer", []),
    wxFrame:connect(Frame, paint, [{callback,
				    fun(_Evt, _Obj) ->
					    DC = wxPaintDC:new(Frame),
					    sierpinski(DC, 8),
					    wxPaintDC:destroy(DC)
				    end
				   }]),
    wxFrame:show(Frame).
