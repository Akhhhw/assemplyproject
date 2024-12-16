.model small
.data
    input db "HELLO, WORLD!", 0  ; Input string to encrypt (null-terminated)
    shift db 3                  ; Encryption key (shift value)
    output db 50 dup('$')       ; Buffer for encrypted string
    msg db "Encrypted String: $"

.code
main proc
    mov ax, @data               ; Initialize data segment
    mov ds, ax
    mov es, ax

    ; Step 1: Set up pointers
    lea si, input               ; SI points to the input string
    lea di, output              ; DI points to the output buffer
    mov cl, shift               ; Load the shift value into CL

encrypt_loop:
    mov al, [si]                ; Load the current character
    cmp al, 0                   ; Check for null terminator
    je display_result           ; If null, end the loop

    ; Step 2: Encrypt only alphabetic characters
    cmp al, 'A'                 ; Check if uppercase letter
    jl not_uppercase            ; If less, skip to non-alphabet handling
    cmp al, 'Z'
    jg not_uppercase            ; If greater, skip to lowercase check
    add al, cl                  ; Shift the uppercase letter
    cmp al, 'Z'                 ; Check for overflow
    jle store_char              ; If within bounds, store it
    sub al, 26                  ; Wrap around for uppercase letters
    jmp store_char

not_uppercase:
    cmp al, 'a'                 ; Check if lowercase letter
    jl store_char               ; If less, just store it
    cmp al, 'z'
    jg store_char               ; If greater, just store it
    add al, cl                  ; Shift the lowercase letter
    cmp al, 'z'                 ; Check for overflow
    jle store_char              ; If within bounds, store it
    sub al, 26                  ; Wrap around for lowercase letters

store_char:
    mov [di], al                ; Store the encrypted character in the output buffer
    inc si                      ; Move to the next character in the input
    inc di                      ; Move to the next position in the output buffer
    jmp encrypt_loop            ; Repeat the loop

display_result:
    mov byte ptr [di], '$'      ; Null-terminate the output string

    ; Step 3: Display the "Encrypted String" message
    lea dx, msg                 ; DX points to the message
    mov ah, 9                   ; DOS interrupt for printing strings
    int 21h

    ; Step 4: Display the encrypted string
    lea dx, output              ; DX points to the encrypted string
    mov ah, 9                   ; DOS interrupt for printing strings
    int 21h

    ; Exit the program
    mov ah, 4Ch                 ; DOS interrupt to terminate program
    int 21h

main endp
end main
