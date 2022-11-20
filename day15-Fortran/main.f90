program main
    use iso_fortran_env, only: int64
    implicit none

    integer :: a, b
    
    ! Read the iniital generating values
    call parse(a, b)
    call part1(a, b)
    !call part2(a, b)
    
contains

    
subroutine part1(a0, b0)
    implicit none
       
    integer, intent(in):: a0, b0
    integer:: i, matches
    integer:: a, b
    
    matches = 0
    a = a0
    b = b0
            
    do i = 1, 40000000
        call generate_pair(a, b)  
        if (truncate16(a) == truncate16(b)) then
            matches = matches + 1
        end if
    end do
    
    print *, "Number of matches: ", matches
        
end subroutine part1
    
integer function truncate16(val)
    implicit none
    
    integer:: val, mask
        
    mask = 65535
    
    truncate16 = iand(val, mask)
        
end function truncate16
    
subroutine generate_pair(a, b)
    implicit none
    
    integer :: D, a_mul, b_mul    
    integer, intent(out):: a, b   
                
    D = 2147483647
    a_mul = 16807
    b_mul = 48271
        
    a = generate(a, a_mul, D)
    b = generate(b, b_mul, D)
end subroutine generate_pair 
    
integer function generate(prev, mul, D)
    implicit none
        
    integer:: prev, mul, D
    integer(kind=int64):: prev_large, mul_large
        
    ! To get around overflow in the multiplication before the modulo
    prev_large = prev
    mul_large = mul
            
    generate = modulo(prev_large*mul_large, D)
    
end function generate
    
subroutine parse(a0, b0)
    implicit none
        
    character(16):: words( 10 )
    integer, intent(out):: a0
    integer, intent(out):: b0
    
    read(*,*) words(1:10)
    read(words(5),*) a0
    read(words(10),*) b0
            
end subroutine parse

end program main    
