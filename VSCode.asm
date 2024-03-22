.model small
.stack 100h
.data
    msg         db 'Binary Number: $'
    decimalNum  dw 36     ; Example decimal number to convert

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ax, decimalNum          ; Load the decimal number to convert
    mov bx, 2                   ; Divisor for binary conversion
    mov cx, 16                  ; Maximum number of digits

    sub sp, 16                  ; Allocate space on the stack for binary digits

binaryLoop:
    xor dx, dx                  ; Clear dx for division
    div bx                      ; Divide by 2
    add dl, '0'                 ; Convert remainder to ASCII
    push dx                     ; Push binary digit onto the stack
    dec cx                      ; Decrement loop counter
    test ax, ax                 ; Check if quotient is zero
    jnz binaryLoop              ; If not, continue looping

    ; Ensure that there are at least 16 binary digits in the stack
    mov dx, '0'                 ; Initialize dx with '0' for padding
    mov si, cx                  ; Counter for padding zeros

printPaddingZeros:
    cmp si, 0                   ; Check if there are remaining padding zeros
    jle printBinaryLoop         ; If not, jump to printing binary digits
    mov ah, 02h                 ; Display character function
    int 21h                     ; Display padding zero
    dec si                      ; Decrement padding zeros counter
    jmp printPaddingZeros      ; Loop until all padding zeros are output

printBinaryLoop:
    pop dx                      ; Pop binary digit from the stack
    mov ah, 02h                 ; Display character function
    int 21h                     ; Display binary digit
    loop printBinaryLoop        ; Loop until all digits are printed

    mov ah, 4ch                 ; Exit program
    int 21h

main endp
end main
