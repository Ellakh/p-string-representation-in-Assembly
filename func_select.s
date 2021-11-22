
 .align	     8	              # we want all data to be save in an addr that divise with their size.
.section .rodata
.table:
            .quad .case50Or60 # case 50 Or 60
            .quad .default    # default case
            .quad .case52     # case 52
            .quad .case53     # case 53
            .quad .case54     # case 54
            .quad .case55     # case 55
            .quad .default    # default case
            .quad .default    # default case
            .quad .default    # default case
            .quad .default    # default case
            .quad .case50Or60 # case 50 Or 60
# string formats
forChar:    .string " %c"
forNum:     .string "%d"
f50Or60:    .string "first pstring length: %d, second pstring length: %d\n\0"
f52:        .string "old char: %s, new char: %s, first string: %s, second string: %s\n\0"
f53:        .string "length: %d, string: %s\n\0"
f54:        .string "length: %d, string: %s\n\0"
f55:        .string "compare result: %d\n\0"
def:        .string "invalid option!\n\0"
.section	.text
.globl  run_func
.type	run_func, @function
run_func:
    pushq   %rbp                # save old frame pointer
    movq    %rsp, %rbp          # create the new frame pointer
    pushq   %r12                # save callee register
    pushq   %r13                # save callee register
    pushq   %r14                # save callee register
    pushq   %r15                # save callee register
    pushq   %rbx                # save callee register 
    movq    %rdi, %rcx
    subq    $50, %rcx           # after taking away 50 , we know the given case
    # leaq    -50(%rdi), %rcx     # after taking away 50 , we know the given case
    cmpq    $10, %rcx            
    ja      .default            # for the default case, if we get number or value other than 50 / 60 / 52 / 53 / 54 / 55
    jmp     *.table(,%rcx,8)    # jump according for the jump table 
    .case50Or60:                # case "50" or "60"
        movq	%rdx, %r12      # put the value of second pstring addr in $rbx 
        movq	%rsi, %rdi      # put the value of first pstring as a param for pstrlen
        call    pstrlen
        movq    %rax, %r9       # put return value of pstrlen for the first pstring in %r9

        movq    %r12, %rdi      # put second pstring as the first param for pstrlen
        call    pstrlen
        movq    %rax, %r10      # put return value for pstrlen for the second pstring in %r10

        movq    $f50Or60, %rdi  # put the value of relevant format as the first parama for printf
        movq    %r9, %rsi       # put the value of first pstring length as the second param for printf
        movq    %r10, %rdx      # put the value of second pstring length as the last param for printf
        movq    $0, %rax        # in the instruction of the assignment written we have for do that before calling scanf/printf
        call    printf
        
        jmp     .retunFunc
    .case52:                    # case "52"
        subq    $8, %rsp
        movq    %rsi, %r12      # put 2 pstrings: the first one, in %r12 
        movq    %rdx, %r13      # and the second one in %r13

                                # getting old char
        subq    $9, %rbp
        movq    %rbp, %rax
       
        movq	$forChar, %rdi  # move format as first param to scanf
        movq    %rax, %rsi      # put addr as the second param for scanf
        
        movq    $0, %rax
         call    scanf

        movq    $0, %r14		# zero for prevent bugs
		movq	%rsi, %r14	    # move to %r14 the char


                                # inserting new char

       
        subq    $9, %rbp
        movq    %rbp, %rax
        movq	$forChar, %rdi  # move format as tne first param for scanf
        movq    %rax, %rsi      # put addr as the first param for scanf
        movq    $0, %rax
         call    scanf


                               
        
        movq    $0, %r15		# zero for prevent bugs
	    movq	%rsi, %r15	    # move char for %r15


                                # call replaceChar for the first pstring
        movq    %r12, %rdi      # put the value of first pstring as first param for replaceChar      
		movq    %r14, %rsi      # put oldchar as the second param for replaceChar
		movq    %r15, %rdx      # put newchar as the last param for replaceChar
         call    replaceChar


                                # call replaceChar for the second pstring
        movq    %r13, %rdi      # put the value of second pstring as the first param for replaceChar           
		movq    %r14, %rsi      # put oldchar as the second param for replaceChar
	    movq    %r15, %rdx      # put newchar as the last param for replaceChar
         call    replaceChar


                                # printing what we need (according for the format)
        movq   $f52, %rdi       # put format as the first param for printf        
		movq   %r14, %rsi       # put oldchar as the second param for printf
		movq   %r15, %rdx       # put newchar as the third param for printf

        addq   $1, %r12         # put its pointer to point for the first string itself
	    movq   %r12, %rcx       # put the value of first pstring as the fourth param for printf 

        addq   $1, %r13         # put its pointer to point for the second string itself
		movq   %r13, %r8        # put the value of second pstring as the fifth param for printf

        movq   $0, %rax         # zero for prevent bugs
         call   printf
        addq    $18, %rbp
        jmp    .retunFunc
    .case53:                    # case "53"
        movq   %rsi, %r12       # put in registers the values of 2 pstrings
        movq   %rdx, %r13

        

        subq   $8, %rsp         # find place in memory for index i
        movq   $0, (%rsp)       # zero for preventing bugs
                                # get the i index
               		      
		movq   $forNum, %rdi    # put the value of rellevant format as the first param for scanf
        movq   %rsp, %rsi       # put addr as the second param for scanf       		
		movq   $0, %rax         # zero for prevent bugs
		call   scanf


        movq   $0, %r14         # zero for preventing bugs
		movq   (%rsp), %r14     # put index at %r14
                                # get the j index
        movq   $0, (%rsp)       # zero for preventing bugs        		      
		movq   $forNum, %rdi    # put format as the first param for scanf 
        movq   %rsp, %rsi       # put addr as the second param for scanf     		
		movq   $0, %rax
		call   scanf


        movq   $0, %r15         # zero for preventing bugs
		movq   (%rsp), %r15     # put index j at %r15          
                                # call pstrijcpy
       	movq 	%r12 , %rdi     # put the value of first pstring as the first param to pstrijcpy            
		movq 	%r13 , %rsi     # put the value of second pstring as the second param to pstrijcpy
		movq 	%r14 , %rdx     # put index i as the third param to pstrijcpy
		movq 	%r15 , %rcx     # put index j as the fourth param to pstrijcpy
		call    pstrijcpy
                                # print the first pstring
        movq 	%r12, %rdx      # put the value of first pstring as the third param for printf        
		addq 	$1 , %rdx       # change the pstring addr so it will point to the first string 
		movq 	%r12 , %rdi     # put the value of first pstring as param to pstrlen
		call    pstrlen 

        movq 	$f53 , %rdi     # put format as the first param for printf
		movq 	%rax , %rsi     # put length as the second param for printf
        movq    $0, %rax
        call    printf
                                # print the second pstring
        movq 	%r13, %rdx      # put the value of first pstring the third param for printf        
		addq 	$1 , %rdx       # change the pstring addr so it will point to the first string 
		movq 	%r13 , %rdi     # put the value of first pstring as param to pstrlen
		call    pstrlen

		movq 	%rax , %rsi     # put length as the second param for printf
		movq 	$f53 , %rdi     # put format as the first param for printf
        movq    $0, %rax

        call    printf
        jmp     .retunFunc
    
       
    .case54:                    # case "54"
        movq    %rsi, %r12      # save 2 pstrings
        movq    %rdx, %r13
                                # switch the first pstring
        movq    %r12, %rdi      # put the value of first pstring as param for swapCase
        call    swapCase
                                # switch the second pstring
        movq    %r13, %rdi      # put the value of second pstring as param for swapCase
        call    swapCase
                                # get pstring sizes
        movq    %r12, %rdi      # put the value of first pstring as param for pstrlen
        call    pstrlen
        movq    %rax, %r8       # save the first pstring size


        movq    %r13, %rdi      # put the value of second pstring as param for pstrlen
        call    pstrlen
        movq    %rax, %r9       # save the second pstring size
        
                                # print the result
        movq 	$f53, %rdi      # put format as the first param for printf
        addq    $1, %r12
        movq 	%r12, %rdx      # put the value of first pstring as the third param for printf
        movq 	%r8, %rsi       # put its length as the second param for printf
        movq    %r9, %r12       # save the second pstring size
		# addq    $1, %rdx        # change pstring addr so it points to the string
		movq 	$0, %rax        # zero for prevent bugs
		call    printf

        movq 	$f53, %rdi      # put format as the first param for printf
        movq 	%r12, %rsi      # put its length as the the second param to printf
        movq 	%r13, %rdx      # put the value of second pstring as the third param for printf
		addq    $1, %rdx        # change pstring addr so it points to the string 
		movq 	$0, %rax
		call    printf

        jmp     .retunFunc
    .case55:                    # case "55" 
        
        movq    %rsi, %r12      # save 2 pstrings
        movq    %rdx, %r13

        subq	$8, %rsp        # find place in memory for index i
        movq	$0, (%rsp)      # zero for preventing bugs

                                # get the index i
        movq 	$forNum, %rdi   # put format as the first param for scanf 
        movq    %rsp, %rsi      # put addr as the second param for scanf         		      
		movq  	$0, %rax
		call    scanf

        movq    $0, %r14        # zero for prevent bugs
		movq 	(%rsp) , %r14   # save index i at %r14

                                # get index j
        movq    $0, (%rsp)      # zero for prevent bugs
        movq 	$forNum, %rdi   # put format as the first param for scanf  
        movq    %rsp, %rsi      # put addr as the second param for scanf         		        		
		movq  	$0, %rax
		call    scanf


        movq    $0, %r15        # zero for prevent bugs
		movq 	(%rsp) , %r15   # store index j at %r15

                                # call pstrijcmp
        movq   %r12 , %rdi      # put the value of first pstring as the first param for pstrijcmp
		movq   %r13 , %rsi      # put the value of second pstring as the second param for pstrijcmp
		movq   %r14 , %rdx      # put the value of index i as the third param for pstrijcmp
		movq   %r15 , %rcx      # put the value of second index as the fourth param for pstrijcmp
        call   pstrijcmp
                                # print result
        movq    $f55, %rdi      # put format as the first param for printf
        movq    %rax, %rsi      # put compare result as the second param for printf
        movq    $0, %rax
        call    printf

        jmp     .retunFunc
    
    
    .default:                   # default case
        movq    $def, %rdi
        movq    $0, %rax
        call    printf
        jmp     .retunFunc
    
    .retunFunc:
        movq    $0,  %rax       # return 0
        popq    %rbx            # pop all the registers
        popq    %r15            # i pushed to stack 
        popq    %r14            # earlier
        popq    %r13
        popq    %r12
        movq    %rbp, %rsp      # restore old frame pointer
        popq    %rbp
        ret
        

    



    




