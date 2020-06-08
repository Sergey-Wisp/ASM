                                                  ;CSEG segment
 ;assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
 .model tiny

.code
 org 100h
 start:  ;--------------------------------------------------------------------------------
	mov dx, offset message
	mov ah, 09h
	int 21h
	
	jmp main
	
inputNumber proc   ;;-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-i?ioaao?a aaiaa-_-_-_-_-_-_-_-_-_-_-_-

	;push bx
    ;push cx
    ;push dx
    ;push si  
	;push di
	
again:
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor di, di
	xor si, si
	xor dx, dx
	
	mov dx, offset message2
	mov ah, 09h
	int 21h
	xor dx, dx
	
	mov ah, 0Ch
	mov al, 0Ah
	mov dx, offset intNumb
	int 21h  
	MOV 	DI, 	offset intNumb	;DI = aa?an aooa?a
	MOV 	BX, 	0h		        ;AO = 0		
	MOV 	BL, 	[DI+1]		    ;BL = aeeia no?iee
	MOV 	BYTE PTR [DI+BX+2], '$'	;DI+BX+2 - aa?an, eioi?ue neaaoao
	mov dx, 10
	mov ah, 2h
	int 21h
	mov dx, 13
	int 21h
		
	mov cl, [di+1]
	mov si, offset intNumb[2] ; <–– iiiauaai aa?an
	call atoi
	cmp error, 1
	je again
	

endOfProc:	
	;pop di
	;pop si
    ;pop dx 
    ;pop cx
    ;pop bx
    
    ret
inputNumber endp            ;;-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-eiiao i?ioaao?u aaiaa-_-_-_

atoi  proc                  ;; -_-_-_-_-_-_-_-_-_-_-_-_-_-_-i?ioaao?a eiiaa?oe?iaaiey-_-_-
	mov error, 0
	mov isNegative, 0
    xor bx, bx
    xor dx, dx   
getNumberLength:
;cx = length  
    xor ax, ax
     mov di, 10
     xor bh, bh
convert:
	dec cl
	mul di
	mov bl, [si]
	cmp bl, '-'
	je negativeNumber
	;mul di
	cmp bl, 30h
	jl invalidInput
	cmp bl, 39h
	jg invalidInput
	sub bl, 30h	
	add ax, bx
	mov bl,80h
	and bl, ah
	cmp bl, 0
	jne invalidInput
	;jс  invalidInput
	inc si
	  cmp cl, 0
    jne convert
 ;   cmp isNegative, 1
 ;  je invert
    jmp addToArray
;invert:
;	neg ax
;	jo  invalidInput
;	jmp addToArray  
negativeNumber:  
    neg ax
loopNegative:
	inc si
	dec cl
	mul di
	mov bl, [si]
	cmp bl, '-'
	je negativeNumber
	;mul di
	cmp bl, 30h
	jl invalidInput
	cmp bl, 39h
	jg invalidInput
	sub bl, 30h
	sub ax, bx ;; ñäåëàë ìèíóñ, â ýòîì ìåñòå ÷òî-òî ïîìåíÿòü))
	cmp ax, '0'
	jg invalidInput
	  cmp cl, 0
    jne loopNegative
 ;   cmp isNegative, 1
 ;  je invert
    jmp addToArray
	;mov isNegative, 1
;   jmp convert
	
addToArray:
	mov si, newElementPosition
	mov mas[si], 0
    mov mas[si], ax
    add newElementPosition, 2
    jmp endOfAtoi
    
invalidInput:
	mov dx, offset message3
	mov ah, 09h
	int 21h 
	mov error, 1
	ret
	
endOfAtoi:  
      ret 
atoi  endp;=====================================EIIAO I?IOAAO?U EIIAA?OA==================
checkLocationOfElements proc
	push bx
    push cx
    push dx
    push si  
    
	xor cx, cx
	mov cx, 10
	mov NumberOfElements, number
	mov newElementPosition, 0
checkLocation:
	dec NumberOfElements
	mov si, newElementPosition
	mov bx, mas[si]
	mov ax, mas[si + 2]
	cmp bx, ax
	jg Bigger
	cmp bx,ax 
	jl Lower
	jmp resultDifferent
	
Bigger:
	dec NumberOfElements
	mov si, newElementPosition
	mov bx, mas[si]
	mov ax, mas[si + 2]
	cmp bx, ax
	jle resultDifferent
	add newElementPosition, 2
	cmp NumberOfElements, 0
	jne Bigger
	mov dx, offset result2
	mov ah, 09h
	int 21h
	pop si
    pop dx 
    pop cx
    pop bx
	ret

Lower:
	dec NumberOfElements
	mov si, newElementPosition
	mov bx, mas[si]
	mov ax, mas[si + 2]
	cmp bx, ax
	jge resultDifferent
	add newElementPosition, 2
	cmp NumberOfElements, 0
	jne Lower
	mov dx, offset result3
	mov ah, 09h
	int 21h
	pop si
    pop dx 
    pop cx
    pop bx
	ret


resultDifferent:
	mov dx, offset result1
	mov ah, 09h
	int 21h
	pop si
    pop dx 
    pop cx
    pop bx
	ret	


    ret
checkLocationOfElements endp
main:             ;======================================MAIN=============================
	mov cx, 10
	mov NumberOfElements, number
repeat:
	dec NumberOfElements
	call inputNumber
	cmp NumberOfElements, 0
	jne repeat
	
	call checkLocationOfElements
	jmp end
end:
int 20h	

;-------------------------------------data------------------------------------------------
message db 'Please, enter element of the array:', 0Ah, 0Dh,'$'
message2 db 'next element:', 0Ah, 0Dh, '$'
message3 db 'incorrect input! try again', 0Ah, 0Dh, '$'
result1 db 'varios!', 0Ah, 0Dh, '$'
result2 db 'Desscending!', 0Ah, 0Dh, '$'
result3 db 'Ascending!', 0Ah, 0Dh, '$'
intNumb db 254 DUP (36), '$'
mas dw number dup (0)
number equ 10
newElementPosition dw number
NumberOfElements dw 0
error dw 0
spaceSymbol db ' ', 0Ah, 0Dh, '$'
endSymbol db '$', 0Ah, 0Dh, '$'
isNegative dw 0
;CSEG ends
end start