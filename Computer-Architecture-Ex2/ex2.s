#206821258 Idan Simai
.text
.global even
.type	even, @function

even:
    movb %sil, %cl      #Move i to the right register so we can shift with.
    salq %cl, %rdi      #Left shift i times.
    movl %edi, %eax     #Set the shifted answer as the returned value.
    ret

.text
.global go
.type go, @function

go:
    xorl %r11d, %r11d     #Assign 0 to sum(%r11).
    xorl %r12d, %r12d     #Assign 0 to i(%r12).
    jmp .L2
    
    .L1:                  #The start of the loop.
    add  $4, %r15       #We get the pointer i places further by raising the address by 4.
    movq %r15, %rdi       #We switch back from the helping register to the original one
    jmp .L2
    
    .L2:
    movq %rdi, %r15      #Put the original address in %r15.
    movl (%rdi), %r8d    #%r8d = A[i].
    testl $1, %r8d       #We check if A[i] mod 2 == 0.
    jnz .L4              #Jump to the "Odd" label.
    movl %r8d, %edi      #Put A[i] as the first argument.
    movl %r12d, %esi     #Put i as the second argument.
    call even            #Call the even function. 
    movl %eax, %r13d     #We define the integer Num(%r13) as the returned value.
    add %r13d, %r11d     #Sum += Num. 
    jmp .L3
    
    .L3:                 #The latter part of the loop.
    add $1, %r12         #i++.
    cmpl $9, %r12d       #Check if i is lesser than 9.
    jle .L1              #Execute the loop.
    movl %r11d, %eax     #Set Sum as the returned value.
    ret
    
    .L4:                 #The odd case.
    add %r8d, %r11d      #Sum += A[i].
    jmp .L3
    