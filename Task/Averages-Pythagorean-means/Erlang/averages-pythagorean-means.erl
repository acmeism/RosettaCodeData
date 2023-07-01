%% Author: Abhay Jain <abhay_1303@yahoo.co.in>

-module(mean_calculator).
-export([find_mean/0]).

find_mean() ->
%% This is function calling. First argument is the the beginning number
%% and second argument is the initial value of sum for AM & HM and initial value of product for GM.
	arithmetic_mean(1, 0),
	geometric_mean(1, 1),
	harmonic_mean(1, 0).

%% Function to calculate Arithmetic Mean
arithmetic_mean(Number, Sum) when Number > 10 ->
	AM = Sum / 10,
	io:format("Arithmetic Mean ~p~n", [AM]);
arithmetic_mean(Number, Sum) ->
	NewSum = Sum + Number,
	arithmetic_mean(Number+1, NewSum).

%% Function to calculate Geometric Mean
geometric_mean(Number, Product) when Number > 10 ->
	GM = math:pow(Product, 0.1),
	io:format("Geometric Mean ~p~n", [GM]);
geometric_mean(Number, Product) ->
	NewProd = Product * Number,
	geometric_mean(Number+1, NewProd).
	
%% Function to calculate Harmonic Mean
harmonic_mean(Number, Sum) when Number > 10 ->
	HM = 10 / Sum,
	io:format("Harmonic Mean ~p~n", [HM]);
harmonic_mean(Number, Sum) ->
	NewSum = Sum + (1/Number),
	harmonic_mean(Number+1, NewSum).
