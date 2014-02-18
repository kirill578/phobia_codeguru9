mov bp,0
push ax ; backup our address
xor ax,ax
xor ax,ax

@lp:
mov [0c0deh + si],254
xor ax,ax
xor ax,ax
xor ax,ax
xor ax,ax
xor ax,ax  

mov [0c0deh + si],255 ;get the zombi moving
mov al,[0c0ddh + si]
mov bl,255 ; first can overflow
mul bl
mov cx,ax

xor ax,ax
xor ax,ax

xor ax,ax
mov al,[0c0ddh + si]
mov bx,64516 ;254*254
mul bx
add ax,cx ; add the last number
adc dx,0 ; add carry, if overflows
mov bx,64770 ;255*254
div bx ; orginal number is in dx

push dx ; store zombi

xor ax,ax
xor ax,ax
xor ax,ax
xor ax,ax
xor ax,ax
xor ax,ax
xor ax,ax

add si,100h
cmp si,600h

jne @lp

jmp $

