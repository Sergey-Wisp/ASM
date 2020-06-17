.MODEL small
.STACK 100h
.DATA
msg1 DB "Enter string: ",0Dh,0Ah,'$'
msg2 DB 0Dh,0Ah,"Enter string to delete: ",0Dh,0Ah,'$'
msg3 DB 0Dh,0Ah,"Result: ",0Dh,0Ah,'$'
max_length equ 203
 
str1 DB max_length dup('$')
str2 DB max_length dup('$')
i dw 0
     
.CODE   

strin proc
mov ah, 0Ah
int 21h
ret
strin endp; ��������� ����� ������ �� ����������
 
 
strout proc
    mov ah, 09h
    int 21h
    ret         
strout endp; ��������� ������ ������ �� ���������� 

begin:
    mov ax, @data
    mov ds, ax
    mov es,ax
    xor ax,ax; ���������� ������ � ds,es � ������ ax
    mov [str1], 200        
    mov [str2], 200; ���������� ������������ ������

    lea dx, msg1 
    call strout
 
    mov dx, offset str1
    call strin   
    mov [str1[205]], '$'; ���� �������� ������ � �������������� ���������� ����� ������
 
 
    lea dx, msg2 
    call strout
 
    mov dx, offset str2 
    call strin
    mov [str2[205]], '$'; ���� ����� ��� �������� � �������������� ���������� ����� ������

    mov di, 0
    mov si, 0;������� ������ �����

    findSubstringLen: 
        cmp [str2[si]], '$'
        je lenFound
        inc si
        jmp findSubstringLen; � si ���� ����� ������ � ���������� ������
    lenFound:
        mov dx, si 
        sub dx, 3; ���������� ������ ������� ������ � dx 
        mov si, 1; �������� ������� 
    findNextWord: 
        skipSpaces:   
            inc si
            cmp [str1[si]], '$'
            je output
            inc si
            cmp [str1[si]], '$'
            je output
            dec si
            cmp [str1[si]], ' ' 
        je skipSpaces; �������� �� ���������� �������, �� ������ ������� ����� ������� � �� ����� ������

;������ � ������ ������ �����, si - ������ ������
    compareWords:
        mov cx, si 
        mov i, 0

    findEnd:
        inc i
        inc si
        cmp [str1[si]], '$'
        je endFound  
        cmp [str1[si]],' ' 
        je spaceFound
        jmp findEnd ;������������� �������� ����� - si - ������ ���������� ������� �� ��������� �������� ����� � i - ������ �����

    endFound:
        dec i
        dec si ; ������ ������ ����������
        spaceFound: 
        dec si
        cmp i,dx
        jne findNextWord; ���������� ������ �������� ����� � �������� ���� �� ������� �� ���� ������ ������ � ������� ��� �����
        mov ax, si
        mov si, cx
        mov di, 2 ;ax - ��������� ������ si - ������ ������ �������� �����, di - ������ ������ ������� ������
        compareSymbols:  
            cmp i, 0
            je wordFound; ���� ������ � ����� ����� � ��� ������������ �������� ����� �� ����� ��� �������
            mov bl,[str2[di]]    
            cmp [str1[si]], bl
            jne wordIsWrong; ��������� �����������, ���� �� ������� �� ��� �� ����. �����
            inc si
            inc di
            dec i ;����������� ������
        jmp compareSymbols

        wordIsWrong:
            mov si, ax
            jmp findNextWord;���� ����� �� ���������� �� ������������ ����� ������� ������� � �.�

        wordFound:
            mov si, ax
            inc si ; si - ����. ������ ����� ����� �������� �����
            mov di, cx ; di - ������ �������� �����

        moveSymbols:
            mov bl,str1[si] 
            mov str1[di],bl
            dec si ; ���������� ������ � ��������� �� ����� ������
            cmp [str1[si]], '$'
            je moveComplete; ���� ������ ����� ������ - ������� �� ����� 
        add si, 2
        inc di 
        jmp moveSymbols  ;������������ ��� ������� �� ����� ������

        moveComplete: 
            mov si, cx ;��������� � ���������� �����
        jmp findNextWord

    output: ;����� ������
        lea dx, msg3
        call strout
        mov dx, offset str1[2]
        call strout 
 
    _end:
        mov ah, 4ch
        int 21h

end begin