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
strin endp; процедура вводы строки из клавиатуры
 
 
strout proc
    mov ah, 09h
    int 21h
    ret         
strout endp; процедура выводы строки из клавиатуры 

begin:
    mov ax, @data
    mov ds, ax
    mov es,ax
    xor ax,ax; запихиваем данные в ds,es и чистим ax
    mov [str1], 200        
    mov [str2], 200; записываем максимальный размер

    lea dx, msg1 
    call strout
 
    mov dx, offset str1
    call strin   
    mov [str1[205]], '$'; ввод исходной строки и принудительное добавление конца строки
 
 
    lea dx, msg2 
    call strout
 
    mov dx, offset str2 
    call strin
    mov [str2[205]], '$'; ввод слова для удаления и принудительное добавление конца строки

    mov di, 0
    mov si, 0;инлексы начала строк

    findSubstringLen: 
        cmp [str2[si]], '$'
        je lenFound
        inc si
        jmp findSubstringLen; в si ищем конец строки и записываем размер
    lenFound:
        mov dx, si 
        sub dx, 3; записываем размер ИСКОМОЙ строки в dx 
        mov si, 1; обнулили счётчик 
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
        je skipSpaces; проверка на лидирующие пробелы, на лишние пробелы между словами и на конец строки

;пришли к началу нового слова, si - индекс начала
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
        jmp findEnd ;обрабатыываем текущеее слово - si - индекс следующего символа за последним символом слова а i - размер слова

    endFound:
        dec i
        dec si ; лишний символ откидываем
        spaceFound: 
        dec si
        cmp i,dx
        jne findNextWord; сравниваем размер текущего слова и ИСКОМОГО если не совпали то нету смысла чекать и скипаем это слово
        mov ax, si
        mov si, cx
        mov di, 2 ;ax - последний символ si - первый символ текущего слова, di - индекс начала ИСКОМОЙ строки
        compareSymbols:  
            cmp i, 0
            je wordFound; если пришли к концу слова и оно соотвествует ИСКОМОМУ слову то будем его удалять
            mov bl,[str2[di]]    
            cmp [str1[si]], bl
            jne wordIsWrong; проверяем посимвольно, если не совпали то идём на след. слово
            inc si
            inc di
            dec i ;итерируемся дальше
        jmp compareSymbols

        wordIsWrong:
            mov si, ax
            jmp findNextWord;если слово не правильное то переписываем конец скипаем пробелы и т.д

        wordFound:
            mov si, ax
            inc si ; si - след. символ после конца ТЕКУЩЕГО слова
            mov di, cx ; di - начала ТЕКУЩЕГО СЛОВА

        moveSymbols:
            mov bl,str1[si] 
            mov str1[di],bl
            dec si ; переписали символ и проверяем на конец строки
            cmp [str1[si]], '$'
            je moveComplete; если найден конец строки - выходим из цикла 
        add si, 2
        inc di 
        jmp moveSymbols  ;перекидываем все символы до конца строки

        moveComplete: 
            mov si, cx ;переходим к следующему слову
        jmp findNextWord

    output: ;вывод ответа
        lea dx, msg3
        call strout
        mov dx, offset str1[2]
        call strout 
 
    _end:
        mov ah, 4ch
        int 21h

end begin