org 100h

.code
    
jmp start

word db 200, 202 dup(?)
string db 200, 202 dup('$')

print macro message
    mov ah, 09h
    mov dx, offset message
    int 21h
endm

in_word macro
    mov ah, 0Ah
    mov dx, offset word
    int 21h
    
    mov ah, 2
    mov dl, 10
    int 21h              
endm

in_string macro
    mov ah, 0Ah
    mov dx, offset string
    int 21h
    
    mov ah, 2
    mov dl, 10
    int 21h    
endm

delete_word macro word
    
endm

start:  
     print message_1
     in_string
      
     print message_2
     in_word
ret 

message_1 db "Enter string: ", 0Ah, 0Dh, '$'
message_2 db "Enter word: ", 0Ah, 0Dh, '$'
message_3 db "New string(without word): ", 0Ah, 0Dh, '$'

end start