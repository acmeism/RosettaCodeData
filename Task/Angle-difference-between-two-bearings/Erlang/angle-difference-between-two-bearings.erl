-module(bearings).

%% API
-export([angle_sub_degrees/2,test/0]).

-define(RealAngleMultiplier,16#10000000000).
-define(DegreesPerTurn,360).
-define(Precision,9).
%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
%%
angle_sub_degrees(B1,B2) when is_integer(B1), is_integer(B2) ->
    angle_sub(B2-B1,?DegreesPerTurn);
angle_sub_degrees(B1,B2) ->
    NewB1 = trunc(B1*?RealAngleMultiplier),
    NewB2 = trunc(B2*?RealAngleMultiplier),
    round(angle_sub(NewB2 - NewB1,
	      ?DegreesPerTurn*?RealAngleMultiplier)
	/?RealAngleMultiplier,?Precision).

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% delta normalises the angle difference.  Consider a turn from 350 degrees
%% to 20 degrees.  Subtraction results in 330 degress.  This is equivalent of
%% a turn in the other direction of 30 degrees, thus 330 degrees is equal
%% to -30 degrees.


angle_sub(Value,TurnSize) ->
    NormalisedValue = Value rem TurnSize,
    minimise_angle(NormalisedValue,TurnSize).

% X rem Turn result in 0..Turn for X > 0 and -Turn..0 for X < 0
% specification requires -Turn/2 < X < Turn/2.  This is achieved
% by adding or removing a turn as required.
% bsr 1 divides an integer by 2
minimise_angle(Angle,Turn) when Angle + (Turn bsr 1) < 0 ->
    Angle+Turn;
minimise_angle(Angle,Turn) when Angle - (Turn bsr 1) > 0 ->
    Angle-Turn;
minimise_angle(Angle,_) ->
    Angle.

round(Number,Precision) ->
    P = math:pow(10,Precision),
    round(Number*P)/P.

test() ->
    25 = angle_sub_degrees(20,45),
    90 = angle_sub_degrees(-45,45),
    175 = angle_sub_degrees(-85,90),
    -175 = angle_sub_degrees(-95,90),
    170 = angle_sub_degrees(-45,125),
    -170 = angle_sub_degrees(-45,145),
    -118.1184 = angle_sub_degrees( 29.4803,-88.6381),
    -139.583283124=angle_sub_degrees(-70099.742338109,29840.674378767),
    -72.343918514=angle_sub_degrees( -165313.66662974,33693.989451746),
    -161.50295231=angle_sub_degrees(  1174.8380510598,-154146.66490125),
    37.298855589=angle_sub_degrees(  60175.773067955,42213.071923544),

    passed.
