program main
! Demo of Dijkstra's algorithm.
! Translation of Rosetta code Pascal version
   implicit none
!
! PARAMETER definitions
!
   integer , parameter :: nr_nodes = 6 , start_index = 0
!
! Derived Type definitions
!
   enum , bind(c)
      enumerator :: SetA , SetB , SetC
   end enum
!
   type tnode
      integer :: nodeset
      integer :: previndex ! previous node in path leading to this node
      integer :: pathlength ! total length of path to this node
   end type tnode
!
! Local variable declarations
!
   integer :: branchlength , j , j_min , k , lasttoseta , minlength , nrinseta , triallength
   character(5) :: holder
   integer , dimension(0:nr_nodes - 1 , 0:nr_nodes - 1) :: lengths
   character(132) :: lineout
   type (tnode) , dimension(0:nr_nodes - 1) :: nodes
!   character(2) , dimension(0:nr_nodes - 1) :: node_names
   character(15),dimension(0:nr_nodes-1) :: node_names
!   Correct values
!Shortest paths from node a:
!  b: length   7,  a -> b
!  c: length   9,  a -> c
!  d: length  20,  a -> c -> d
!  e: length  26,  a -> c -> d -> e
!  f: length  11,  a -> c -> f
!
   nodes%nodeset = 0
   nodes%previndex = 0
   nodes%pathlength = 0

   node_names = (/'a' , 'b' , 'c' , 'd' , 'e' , 'f'/)
!
! lengths[j,k] = length of branch j -> k, or -1 if no such branch exists.
   lengths(0 , :) = (/ - 1 , 7 , 9 , -1 , -1 , 14/)
   lengths(1 , :) = (/ - 1 , -1 , 10 , 15 , -1 , -1/)
   lengths(2 , :) = (/ - 1 , -1 , -1 , 11 , -1 , 2/)
   lengths(3 , :) = (/ - 1 , -1 , -1 , -1 , 6 , -1/)
   lengths(4 , :) = (/ - 1 , -1 , -1 , -1 , -1 , 9/)
   lengths(5 , :) = (/ - 1 , -1 , -1 , -1 , -1 , -1/)



   do j = 0 , nr_nodes - 1
      nodes(j)%nodeset = SetC
   enddo
  ! Begin by transferring the start node to set A
   nodes(start_index)%nodeset = SetA
   nodes(start_index)%pathlength = 0
   nrinseta = 1
   lasttoseta = start_index
  ! Transfer nodes to set A one at a time, until all have been transferred
   do while (nrinseta<nr_nodes)
   ! Step 1: Work through branches leading from the node that was most recently
    !        transferred to set A, and deal with end nodes in set B or set C.
    do j = 0 , nr_nodes - 1
         branchlength = lengths(lasttoseta , j)
         if (branchlength>=0) then
        ! If the end node is in set B, and the path to the end node via lastToSetA
        !   is shorter than the existing path, then update the path.
            if (nodes(j)%nodeset==SetB) then
               triallength = nodes(lasttoseta)%pathlength + branchlength
               if (triallength<nodes(j)%pathlength) then
                  nodes(j)%previndex = lasttoseta
                  nodes(j)%pathlength = triallength
               endif
        ! If the end node is in set C, transfer it to set B.
        elseif (nodes(j)%nodeset==SetC) then
               nodes(j)%nodeset = SetB
               nodes(j)%previndex = lasttoseta
               nodes(j)%pathlength = nodes(lasttoseta)%pathlength + branchlength
            endif
         endif
      enddo
! Step 2: Find the node in set B with the smallest path length,
    !         and transfer that node to set A.
    !         (Note that set B cannot be empty at this point.)
      minlength = -1
      j_min = -1
      do j = 0 , nr_nodes - 1
         if (nodes(j)%nodeset==SetB) then
            if ((j_min== - 1).or.(nodes(j)%pathlength<minlength)) then
               j_min = j
               minlength = nodes(j)%pathlength
            endif
         endif
      enddo
      nodes(j_min)%nodeset = SetA
      nrinseta = nrinseta + 1
      lasttoseta = j_min
   enddo

   print* , 'Shortest paths from node ',trim(node_names(start_index))


   do j = 0 , nr_nodes - 1
      if (j/=start_index) then
         k = j
         lineout = node_names(k)
         pete_loop: do
            k = nodes(k)%previndex
            lineout = trim(node_names(k)) // ' -> ' // trim(lineout)
            if (k==start_index) exit pete_loop
         enddo pete_loop
         write (holder , '(i0)') nodes(j)%pathlength
         lineout = trim(adjustl(node_names(j))) // ': length ' // trim(adjustl(holder)) // ', ' // trim(lineout)
         print * , lineout
      endif
   enddo
   stop
end program main
