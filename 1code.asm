.model tiny
.code
org 100h 

jmp start

print_string macro string
    mov ah, 09h 
    mov dx, offset string
    int 21h
endm

start: 
  
print_string message_1
print_string message_2
print_string message_3

ret   

message_1 db "Hello World!", 0Dh, 0Ah, '$'
message_2 db "Hello World!", 0Dh, 0Ah, '$'
message_3 db "Hello World!", 0Dh, 0Ah, '$'

end start 

