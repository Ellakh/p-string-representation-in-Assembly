
.section  .rodata
    
# string formats
def:      .string "invalid input!\n\0"
forNum:   .string "%d"
forChar:  .string " %c"
forString:  .string " %s"
.section  .text
.globl  run_main
.type run_main, @function 
run_main:
    
    pushq   %rbp             # save old frame pointer
    movq    %rsp, %rbp            
    pushq   %r13             # save callie save registers
    pushq   %r12
    
    subq    $16, %rsp
                             # get length of the first pstring
                             # the line from c file you gave us: scanf("%d", &len);
    movq	$forNum, %rdi    # putting the value of the format to the the first param to scanf
    movq    %rsp, %rsi       # putting the value of the addr to the the second param to scanf
	movq	$0, %rax
	call	scanf

                           
    movl    (%rsp), %r12d    # move inputed length to %r12 
    cmpq    $254, %r12       # check if a normal length for the pstring 
                             # (max length in the struct in the assignment (255) - 1 ('/0'))
    ja      .ilegalCase      # if the case is ilegal

   
                             # (the line from c file you gave us: scanf("%s", p1.str);)       
                             # creating the the first pstring
                             # find place in stack for the string length to be puted
    # subq    %r12, %rsp
    # subq    $1, %rsp
    subq    $16, %rsp
    movq    $forString, %rdi  # loading format to the first paramater to scanf
    movq    %rsp, %rsi      # loading address to the second paramater to scanf
    movq    $0, %rax
    call    scanf     
    
    subq    $1, %rsp
    movb    %r12b, (%rsp)
    movq    %rsp, %r12

                             # get the length of the second pstring
                             # (the line from c file you gave us: scanf("%d", &len);)
    subq    $15, %rsp        # find place in memory for putting the input from scanf
    movq	$forNum, %rdi    # putting the value of the format as the first param to scanf
    movq    %rsp, %rsi       # putting the value of the addr as the second param to scanf
	movq	$0, %rax
	call	scanf


    movl    (%rsp), %r13d     # move inputed length to %r12 for convinence
    cmpq    $254, %r13       # decide if valid length for the pstring (max length defined in the struct (255) - 1 because of '/0')
    ja      .ilegalCase      # case ilegalCase (using unsigned for all cases)
    
                             # building the the second pstring
    subq    $16, %rsp
    
    movq    $forString, %rdi  # loading format to the first paramater to scanf
    movq    %rsp, %rsi        # loading address to the second paramater to scanf
    movq    $0, %rax
    call    scanf   
    
    
                             # get the option number
    subq    $1, %rsp         

    movb    %r13b, (%rsp)
    movq    %rsp, %r13


    subq    $15, %rsp 


    movq    %rsp, %rsi       # putting the value of the addr to the the second param to scanf
	movq	$forNum, %rdi    # putting the value of the format to the the first param to scanf
	movq	$0, %rax
	call	scanf
    
    

    # calling run_func
    movl    (%rsp), %edi       # putting the value of the inputed number as the the first param to run_func
    movq    %r12, %rsi       # putting the value of the the first pstring as the the second param to run_func
    movq    %r13, %rdx       # putting the value of the the second pstring as the 3rd param to run_func
    call    run_func
    jmp     .END
    
    # case an invlid pstring length (<0 || >254) was inputed
.ilegalCase:
    
    movq    $def, %rdi       # put format as param for printf
    movq    $0, %rax
    call    printf
    jmp     .END
    
.END:
    movq    $0,  %rax        # return 0
    popq    %r12             # pop all the registers
    popq    %r13             # i pushed to stack 
    movq    %rbp, %rsp       # restore old frame pointer
    popq    %rbp             # earlier
    ret
