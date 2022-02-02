.global _start
.data
buf: .skip 1024

.text
_start:
        call main
        movq $0, %rdi
        movq $60, %rax
        syscall

# Function for solving the problem
main:
        pushq %rbp              # Push the dynlink (last FP)
        movq %rsp, %rbp         # Set FP (rbp) to the SP (rsp)
        pushq $0                # Create local variable for length of array
        pushq $0                # Create local var for number of steps taken

read_num:       # Reads a num and pushes it onto the stack, continues until EOF reached where it continues
        movq $1, %r9            # r9: sign <- 1
        movq $0, %r10           # r10: sum <- 0
        movq $0, %rdi
        leaq buf(%rip), %rsi    # Set read pointer to end of buffer 
        movq $1, %rdx
        movq $0, %rax
        syscall                 # get one char: sys_read(0, buf, 1)
        cmpq $0, %rax
        jle do_jumps            # num_read <= 0 (EOF reached) ERROR?
        movb (%rsi), %cl        # cl <- current char
        cmp $45, %cl
        jne accumulate_sum_read # Not negative
        movq $-1, %r9           # TODO: Try instead have if statement for negative
        
accumulate_sum: # Read the chars and add to sum until we hit a newline
        movq $0, %rdi
        leaq buf(%rip), %rsi
        movq $1, %rdx
        movq $0, %rax
        syscall                 # get one char: sys_read(0, buf, 1)
accumulate_sum_read: # After the char is read
        cmpq $0, %rax
        jle num_read            # No char read
        movzbq (%rsi), %rcx     # move byte, zero extend to quad-word
        cmpq $48, %rcx          # test if < '0'
        jl num_read             # character is not numeric
        cmpq $57, %rcx          # test if > '9'
        jg num_read             # character is not numeric
        imulq $10, %r10         # multiply sum by 10
        subq $0x30, %rcx        # value of character
        addq %rcx, %r10         # add to sum
        jmp accumulate_sum
        
num_read:       # Reached end of line
        imulq %r9, %r10         # sum *= sign
        pushq %r10              # Push the number on the stack
        addq $1, -8(%rbp)       # Add one to the local variable. ERROR?
        jmp read_num    

do_jumps:       # Now the stack is set up, simply execute the jumps until we escape and then return the answer
        movq $0, %rax           # rax: current pos = 0
                                # rbx: the current address in the array
do_jump:
        cmpq -8(%rbp), %rax
        jge jumps_done          # Done if pos >= length

        movq %rbp, %rbx
        subq $24, %rbx
        movq %rax, %rcx
        imulq $8, %rcx
        subq %rcx, %rbx          # rbx = rbp - 24 - 8*pos

        addq (%rbx), %rax
        addq $1, (%rbx)         # Increase value in array by 1
        addq $1, -16(%rbp)      # Increase number of taken steps by 1
        jmp do_jump

jumps_done:
        pushq -16(%rbp)
        call print
        popq %rdx

        movq -8(%rbp), %rbx
        imulq $8, %rbx
        addq %rbx, %rsp         # Deallocate the array
        addq $16, %rsp          # Deallocate the local variables
        popq %rbp
        ret                     # Return from main

# Procedure to print number to stdout. From my course in Compilers as I did not want to re do it
print:
        pushq %rbp
        movq %rsp, %rbp
        ### Convert integer to string (itoa).
        movq 16(%rbp), %rax
        leaq buf(%rip), %rsi    # RSI = write pointer (starts at end of buffer)
        addq $1023, %rsi
        movb $0x0A, (%rsi)      # insert newline
        movq $1, %rcx           # RCX = string length
        cmpq $0, %rax
        jge itoa_loop
        negq %rax               # negate to make RAX positive
itoa_loop:                      # do.. while (at least one iteration)
        movq $10, %rdi
        movq $0, %rdx
        idivq %rdi              # divide RDX:RAX by 10
        addb $0x30, %dl         # remainder + '0'
        decq %rsi               # move string pointer
        movb %dl, (%rsi)
        incq %rcx               # increment string length
        cmpq $0, %rax
        jg itoa_loop            # produce more digits
itoa_done:
        movq 16(%rbp), %rax
        cmpq $0, %rax
        jge print_end
        decq %rsi
        incq %rcx
        movb $0x2D, (%rsi)
print_end:
        movq $1, %rdi
        movq %rcx, %rdx
        movq $1, %rax
        syscall
        popq %rbp
        ret
