.model small
.stack 100h

.data
readString db 6 DUP (?)      ; Change dw to db to define a byte array for storing characters
numberArray db 10000 DUP(?) ; Change dw to db to define a byte array for storing numbers

.code

atoi proc
    xor ax, ax            ; Set initial total to 0
    xor bx, bx            ; Initialize sign flag to 0 (positive)

    mov bl, byte ptr readString[di] ; Retrieve the current character (use byte ptr for characters)
    cmp bl, '-'           ; Check if the number is negative
    je set_negative
    jmp continue

set_negative:
    mov bx, 1             ; Set sign flag to 1 (negative)
    inc di                ; Move to the next character
    jmp continue

continue:
convert:
    mov bl, byte ptr readString[di] ; Retrieve the current character
    test bl, bl           ; Check for \0
    jz done
    
    cmp bl, '0'           ; Anything less than '0' is invalid (use bl for the low byte of bx)
    jl error
    
    cmp bl, '9'           ; Anything greater than '9' is invalid
    jg error
     
    sub bl, '0'           ; Convert from ASCII to decimal 
    ; Multiply total by 10
    mov dx, 0
    mov cx, 10
    mul cx
    ; Add current digit to total
    add ax, bx            ; Use bl instead of bx here to add the current digit
    
    inc di                ; Get the address of the next character
    jmp convert

error:
    mov ax, -1            ; Return -1 on error
    ret

done:
    test bx, bx           ; Check if the number is negative
    jnz negative_result   ; If negative, take two's complement
    mov [numberArray + si], al ; Store the value in the current element of the array
    inc si                ; Move to the next element of the array (assuming byte elements)
    ret

negative_result:
    neg ax                ; Take two's complement for negative numbers
    mov [numberArray + si], al ; Store the value in the current element of the array
    inc si                ; Move to the next element of the array (assuming byte elements)
    ret

atoi endp

end
