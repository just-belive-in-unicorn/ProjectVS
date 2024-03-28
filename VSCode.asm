.model small
.stack 100h

.data
readString dw 101 DUP (?)     ; Збільшити розмір буфера, щоб врахувати нуль-термінацію
numberArray dw 10000 DUP(?)   ; Змінити dw на db для визначення масиву байтів для зберігання чисел
arrayIndex dw 0               ; Індекс, що відстежує поточну позицію в масиві
oneChar db 0  
quantityOfNumbers dw 0
MAX_READSTRING_SIZE equ 101

.code

main proc
    call read
    call sort

main endp

read proc
read_next:
    mov ah, 3Fh                ; DOS function to read from a file or device
    mov bx, 0h                 ; Standard input handle
    mov cx, 1                  ; Read 1 byte
    mov dx, offset oneChar     ; Buffer to store the read character
    int 21h                    ; Call DOS interrupt

    ; Check for end-of-file (EOF)
    cmp ax, 0                  ; Check if AX is zero (AX holds the number of bytes read)
    je done                    ; Jump to done if end-of-file is reached

    ; Check for whitespace (space)
    cmp oneChar, ' '           ; Compare the character with ASCII value of space (' ')
    jnz read_continue          ; Jump to read_continue if the character is not a space

    ; Process the array
    inc quantityOfNumbers               ; Increment counter (for example)
    call atoi

    ; Clear the arrayIndex to start fresh for the next string
    mov arrayIndex, 0

    jmp read_next

read_continue:
    ; Input the character into the array if it's not whitespace
    mov si, offset readString  ; Load the base address of readString into SI
    add si, arrayIndex         ; Add arrayIndex to SI to calculate the effective address
    cmp arrayIndex, MAX_READSTRING_SIZE   ; Перевірка на переповнення буфера
    jge buffer_overflow               ; Перейти, якщо переповнення буфера
    mov bl, oneChar            ; Move the character to BL register
    mov [si], bl               ; Store the character from AL into the memory address pointed by SI
    inc arrayIndex             ; Increment the array index
    jmp read_next

buffer_overflow:
    ; Handle buffer overflow (for example, by printing an error message)
    ; Then, clear the arrayIndex to continue reading characters
    mov arrayIndex, 0
    jmp read_next

done:
    ; Code to execute when EOF is reached

read endp

;/////////////////////////////

atoi proc
    xor ax, ax                ; Ініціалізувати поточне значення нулем
    xor bx, bx                ; Ініціалізувати прапорець знаку на 0 (позитивний)
    xor cx, cx
    xor dx, dx
    xor si, si

    mov di, offset readString ; Встановити DI на початок рядка
    mov bl, [di]              ; Отримати перший символ
    cmp bl, '-'               ; Перевірити, чи є число від'ємним
    jne continue              ; Якщо не від'ємне, пропустити встановлення прапорця знаку

    mov bx, 1                 ; Встановити прапорець знаку на 1 (від'ємний)
    inc di                    ; Перейти до наступного символу

continue:
convert:
    mov bl, [di]              ; Отримати поточний символ
    test bl, bl               ; Перевірити на нуль-термінатор
    jz done_atoi

    cmp bl, '0'               ; Будь-що менше '0' є недійсним
    jl error
    cmp bl, '9'               ; Будь-що більше '9' є недійсним
    jg error

    sub bl, '0'               ; Перевести з ASCII в десяткову систему числення
    ; Помножити поточне значення на 10
    mov dx, 0
    mov cx, 10
    mul cx
    ; Додати поточну цифру до значення
    add ax, bx

    inc di                    ; Отримати адресу наступного символу
    jmp convert

error:
    ; Обробити помилку (наприклад, вивести повідомлення про помилку)
    ; Потім повернути код помилки
    mov ax, -1
    ret

done_atoi:
    ; Перевірити, чи число від'ємне
    test bx, bx
    jnz negative_result       ; Якщо від'ємне, виконати доповнення двійкового додатку
    ; Зберегти значення в поточному елементі масиву
    mov word ptr [numberArray + si], ax
    inc si                    ; Перейти до наступного елемента масиву
    ret

negative_result:
    neg ax                    ; Виконати доповнення двійкового додатку для від'ємних чисел
    ; Зберегти значення в поточному елементі масиву
    mov word ptr [numberArray + si], ax
    inc si                    ; Перейти до наступного елемента масиву
    ret

atoi endp

sort proc
    xor ax, ax                ; Ініціалізувати поточне значення нулем
    xor bx, bx                ; Ініціалізувати прапорець знаку на 0 (позитивний)
    xor cx, cx
    xor dx, dx
    mov cx, word ptr quantityOfNumbers
    dec cx  ; count-1
    outerLoop:
    push cx
    lea si, numberArray
innerLoop:
    mov ax, [si]
    cmp ax, [si+2]
    jl nextStep
    xchg [si+2], ax
    mov [si], ax
nextStep:
    add si, 2
    loop innerLoop
    pop cx
    loop outerLoop
    ret

sort endp

end
