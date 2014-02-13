@start:
call @clear_input
push ax
push cs
pop es
mov di,00000h
mov ax, 0679h
mov dx,0F3F6h
mov bx,00279h
mov cx,0c486h
int 87h
pop ax

mov bx,2

@get_a_zombie:

call @clear_input
call @clear_output
call @clear_input

mov cx,6
mov di,0c0ddh
@find_infected:
cmp [di],1
jne @found
add di,100h
loop @find_infected
jmp @not_found
@found:
mov dh,[di]
mov [di+1],80h
call @clear_output
test al,al ; might not be ready
test al,al
test al,al
test al,al
mov dl,[di]

@attack:
add dx,17h +4h 
std

mov cx,2
@attack_loop:
mov di,dx
mov si,ax
add si,@jmpcode-@start +4h
movsw
movsw
movsw 
add dh,80h
loop @attack_loop

dec bx
jnz @get_a_zombie

@not_found:
jmp $ ; stay here

@clear_input:
mov [0c0deh],1
mov [0c1deh],1
mov [0c2deh],1
mov [0c3deh],1
mov [0c4deh],1
mov [0c5deh],1
ret
@clear_output:
mov [0c0ddh],1
mov [0c1ddh],1
mov [0c2ddh],1
mov [0c3ddh],1
mov [0c4ddh],1
mov [0c5ddh],1
ret
@jmpcode:
jmp 1000h:01234h
@end: