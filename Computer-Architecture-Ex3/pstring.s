#206821258 Idan Simai
.section	.rodata
Error: 		.string "invalid input!\n"
.text
.global pstrlen
.type pstrlen, @function
pstrlen:
	movzbq	(%rdi), %rax        #Set the string length as the retruned value.
	ret

.global replaceChar
.type replaceChar, @function
replaceChar:
	pushq	%rdi                #Push the string address to the stack.
	call	pstrlen             #Get the string length.
	addq	$1, %rdi            #Get the string address 1 byte further.
	xor	    %r8, %r8            #Assign %r8 to 0.
	xor	    %r9, %r9            #Assign %r9 to 0.
	jmp     .replaceChar_loop

.replaceChar_loop:
	cmpq	%rax, %r8           #Compare %r8 (the counter) to %rax (the string length).
	je	    .replaceChar_end    #If they are equal, jump to the end of loop.
	movb	(%rdi), %r9b        #Move the char in i'th place to %r9b.
	cmpq	%r9, %rsi           #Check if the i'th char is equal to the char we want to replace.
	je 	    .replaceChar_rep    #If they are, jump to replace.
	jmp     .replaceChar_iter

.replaceChar_rep:
	movb	%dl, (%rdi)         #Replace the old char with new char.
	jmp	    .replaceChar_iter   #Continue iterating in the loop.

.replaceChar_iter:
	addq	$1, %r8             #Add 1 to the counter(%r8).
	addq	$1, %rdi            #Get the string's address 1 byte further.
	jmp	    .replaceChar_loop   #Jump to excute the loop.

.replaceChar_end:
	popq	%rdi                #Pop the original %rdi back to %rdi.
	movq	%rdi, %rax          #Move the original string address to %rax(the returned value).
	ret

.global pstrijcpy
.type pstrijcpy, @function
pstrijcpy:
    pushq   %rbp                #Push %rbp to the stack for a backup.
    pushq   %rbx                #Push %rbx to the stack for a backup.
    pushq   %r12                #Push %r12 to the stack for a backup.
	pushq 	%r13                #Push %r13 to the stack for a backup.
	pushq   %r14                #Push %r14 to the stack for a backup.
	pushq   %r15                #Push %r13 to the stack for a backup.
	xor     %rbx, %rbx          #Assign %rbx to 0.
	xor     %rbp, %rbp          #Assign %rbp to 0.
	xor     %r12, %r12          #Assign %r12 to 0.
	xor     %r13, %r13          #Assign %r13 to 0.
	xor     %r14, %r14          #Assign %r14 to 0.
	xor     %r15, %r15          #Assign %r15 to 0.
	leaq	(%rdi), %r14        #The destination string (1).
	leaq	(%rsi), %r15        #The source string (2).
	call 	pstrlen             #Get the destination's length.
	movq 	%rax, %rbx          #Save the destination's length in %rbx.
	movq	%rsi, %rdi          #Put the source as the first argument.
	call 	pstrlen             #Get the source's length.
	movq	%rax, %rbp          #Save the source's length in %rbp.
	movq    %r14, %r12          #Put %r14 in %r12.
	cmpb 	$0, %dl
    jl 	    .pstrijcpy_error    #Jump if i < 0.
    cmpb 	$0, %cl
	jl   	.pstrijcpy_error    #Jump if j < 0.
	cmpb	%dl, %cl
	jl 	    .pstrijcpy_error    #Jump if i > j.
	cmpb 	%bpl, %cl
	jge 	.pstrijcpy_error    #Jump if j > source's length.
	cmpb 	%bl, %cl
	jge 	.pstrijcpy_error    #Jump if j > destination's length.
	leaq	1(%rdx, %r14), %r14 #Add %rdx(i) + 1 to the destination string.
	leaq	1(%rdx, %r15), %r15 #Add %rdx(i) + 1 to the source string.
	jmp     .pstrijcpy_loop

.pstrijcpy_loop:
	cmpb	%cl, %dl
	ja  	.pstrijcpy_end      #Jump to the end of the function.
	xor     %r13, %r13          #Assign %r13 to 0.
	movb	(%r15), %r13b       #Move from memory to register.
	movb	%r13b, (%r14)       #Move from register to memory.
	addq	$1, %r14            #Get the destination strings' address 1 byte further.
	addq	$1, %r15            #Get the source string's address 1 byte further.
	addq	$1, %rdx            #i++.
	jmp 	.pstrijcpy_loop

.pstrijcpy_error:
    subq    $8, %rsp            #Align %rsp so it ends with 0.
	movq	$Error, %rdi        #Put the format as the first argument.
	xor	    %rax, %rax          #Assign %rax to 0.
	call 	printf
	addq    $8, %rsp            #Add what we allocated back to %rsp.
	jmp     .pstrijcpy_end

.pstrijcpy_end:
    movq    %r12, %rax          #Set %rbp as the returned value.
	popq    %r15                #Pop and put it in %r15.
	popq    %r14                #Pop and put it in %r14.
	popq    %r13                #Pop and put it in %r13.
	popq    %r12                #Pop and put it in %r12.
	popq    %rbx                #Pop and put it in %rbx.
	popq    %rbp                #Pop and put it in %rbp.
	ret

.global swapCase
.type swapCase, @function
swapCase:
	pushq	%r12                #Push %r12 to stack.
	xor     %r12, %r12          #Assign %r12 to 0.
	leaq 	(%rdi), %r12        #Put the string in %r12.
	call	pstrlen
	addq	$1, %rdi            #Get the string's address 1 byte further.
	xor	    %r8, %r8            #Assign %r8 to 0.
	xor	    %r9, %r9            #Assign %r9 to 0.
	jmp     .swapCase_loop

.swapCase_loop:
	cmpq	%rax, %r8           #Compare the counter(%r8) with the string's length.
	je	    .swapCase_end
	movb	(%rdi), %r9b        #Move the char in the i'th place to %r9.
	cmpb	$64, %r9b  	        #Check if %r9 is lower than 'A''s ascii value.
	jle	    .swapCase_iter
	cmpb	$90, %r9b  	        #Check if %r9 is lower or equal to 'Z''s ascii value.
	jle	    .up_to_low
	cmpb	$96, %r9b           #Check if %r9 is lower than 'a''s ascii value.
	jle	    .swapCase_iter
	cmpb	$122, %r9b	        #Check if %r9 is lower or equal to 'z''s ascii value.
	jle	    .low_to_up
	jmp	    .swapCase_iter

.swapCase_iter:
	addq	$1, %r8             #Add 1 to the counter(%r8).
	addq	$1, %rdi            #Get the string's address 1 byte further.
	jmp	    .swapCase_loop

.up_to_low:
	addq	$32, %r9            #Add 32 to make the upper case lower.
	movb	%r9b, (%rdi)        #Put the new char in the string.
	jmp	    .swapCase_iter

.low_to_up:
	subq	$32, %r9            #Sub 32 to make the lower case upper.
	movb	%r9b, (%rdi)       #Put the new char in the string.
	jmp	    .swapCase_iter

.swapCase_end:
	movq	%r12, %rax          #Set %r12 as the returned value.
	popq	%r12                #Pop and put it in %r12.
	ret

.global pstrijcmp
.type pstrijcmp, @function
pstrijcmp:
    subq    $8, %rsp
    cmpb    $0, %dl             #Check if i < 0.
    jl      .pstrijcmp_error
    cmpb    %dl, %cl            #Check if i > j.
    jl      .pstrijcmp_error
    cmpb    %cl, (%rdi)         #Check if  j > first string's length.
    jle     .pstrijcmp_error
    cmpb    %cl, (%rsi)         #Check if j > Second string's length.
    jle     .pstrijcmp_error
    leaq    1(%rdx, %rdi), %rdi #Get the first string's address that starts from i 1 byte further.
    leaq    1(%rdx, %rsi), %rsi #Get the second string's address that starts from i 1 byte further.
    jmp     .pstrijcmp_loop

.pstrijcmp_loop:
    xor     %r8, %r8            #Assign $r8 to 0.
    movb    (%rdi), %r8b        #Put %r8 as the the i'th byte of string 1.
    cmpb    %r8b, (%rsi)        #Check if string 1[i]'s value is bigger than string 2[i]'s value.
    jl      .pstrijcmp_bigger
    cmpb    (%rsi), %r8b        #Check if string 1[i]'s value is smaller than string 2[i]'s value.
    jl      .pstrijcmp_smaller
    jmp     .pstrijcmp_equal

.pstrijcmp_bigger:
    movq    $1, %rax            #Set 1 as the returned value.
    jmp     .pstrijcmp_finish

.pstrijcmp_smaller:
    movq    $-1, %rax           #Set -1 as the returned value.
    jmp     .pstrijcmp_finish

.pstrijcmp_equal:
    addq    $1, %rdi            #Get the first string's address one byte further.
    addq    $1, %rsi            #Get the second string's address one byte further.
    addq    $1, %rdx            #i++.
    cmpq    %rdx, %rcx          #Check if j > i.
    jge     .pstrijcmp_loop
    movq    $0, %rax            #Set 0 as the returned value.
    jmp     .pstrijcmp_finish

.pstrijcmp_error:
    movq    $Error, %rdi        #Put the format as the first argument.
    xor     %rax, %rax          #Assign %rax to 0.
    call    printf
    movq    $-2, %rax           #Set -2 as the returned value.
    jmp     .pstrijcmp_finish

.pstrijcmp_finish:
    addq    $8, %rsp            #Add what we allocated back to %rsp.
    ret
