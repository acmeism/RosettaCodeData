!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!         I n i t i a l i z a t i o n
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
doors% = 100

dim doorArray?(doors%)

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!         M a i n   L o g i c   A r e a
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// Initialize Array
for index% = 1 to doors%
  doorArray?(index%) = false
next index%

// Execute routine
toggle_doors

// Print results
for index% = 1 to doors%
  if doorArray?(index%) = true then print index%, ' is open'
next index%


stop


!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!         R o u t i n e s
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
routine toggle_doors
  for index_outer% = 1 to doors%
    for index_inner% = 1 to doors%
      if mod(index_inner%, index_outer%) = 0 then
        doorArray?(index_inner%) = not doorArray?(index_inner%)
      end if
    next index_inner%
  next index_outer%
end routine


end
