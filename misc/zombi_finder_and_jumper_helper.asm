std
push cs
pop es
mov di,00000h
mov ax, 0679h
mov dx,0F3F6h
mov bx,00279h
mov cx,0c486h
int 87h
jmp $