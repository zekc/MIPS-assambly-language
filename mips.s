.data
menu: .asciiz "QtSpim MIPS Menu:\n
      1. Find Palindrome\n
      2. Reverse Vowels\n
      3. Find Distinct Prime\n
      4. Lucky Number\n
      5. Exit\n"
str: .space 100     # space to store the input string
vowel_stack: .space 100 # space to store vowels
stack_top: .word 0  # top of the vowel stack
prompt2: .asciiz "Enter a string: "   
    number_prompt: .asciiz "Enter an integer number: "
not_square_free: .asciiz " is not a square-free number.\n"
square_free: .asciiz " is a square-free number and has distinct prime factors: "
space: .asciiz " " 

strq1: .space 100        # space to store the input string
palindrome: .space 100 # space to store the palindrome
max_len: .word 0       # variable to store the maximum length of palindrome found
promptq1: .asciiz "Enter a string: "
palindrome_msg: .asciiz "\nThe longest palindrome is: "
length_msg: .asciiz "\nAnd its length is: "


   matrix: .word 1, 2, 3, 4, 5, 6, 7, 8, 9
    n: .word 3
    m: .word 3
   
    row_size: .word 0
    column_size: .word 0
    not_distinct_message: .asciiz "The element must be distinct. Please enter a different element.\n"
    no_lucky_number_message: .asciiz "There is no lucky number in the matrix.\n"
    input_message: .asciiz "Please enter the size of the matrix (n m):\n"
    input_element_message: .asciiz "Please enter an element of the matrix:\n"
     generated_message: .asciiz "matrix generated\n"

    

prompt: .asciiz "Enter your choice: "
program: .space 256 
program_prompt: .asciiz "Input : "

.text
main:
    li $v0, 4       # Print menu
    la $a0, menu
    syscall

    li $v0, 4       # Prompt for choice
    la $a0, prompt
    syscall

    li $v0, 5       # Read choice
    syscall
    move $t0, $v0

    # Execute chosen option
    beq $t0, 1, Find_Palindrome
    beq $t0, 2, Reverse_Vowels
    beq $t0, 3, FindDistinctPrime
    beq $t0, 4, LuckyNumber
    beq $t0, 5, exitProgram
 

    # Invalid choice
    j main

Find_Palindrome:
    li $v0, 4       
    la $a0, program_prompt
    syscall

    li $v0, 8       # Read program file path
    la $a0, program
    li $a1, 256     # Max file path length
    syscall

    # Code to load program
    j main


Reverse_Vowels:
     # Prompt user for input string
    li $v0, 4
    la $a0, prompt2
    syscall

    # Read input string from user
    li $v0, 8
    la $a0, str
    li $a1, 100
    syscall

    # Initialize variables
    la $t0, str        # pointer to the start of the input string
    la $t1, vowel_stack # pointer to the vowel stack
    lw $t2, stack_top  # load the top of the vowel stack



push_vowels:
    lbu $t3, ($t0)  # load a byte from input string
    beqz $t3, pop_vowels  # end of input string

    move $a0, $t3
    jal is_vowel
    beqz $v0, advance_push

    sb $t3, ($t1)   # push the vowel onto the stack
    addiu $t1, $t1, 1
    addiu $t2, $t2, 1

advance_push:
    addiu $t0, $t0, 1
    j push_vowels

pop_vowels:
    la $t0, str  # reset pointer to the start of the input string
    sw $t2, stack_top  # update the top of the vowel stack

replace_vowels:
    lbu $t3, ($t0)  # load a byte from input string
    beqz $t3, print_result  # end of input string

    move $a0, $t3
    jal is_vowel
    beqz $v0, advance_pop

    lw $t2, stack_top  # load the top of the vowel stack
    addiu $t2, $t2, -1
    sw $t2, stack_top  # update the top of the vowel stack

    addiu $t1, $t1, -1
    lbu $t4, ($t1)   # pop the vowel from the stack
    sb $t4, ($t0)    # replace the original vowel in the string

advance_pop:
    addiu $t0, $t0, 1
    j replace_vowels

print_result:
    li $v0, 4
    la $a0, str
    syscall

    j main
    

is_vowel:
    li $v0, 0
    li $t4, 0x61   # 'a'
    li $t5, 0x65   # 'e'
    li $t6, 0x69   # 'i'
    li $t7, 0x6F   # 'o'
    li $t8, 0x75   # 'u'

	li $s0, 0x41   # 'A'
    li $s1, 0x45   # 'E'
	li $s2, 0x49   # 'I'
	li $s3, 0x4F   # 'O'
	li $s4, 0x55   # 'U'

    beq $a0, $t4, vowel_found
    beq $a0, $t5, vowel_found
    beq $a0, $t6, vowel_found
    beq $a0, $t7, vowel_found
    beq $a0, $t8, vowel_found

	beq $a0, $s0, vowel_found
    beq $a0, $s1, vowel_found
    beq $a0, $s2, vowel_found
    beq $a0, $s3, vowel_found
    beq $a0, $s4, vowel_found

    j not_vowel

vowel_found:
    li $v0, 1
    jr $ra


not_vowel:
    jr $ra


print_factors:
    ble $s1, $t0, exit

    rem $t2, $s0, $t0
    bnez $t2, increment_factor

    li $v0, 1
    move $a0, $t0
    syscall

    # Print a space
    li $v0, 4
    la $a0, space
    syscall

    div $s0, $t0
    mflo $s0

increment_factor:
    addi $t0, $t0, 1
    j print_factors
    



FindDistinctPrime:
       li $v0, 4
    la $a0, number_prompt
    syscall

    # Read integer from user
    li $v0, 5
    syscall
    move $s0, $v0  # Store input integer in $s0

    # Initialize variables
    li $t0, 2      # Counter for prime factors
    li $t1, 0      # Count of distinct prime factors
    move $s1, $s0  # Copy of the input integer


check_prime:
    # Check if the counter has reached the input integer
    ble $s1, $t0, print_resultPrime

    # Check if the current number is divisible by the counter
    rem $t2, $s1, $t0
    bnez $t2, increment_counter

    # Divide the current number by the counter
    div $s1, $t0
    mflo $s1

    # Check if the current number is still divisible by the counter (not square-free)
    rem $t2, $s1, $t0
    beqz $t2, not_square_free_result

    # Increment the count of distinct prime factors
    addi $t1, $t1, 1

increment_counter:
    addi $t0, $t0, 1
    j check_prime

not_square_free_result:
    # Print the input integer and the not square-free message
    li $v0, 1
    move $a0, $s0
    syscall
    li $v0, 4
    la $a0, not_square_free
    syscall
    j main

print_resultPrime:
    # Print the input integer and the square-free message
    li $v0, 1
    move $a0, $s0
    syscall
    li $v0, 4
    la $a0, square_free
    syscall

    # Print the distinct prime factors
    li $t0, 2
    move $s1, $s0

    
LuckyNumber:
   # Print a message asking the user for input
    li $v0, 4  
    la $a0, input_message
    syscall

    # Read in the matrix size from the user
    li $v0, 5
    syscall
    move $t0, $v0 # $t0 contains n

    li $v0, 5
    syscall
    move $t1, $v0 # $t1 contains m

    # Allocate memory for the matrix
    li $v0, 9
     
    mul $s1, $t0, $t1   # multiply $t0 and $t1 and store the result in $t2
    mflo $a0            # move the lower 32 bits of the result from $t2 to $a0

    syscall
    move $s0, $v0 # $s0 contains the address of the matrix

    # Read in the matrix elements from the user
    la $t2, matrix
    li $t3, 0
    loop_row:


        

        loop_col:
            bgt $t3, $s1, done_input
                
              blt $t3, $t1, read_element
             addi $t3, $t3, 1

            read_element:
                # Ask the user for input
                li $v0, 4
                la $a0, input_element_message
                syscall

                # Read in the element from the user
                li $v0, 5
                syscall
                move $t4, $v0

                # Check if the element is distinct
                la $t5, matrix
                li $t6, 0
                loop_check:
                    blt $t6, $t3, check_element
                    j save_element

                    check_element:
                        lw $t7, ($t5)
                        beq $t4, $t7, prompt_again
                        addi $t5, $t5, 4
                        addi $t6, $t6, 1
                        j loop_check

                    prompt_again:
                        # The element is not distinct, so prompt the user again
                        li $v0, 4
                        la $a0, not_distinct_message
                        syscall
                        j read_element

                save_element:
                    # The element is distinct, so save it in the matrix
                    sw $t4, ($t2)
                    addi $t2, $t2, 4
                    addi $t3, $t3, 1
                    j loop_col

       

    done_input:
         li $v0, 4
        la $a0, generated_message
        j main


exitProgram:
    li $v0, 10      # Exit program
    syscall




   


exit:
