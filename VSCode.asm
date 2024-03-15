.model small
.data
    MESSAGE DB "ENTER A NUMBER (0-9): $"
    MESSAGE1 DB "The number is: $"
.code
.startup
    mov AH, 09h       ; Display "ENTER A NUMBER: "
    mov DX, offset MESSAGE
    int 21h

    mov AH, 01h       ; Input character
    int 21h

    sub AL, 30h       ; Convert ASCII character to numeric value

    mov BL, AL        ; Store the entered number

    mov AH, 09h       ; Display "The number is: "
    mov DX, offset MESSAGE1
    int 21h

    mov DL, BL        ; Move the number to DL
    add DL, 30h       ; Convert it to ASCII character

    mov AH, 02h       ; Display the number
    int 21h

    mov AH, 02h       ; Display carriage return
    mov DL, 0Dh       ; ASCII code for carriage return
    int 21h

    mov DL, 0Ah       ; Display line feed
    int 21h

    mov AH, 4ch       ; Exit program
    int 21h

end

