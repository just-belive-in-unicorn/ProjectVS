.MODEL SMALL
.STACK 100H
.DATA
    message DB 'Hi! THIS IS FIRST OUTPUT INTO CONSOL ON ASSSEMBLY      $'  ; Define a message with the character '0' followed by a null terminator
.CODE
MAIN PROC
    MOV AX, @DATA   ; Initialize DS to point to the data segment
    MOV DS, AX

    mov ah, 09h     ; DOS function to print a string
    mov dx, OFFSET message  ; Load the offset of the message string
    int 21h         ; Call DOS to print the message

    mov ah, 4ch     ; DOS function to exit the program
    int 21h         ; Call DOS to terminate the program
MAIN ENDP
END MAIN
