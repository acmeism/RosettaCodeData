functor
import
	Application
	System
define

class Multiplier
	attr 	lst
		factor
		current

	meth init(Factor Lst)
		lst	:= Lst
		factor	:= Factor
		{self next}
	end
	meth next
		local
			A
			AS
		in
			A|AS = @lst
			current := A*@factor
			lst := AS
		end
	end
	meth peek(?X)
		X = @current
	end

	meth dump
		{System.showInfo "DUMP"}
		{System.showInfo "Factor: "#@factor}
		{System.showInfo "current: "#@current}
	end
end

% a priority queue of multipliers. The one which currently holds the smallest value is put on front
class PriorityQueue
	attr	mults
			current	% for duplicate detection

	meth init(Mults)
		mults	:= Mults
		current	:= 0
	end

	meth insert(Mult)
		local
			fun {Insert M Lst}
				local
					Av
					Mv
				in
					case Lst of
						nil	then M|Lst
					[] A|AS	then 	{A peek(Av)}
										{M peek(Mv)}
										if	Av < Mv then
											A|{Insert M AS}
										else	M|A|AS
										end
					end
				end
			end
		in
			mults	:= {Insert Mult @mults}
		end
	end

	meth next(Tail NextTail)
		local
			M
			Ms
			X
			Curr
		in
			M|Ms	= @mults
			{M peek(X)}	% gets value of lowest iterator
			Curr	= @current
			if Curr == X then
				skip
			else
				Tail	= X|NextTail	% if we found a new value: append
			end
			{M next}
			mults	:= Ms
			{self insert(M)}
			if Curr == X then
				{self next(Tail NextTail)}
			else
				current := X
			end
		end
	end

end		


local

	% Sieve of erasthothenes, adapted from http://rosettacode.org/wiki/Sieve_of_Eratosthenes#Oz
	fun {Sieve N}
		 S = {Array.new 2 N true}
		 M = {Float.toInt {Sqrt {Int.toFloat N}}}
	in
		 for I in 2..M do
	if S.I then
		 for J in I*I..N;I do
				S.J := false
		 end
	end
		 end
		 S
	end

	fun {Primes N}
		 S = {Sieve N}
	in
		 for I in 2..N collect:C do
	if S.I then {C I} end
		 end
	end


	% help method to extract args
	proc {GetNK ArgList N K}
		case ArgList of
		A|B|_ then
			N={StringToInt A}
			K={StringToInt B}
		end
	end


	proc {Generate N PriorQ Tail}
	local
		NewTail
	in
		if N == 0 then
			Tail = nil
		else
			{PriorQ next(Tail NewTail)}
			{Generate (N-1) PriorQ NewTail}
		end
	end
	end

	K = 3
	PrimeFactors
	Lst
	Tail
in
	ArgList = {Application.getArgs plain}
	Lst	= 1|Tail
	PrimeFactors	= {List.take {Primes K*K} K}
	Mults	= {List.map PrimeFactors fun {$ A} {New Multiplier init(A Lst) } end}
	PriorQ	= {New PriorityQueue init(Mults)}
	{Generate 20 PriorQ Tail}
	{ForAll Lst System.showInfo}
	{Application.exit 0}
end
end
