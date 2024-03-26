.model small
.stack 100h

.data
readString db 101 DUP (?)     ; Increase buffer size to accommodate null termination
numberArray db 10000 DUP(?)   ; Change dw to db to define a byte array for storing numbers
arrayIndex dw 0               ; Index to keep track of the current position in the array
oneChar db ?  

.code

main proc
read_next:
    mov ah, 3Fh                ; DOS function to read from a file or device
    mov bx, 0h                 ; Standard input handle
    mov cx, 1                  ; Read 1 byte
    mov dx, offset oneChar     ; Buffer to store the read character
    int 21h                    ; Call DOS interrupt

    ; Check if end of input (Enter key pressed)
    or ax, ax
    jnz read_continue
    cmp oneChar, ' '           ; Compare the character with ASCII value of space (' ')
    jnz read_continue          ; Jump to read_continue if the character is not a space

    ; Process the array
    call atoi

    ; Clear the arrayIndex to start fresh for the next string
    mov arrayIndex, 0

    jmp read_next

read_continue:
    ; Input the character into the array if it's not whitespace
    mov si, offset readString  ; Load the base address of readString into SI
    add si, arrayIndex         ; Add arrayIndex to SI to calculate the effective address
    cmp arrayIndex, 100        ; Check for buffer overflow
    jge buffer_overflow        ; Jump if buffer overflow
    mov bl, oneChar            ; Move the character to BL register
    mov [si], bl               ; Store the character from AL into the memory address pointed by SI
    inc arrayIndex             ; Increment the array index
    jmp read_next

buffer_overflow:
    ; Handle buffer overflow (for example, by printing an error message)
    ; Then, clear the arrayIndex to continue reading characters
    mov arrayIndex, 0
    jmp read_next

main endp

atoi proc
    xor ax, ax                ; Set initial total to 0
    xor bx, bx                ; Initialize sign flag to 0 (positive)
    xor cx, cx
    xor dx, dx

    mov di, offset readString ; Set DI to point to the start of the string
    mov bl, [di]              ; Retrieve the first character
    cmp bl, '-'               ; Check if the number is negative
    jne continue              ; If not negative, skip setting the sign flag
    mov bx, 1                 ; Set sign flag to 1 (negative)
    inc di                    ; Move to the next character

continue:
convert:
    mov bl, [di]              ; Retrieve the current character
    test bl, bl               ; Check for null terminator
    jz done

    cmp bl, '0'               ; Anything less than '0' is invalid
    jl error
    cmp bl, '9'               ; Anything greater than '9' is invalid
    jg error

    sub bl, '0'               ; Convert from ASCII to decimal
    ; Multiply total by 10
    mov dx, 0
    mov cx, 10
    mul cx
    ; Add current digit to total
    add ax, bx

    inc di                    ; Get the address of the next character
    jmp convert

error:
    ; Handle error (for example, by printing an error message)
    ; Then, return an error code
    mov ax, -1
    ret

done:
    ; Check if the number is negative
    test bx, bx
    jnz negative_result       ; If negative, take two's complement
    ; Store the value in the current element of the array
    mov [numberArray + si], al
    inc si                    ; Move to the next element of the array
    ret

negative_result:
    neg ax                    ; Take two's complement for negative numbers
    ; Store the value in the current element of the array
    mov [numberArray + si], al
    inc si                    ; Move to the next element of the array
    ret

atoi endp

end
