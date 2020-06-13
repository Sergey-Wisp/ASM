.model small

.stack 100h

.data

    messageInvalid db  "Invalid number",0Dh ,0Ah ,'$'

    messageAmount db   "Enter number of numbers(2-30): ", 0Dh, 0Ah, '$'

    messageEnterNumber db "Enter number: ", 0Dh, 0Ah, '$' 

    messageRandom db "Random sequence ", 0Dh, 0Ah, '$' 

    messageIncreasing db "Increasing sequence", 0Dh, 0Ah, '$' 

    messageDecreasing db "Decreasing sequence", 0Dh, 0Ah, '$' 

    errorMessage db "Error", 0Dh, 0Ah, '$' 

    messageCR db 0Dh, 0Ah, '$'

    number1 dw 0x28

    number2 dw 0x28  

              

    inputNumberBuff     db 10

    inputNumberLength   db ?

    

    inputNumber         db 10 dup('$')

    

    numberCount db 0

    

    numberArray dw 30 dup(0)

                                   

.code     



puts macro message

    lea dx, message

    mov ah, 9

    int 21h

endm



signedCompare proc near

    push bp

    mov bp, sp

    mov ax, [bp + 6]

    mov bx, [bp + 4]

    and ax, 0x8000

    jnz firstNegative 

    and bx, 0x8000

    jnz greater    

    mov ax, [bp + 6]

    mov bx, [bp + 4]

    cmp ax, bx

    je equal

    jg greater

    jmp less

    firstNegative:

        and bx, 0x8000

        jz less

        mov ax, [bp + 6]

        mov bx, [bp + 4]

        cmp ax, bx

        je equal

        jl less

        jmp greater

    greater:

        mov ax, 0x01

        pop bp

        ret 4

    less:

        mov ax, 0x02

        pop bp

        ret 4

    equal:

        xor ax, ax

        pop bp

        ret 4

signedCompare endp



checkNumber proc near

    push bp

    mov bx, offset inputNumberLength

    mov al, [bx]

    cmp al, 6

    jg invalidNumber

    cmp al, 0

    je invalidNumber

    mov bx, offset inputNumber

    mov ah, [bx]

    cmp ah, '-'

    jne checkPositive

        inc bx

        dec al

    checkPositive:

        cmp al, 5

        jg invalidNumber

    startCheck:

        mov ah, [bx]

        cmp ah, 0Dh

        je validNumber

        cmp ah, '0'

        jl invalidNumber

        cmp ah, '9'

        jg invalidNumber

        inc bx

        jmp startCheck

    validNumber:

        mov ax, 1

        pop bp

        ret

    invalidNumber:

        mov ax, 0

        pop bp

        ret

checkNumber endp



atoi proc near

    push bp

    xor ax, ax

    xor dx, dx

    xor cx, cx

    mov cx, 10

    mov bx, offset inputNumber

    mov dl, [bx]

    cmp dl, '-'

    jne procStartLoop

    inc bx

    procStartLoop:

        mov dl, [bx]

        cmp dl, 0Dh

        je procEndLoop

        mul cx

        cmp dx, 0

        jne printInvalid

        mov dl, [bx]

        sub dl, '0'

        add ax, dx

        inc bx

        jmp procStartLoop

    procEndLoop:

        mov bx, offset inputNumber

        mov dl, [bx]

        cmp dl, '-'

        jne procReturn

        xor ax, 0xFFFF

        inc ax

        push ax

        and ax, 0x8000

        jz printInvalid

        pop ax

        pop bp

        ret     

    procReturn:

        push ax

        and ax, 0x8000

        jnz printInvalid

        pop ax        

        pop bp

        ret

atoi endp



start:

    mov ax, @data

    mov ds, ax 

    

    

    

    puts messageAmount

  

    mov ah, 0Ah

    mov dx, offset inputNumberBuff

    int 21h

    

   puts messageCR

   

    

    mov bx, offset inputNumberLength

    mov ah, [bx]

    cmp ah, 2

    jg error

    cmp ah, 0

    je error

    mov bx, offset inputNumber

    mov ah, [bx]

    cmp ah, '0'

    jl error

    cmp ah, '9'

    jg error

    sub ah, '0'

    inc bx

    cmp [bx], 0Dh

    je proceed

    mov al, ah

    mov ah, 10

    mul ah

    mov ah, al    

    cmp [bx], '0'

    jl error

    cmp [bx], '9'

    jg error

    add ah, [bx]

    sub ah, '0'

    cmp ah, 30

    jg error

    proceed:

		cmp ah, 2

		jl error

        mov bx, offset  numberCount

        mov [bx], ah

    

    mov bx, offset numberCount

    mov cx, [bx]

    mov bx, offset numberArray

    startLoop:   

        cmp cx, 0

        je endLoop

       

        puts messageEnterNumber

        

        mov ah, 0Ah

        mov dx, offset inputNumberBuff

        int 21h

        

        puts messageCR

        

        push bx

        push cx

        call checkNumber

        cmp ax, 0

        je printInvalid        

        call atoi

        pop cx

        pop bx

        mov [bx], ax

        inc bx

        inc bx

        dec cx

        jmp startLoop

    endLoop:

    

    mov bx, offset numberCount

    xor cx, cx

    mov cl, [bx]

    dec cx

    mov bx, offset numberArray

    xor dx, dx

    startCompare:

        cmp cx, 0

        je endCompare

        dec cx

        push bx

        mov ax, [bx]

        push ax 

        add bx, 2

        mov ax, [bx]

        push ax

        call signedCompare

        pop bx

        cmp ax, 0x01

        jl printRandom

        je compareGreater

        jg compareLess

        add bx, 2

        jmp startCompare

        compareGreater:

            or dx, 0x01

            add bx, 2

            jmp startCompare 

        compareLess:       

            or dx, 0x02

            add bx, 2

            jmp startCompare

    endCompare:

    cmp dx, 0x01

    je printDecreasing

    cmp dx, 0x02

    je printIncreasing

    jmp printRandom

    

printIncreasing:    

    

    puts messageIncreasing    

    jmp programEnd   

    

printDecreasing:

   

    puts messageDecreasing  

    jmp programEnd    

    

printRandom:

   

    puts messageRandom   

    jmp programEnd    

    

printInvalid:

    

    puts messageInvalid   

    jmp programEnd  

      

error:

    

    puts errorMessage   

    jmp programEnd 

       

programEnd:

    mov ah, 4Ch

    int 21h                     

end start 