include std/console.e
include std/math.e
include std/mathcons.e
include std/sequence.e
include std/get.e

function T2D(sequence TimeSeq)
	return (360 * TimeSeq[1] / 24 + 360 * TimeSeq[2] / (24 * 60) +
			360 * TimeSeq[3] / (24 * 3600))
end function

function D2T(atom angle)
	sequence TimeSeq = {0,0,0}
	atom seconds = 24 * 60 * 60 * angle / 360
	
	TimeSeq[3] = mod(seconds,60)
	TimeSeq[2] = (mod(seconds,3600) - TimeSeq[3]) / 60
	TimeSeq[1] = seconds / 3600
	
	return TimeSeq
end function

function MeanAngle(sequence angles)
	atom x = 0, y = 0
	integer l = length(angles)
	
	for i = 1 to length(angles) do
		x += cos(angles[i] * PI / 180)
		y += sin(angles[i] * PI / 180)
	end for
	
	return atan2(y / l, x / l) * 180 / PI
end function

sequence TimeEntry, TimeList = {}, TimeSeq

puts(1,"Enter times.  Enter with no input to end\n")
while 1 do
 TimeEntry = prompt_string("")
 if equal(TimeEntry,"") then  -- no more entries
 	for i = 1 to length(TimeList) do
 		TimeList[i] = split(TimeList[i],":") -- split the times into sequences
 		for j = 1 to 3 do
 			TimeList[i][j] = defaulted_value(TimeList[i][j],0) -- convert to numerical values
 		end for
 	end for
 	exit
 end if
 TimeList = append(TimeList,TimeEntry)
end while

sequence AngleList = repeat({},length(TimeList))

for i = 1 to length(AngleList) do
	AngleList[i] = T2D(TimeList[i])
end for

sequence MeanTime = D2T(360+MeanAngle(AngleList))

printf(1,"\nMean Time: %d:%d:%d\n",MeanTime)

	
if getc(0) then end if	
