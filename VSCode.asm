.model small
.stack 100h
.data
    ; Оголошення змінних
    decimalNum  dw -2   ; Приклад десяткового числа для перетворення
    isNegative  db ?

.code
main proc
    mov ax, @data
    mov ds, ax

    ; Завантаження десяткового числа для перетворення
    mov ax, decimalNum          

    ; Ініціалізація змінних
    mov bx, 2                   ; Дільник для перетворення в двійкову систему
    mov cx, 15                  ; Максимальна кількість розрядів
    mov di, 0

    ; Перевірка на від'ємне число
    mov isNegative, 0           ; Передбачаємо, що число додатне
    cmp ax, 0                   ; Порівняння з нулем
    jge skipNegativityCheck     ; Якщо число більше або дорівнює нулю, пропустити встановлення прапорця
    mov isNegative, 1           ; Встановити прапорець від'ємності
    neg ax                      ; Взяти модуль числа

skipNegativityCheck:
    
    ; Виділення місця в стеку для зберігання двійкових розрядів
    sub sp, 15                  

binaryLoop:
    ; Очищення dx перед діленням
    xor dx, dx                  
    ; Ділення на 2
    div bx                      
    ; Перетворення залишку в ASCII та поміщення його в стек
    add dl, '0'                 
    push dx                     
    ; Зменшення лічильника циклу
    dec cx                      
    ; Збільшення лічильника для рахування бітів
    add di, 1                   
    ; Перевірка, чи дорівнює частка нулю
    test ax, ax                 
    ; Продовження циклу, якщо частка не дорівнює нулю
    jnz binaryLoop              

    ; Ініціалізація dx з '0' для заповнення нулями
    mov dx, '0'                 
    ; Лічильник для нулів
    mov si, cx                  

    ; Вивід від'ємності, якщо потрібно
    cmp isNegative, 1           
    ; Вивід знаку мінус, якщо число від'ємне
    jne notNegative             
    mov dl, '1'             
    mov ah, 02h             
    int 21h                 

notNegative:
    ; Вивід '0', якщо число не від'ємне
    mov dl, '0'             
    mov ah, 02h             
    int 21h                 

printPaddingZeros:
    ; Перевірка залишившихся нулів
    cmp si, 0                   
    ; Якщо немає, перейти до виводу двійкових розрядів
    jle printBinaryLoop         
    ; Вивід нуля
    mov ah, 02h                 
    int 21h                     
    ; Зменшення лічильника нулів
    dec si                      
    ; Цикл до виводу всіх нулів
    jmp printPaddingZeros       

printBinaryLoop:
    ; Витягнення двійкового розряду зі стеку
    pop dx                      
    ; Вивід двійкового розряду
    mov ah, 02h                 
    int 21h                     
    ; Порівняти di з 0
    dec di                      
    ; Повернутися до printBinaryLoop, якщо di більший за 0
    jg printBinaryLoop          

exitProgram:
    ; Вихід з програми
    mov ah, 4ch                 
    int 21h
main endp

end main
