.model small
.stack 100h
.data
    decimalNum  dw -36     ; Пример десятичного числа для преобразования
    isNegative  db ?

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ax, decimalNum          ; Загрузка десятичного числа для преобразования
    mov bx, 2                   ; Делитель для преобразования в двоичную систему
    mov cx, 15                  ; Максимальное количество разрядов
    mov di, 0

    ; Проверка на отрицательное число
    mov isNegative, 0           ; Предполагаем, что число положительное
    cmp ax, 0                   ; Сравнение с нулем
    jge skipNegativityCheck     ; Если число больше или равно нулю, пропустить установку флага
    mov isNegative, 1           ; Установить флаг отрицательности
    neg ax                      ; Взять модуль числа

skipNegativityCheck:
    
    sub sp, 15                  ; Выделение места в стеке для хранения двоичных разрядов

binaryLoop:
    xor dx, dx                  ; Очистка dx перед делением
    div bx                      ; Деление на 2
    add dl, '0'                 ; Преобразование остатка в ASCII
    push dx                     ; Помещение двоичного разряда в стек
    dec cx                      ; Уменьшение счетчика цикла
    add di,1
    test ax, ax                 ; Проверка, равен ли частное нулю
    jnz binaryLoop              ; Если нет, продолжить цикл

    ; Убедимся, что в стеке есть как минимум 15 двоичных разрядов
    mov dx, '0'                 ; Инициализация dx с '0' для заполнения нулями
    mov si, cx                  ; Счетчик для нулей

    ; Вывод отрицательности, если необходимо
    cmp isNegative, 1           ; Compare the value of isNegative with 1
    jne notNegative             ; Jump to notNegative if isNegative is not equal to 1

negativeNumber:
    mov dl, '1'             ; If the number is negative, set the minus sign
    mov ah, 02h             ; Function for character output
    int 21h                 ; Output the minus sign

notNegative:
    mov dl, '0'             ; If the number is not negative, set '0'
    mov ah, 02h             ; Function for character output
    int 21h                 ; Output '0'

printPaddingZeros:
    cmp si, 0                   ; Проверка оставшихся нулей
    jle printBinaryLoop         ; Если нет, перейти к выводу двоичных разрядов
    mov ah, 02h                 ; Функция вывода символа
    int 21h                     ; Вывод нуля
    dec si                      ; Уменьшение счетчика нулей
    jmp printPaddingZeros       ; Цикл до вывода всех нулей

printBinaryLoop:
    pop dx                      ; Extract a binary digit from the stack
    mov ah, 02h                 ; Function for character output
    int 21h                     ; Output the binary digit
    dec di
    cmp di, 0                   ; Compare di with 0
    jg printBinaryLoop          ; Jump back to printBinaryLoop if di is greater than 0


exitProgram:
    mov ah, 4ch                 ; Выход из программы
    int 21h

main endp
end main
