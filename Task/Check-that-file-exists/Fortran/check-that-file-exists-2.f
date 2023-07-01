logical :: dir_e
! a trick to be sure docs is a dir
inquire( file="./docs/.", exist=dir_e )
if ( dir_e ) then
  write(*,*), "dir exists!"
else
  ! workaround: it calls an extern program...
  call system('mkdir docs')
end if
