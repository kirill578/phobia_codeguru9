@start:
mov [0c0deh],1
mov [0c1deh],1
mov [0c2deh],1
mov [0c3deh],1
mov [0c4deh],1
mov [0c5deh],1

push ax
push cs
pop es
add ax,@end-@start
mov di,ax
mov ax, 0679h
mov dx,0F3F6h
mov bx,00279h
mov cx,0c486h
int 87h

mov [0c0ddh],0CCH
mov [0c1ddh],0CCH
mov [0c2ddh],0CCH
mov [0c3ddh],0CCH
mov [0c4ddh],0CCH
mov [0c5ddh],0CCH
 
call @delay

mov dh,[0c0ddh]
mov [0c0ddh],0CCH
cmp dh,0xCC
jne @f0

mov dh,[0c1ddh]
cmp dh,0xCC
jne @f1

mov dh,[0c2ddh]
cmp dh,0xCC
jne @f2

mov dh,[0c3ddh]
cmp dh,0xCC
jne @f3

mov dh,[0c4ddh]
cmp dh,0xCC
jne @f4

mov dh,[0c5ddh]
cmp dh,0xCC
jne @f5


@f0:
mov [0c0deh],0ffh
call @delay
mov dl,[0c0ddh]
jmp @attack 
@f1:
mov [0c1deh],0ffh
call @delay
mov dl,[0c1ddh]
jmp @attack 
@f2:
mov [0c2deh],0ffh
call @delay
mov dl,[0c2ddh]
jmp @attack 
@f3:
mov [0c3deh],0ffh
call @delay
mov dl,[0c3ddh]
jmp @attack
@f4:
mov [0c4deh],0ffh
call @delay
mov dl,[0c4ddh]
jmp @attack 
@f5:
mov [0c5deh],0ffh
call @delay
mov dl,[0c5ddh] 
@attack:
add dx,17h +4h 

pop ax

mov di,dx
mov si,ax
add si,@jmpcode-@start +4h
std
movsw
movsw
movsw
 
add dx,8000h
mov di,dx
mov si,ax
add si,@jmpcode-@start +4h
std
movsw
movsw
movsw

jmp $ ; stay here

@delay:
push ds
push ds; wait
push ds
push ds
pop ds
pop ds
pop ds
pop ds 
ret
@jmpcode:
jmp 1000h:01234h
@end: