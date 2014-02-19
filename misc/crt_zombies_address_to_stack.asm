mov bp,0
push ax ; backup our address
xor ax,ax
xor ax,ax

@lp:
mov [0c0deh + si],254
xor ax,ax ; wait
xor ax,ax ; wait
xor ax,ax ; wait
xor ax,ax ; wait
xor ax,ax ; wait  

mov [0c0deh + si],255 ;get the zombi moving
mov al,[0c0ddh + si]
mov bl,255 ; first cannot overflow
mul bl
mov cx,ax

xor ax,ax ; wait
xor ax,ax ; wait

xor ax,ax
mov al,[0c0ddh + si]
mov bx,64516 ;254*254
mul bx
add ax,cx ; add the last number
adc dx,0 ; add carry, if overflows
mov bx,64770 ;255*254
div bx ; orginal number is in dx

mov di,dx

mov word [di +17h +4],0010h ; write backward
mov word [di +17h +2],0012h
mov word [di +17h],34eah

mov word [di + 8000h +17h +4],0010h ; write backward
mov word [di + 8000h +17h +2],0012h
mov word [di + 8000h +17h],34eah

xor ax,ax ; wait

add si,100h
cmp si,600h

jne @lp

jmp $

