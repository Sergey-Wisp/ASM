.model small 
.stack 100h

.data
message_1 db "Hello World!", 0Dh, 0Ah, '$'
message_2 db "Hello World!", 0Dh, 0Ah, '$'
message_3 db "Hello World!", 0Dh, 0Ah, '$'

.code
  
jmp start

print_string macro string
    mov dx, offset string
    mov ah, 09h
    int 21h
endm   

start: 
  
    mov ax, @data
    mov ds, ax
    
    print_string message_1
    print_string message_2
    print_string message_3
    
    mov ax,4C00h
    int 21h 

end start 