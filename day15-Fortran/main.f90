program main
    use iso_fortran_env, only: int64
    implicit none

    integer :: a, b
    
    call parse(a, b)
    call part1(a, b)
    call part2(a, b)
    
contains


subroutine part2(a0, b0)
    implicit none
    
    integer, intent(in):: a0, b0
    integer :: matches
        
    matches = count_matches(a0, b0, 3, 7, 5000000)
    print *, "Number of advanced matches: ", matches
        
end subroutine part2
    
subroutine part1(a0, b0)
    implicit none
    
    integer, intent(in):: a0, b0
    integer :: matches
        
    matches = count_matches(a0, b0, 0, 0, 40000000)
    print *, "Number of simple matches: ", matches
        
end subroutine part1
    
integer function count_matches(a0, b0, a_mask, b_mask, nbr_pairs)
    implicit none
       
    integer :: a0, b0, a_mask, b_mask, nbr_pairs
    integer :: i, a, b
    
    count_matches = 0
    a = a0
    b = b0
            
    do i = 1, nbr_pairs
        call generate_pair(a, b, a_mask, b_mask)        
        if (truncate16(a) == truncate16(b)) then
            count_matches = count_matches + 1
        end if
    end do
        
end function count_matches
    
integer function truncate16(val)
    implicit none
    
    integer :: val, mask
        
    mask = 65535
    
    truncate16 = iand(val, mask)
        
end function truncate16
    
subroutine generate_pair(a, b, a_mask, b_mask)
    implicit none
     
    integer, intent(out) :: a, b
    integer, intent(in) :: a_mask, b_mask   
    integer :: D, a_mul, b_mul                   
        
    ! Can we defined these as constants in a better way?
    D = 2147483647
    a_mul = 16807
    b_mul = 48271
        
    a = generate(a, a_mul, D, a_mask)
    b = generate(b, b_mul, D, b_mask)
end subroutine generate_pair 
    
integer function generate(prev, mul, D, mask)
    implicit none
        
    integer :: prev, mul, D, mask
    integer(kind=int64) :: prev_large, mul_large, mask_large
        
    ! To get around overflow in the multiplication before the modulo
    mask_large = mask
    prev_large = prev
    mul_large = mul

    prev_large = modulo(prev_large*mul_large, D)
    do while (iand(prev_large, mask_large) /= 0)     
        prev_large = modulo(prev_large*mul_large, D)
    end do
    
    generate = prev_large
            
end function generate
    
subroutine parse(a0, b0)
    implicit none
        
    ! A bit hard coded, but still general enough for me
    character(16) :: words( 10 )
    integer, intent(out) :: a0
    integer, intent(out) :: b0
    
    read(*,*) words(1:10)
    read(words(5),*) a0
    read(words(10),*) b0
            
end subroutine parse

end program main    
