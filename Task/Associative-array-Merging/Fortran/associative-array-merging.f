module assoc_array_mod
  implicit none
  private
  public :: KeyValue, merge_assoc_arrays

  ! Derived type for key-value pairs
  type :: KeyValue
    character(len=:), allocatable :: key
    character(len=:), allocatable :: value
  end type KeyValue

contains

  ! Function to merge two associative arrays
  function merge_assoc_arrays(base, update) result(merged)
    type(KeyValue), intent(in) :: base(:), update(:)
    type(KeyValue), allocatable :: merged(:)
    type(KeyValue), allocatable :: temp(:)
    integer :: base_size, update_size, i, j, k, merged_size
    logical :: key_exists

    base_size = size(base)
    update_size = size(update)

    ! Allocate temporary array to hold all possible keys (worst case: no overlap)
    allocate(temp(base_size + update_size))
    merged_size = 0

    ! Add all keys from update array (update takes precedence)
    do i = 1, update_size
      merged_size = merged_size + 1
      temp(merged_size)%key = update(i)%key
      temp(merged_size)%value = update(i)%value
    end do

    ! Add keys from base array that are not in update
    do i = 1, base_size
      key_exists = .false.
      do j = 1, update_size
        if (base(i)%key == update(j)%key) then
          key_exists = .true.
          exit
        end if
      end do
      if (.not. key_exists) then
        merged_size = merged_size + 1
        temp(merged_size)%key = base(i)%key
        temp(merged_size)%value = base(i)%value
      end if
    end do

    ! Allocate merged array with exact size
    allocate(merged(merged_size))
    do i = 1, merged_size
      merged(i)%key = temp(i)%key
      merged(i)%value = temp(i)%value
    end do

    ! Clean up temporary array
    deallocate(temp)
  end function merge_assoc_arrays

end module assoc_array_mod

program main
  use assoc_array_mod
  implicit none
  type(KeyValue), allocatable :: base(:), update(:), merged(:)
  integer :: i

  ! Initialize base associative array
  allocate(base(3))
  base(1) = KeyValue("name", "Rocket Skates")
  base(2) = KeyValue("price", "12.75")
  base(3) = KeyValue("color", "yellow")

  ! Initialize update associative array
  allocate(update(3))
  update(1) = KeyValue("price", "15.25")
  update(2) = KeyValue("color", "red")
  update(3) = KeyValue("year", "1974")

  ! Merge the arrays
  merged = merge_assoc_arrays(base, update)

  ! Print the merged array
  print *, "Merged associative array:"
  do i = 1, size(merged)
    print *, "Key: ", merged(i)%key, ", Value: ", merged(i)%value
  end do

  ! Clean up
  deallocate(base, update, merged)
end program main
