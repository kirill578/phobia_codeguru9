sensor_d = 0x27
jump_d = 0x200
killer_loop_count = 10

push_attack_start_location = 0x0000

@begin:
push ax
push es
push ds
pop es
mov cx, 0ceceh
mov dx, 08958h
mov ax, 087CDh
mov bx, 0ceceh  
int 87h
pop es
pop ax

add ax,@start-@begin
mov bp,ax ; bp points to the next attack point (escaped location)
mov dx,bp ; dx points to the current code
mov si,bp
mov cx,(@end-@start)/2
mov di,0
rep movsw

push ds ; public arena set to extra
push es ; private set to data
pop ds
pop es

push cs ; set stuck as public
pop ss

mov sp,push_attack_start_location
mov bx,0cch ; push attak

mov si,0
mov di,bp
movsw
jmp bp

@start:

movsw
movsw
movsw
movsw
movsw
mov cx,(@end_killing_block - @begin_killing_block)/2
rep movsw ; copy killing block

@begin_killing_block:
mov cx,killer_loop_count ; loop 10 times
@killing_loop:
mov [bp+58h],0xcc
mov [bp+58h],0xcc
mov [bp+58h],0xcc
mov [bp+58h],0xcc
mov [bp+58h],0xcc
mov [bp+58h],0xcc
mov [bp+58h],0xcc
mov [bp+58h],0xcc
loop @killing_loop
@end_killing_block:
movsw
movsw
movsw
movsw
mov cx,(@end-@final_copy)/2
rep movsw ; copy rest of the code

@final_copy:

mov bp,dx ; set next attack location to this code 
or bp,1 ; attck odd byes, where mamaliga and zorg, put movsw
xor si,si ; get ready for copy jump

; setup new sensors
mov [bp + (@checkloop-@start) + (@end-@checkloop) + sensor_d],al
mov [bp + (@checkloop-@start) - sensor_d],al
          
@checkloop:
push bx ; attck

cmp [bp + (@checkloop-@start) + (@end-@checkloop) + sensor_d],al
jne @foundAfter
cmp [bp + (@checkloop-@start) - sensor_d],al
je @checkloop:

@foundBefore:
sub dx,jump_d + jump_d
@foundAfter:
add dx,jump_d
@coping:
mov di,dx
movsw
call dx ; jmp and push 
call dx
@end:











@end_zombi:     


; all zombie code bellow
; wasting others int 87h
; they will find this, and not the zombi

;push cs
;pop es
;int 87h ; too far to be useful with int 87h
and ax,07fffh
@looop0:
push ax
mov bl,[0c0deh]
test bl,bl
jns @skip0:
div bl
mov [0c0ddh],ah
@skip0:
pop ax
jmp @looop0:

and ax,07fffh
@looop1:
push ax
mov bl,[0c1deh]
test bl,bl
jns @skip1:
div bl
mov [0c1ddh],ah
@skip1:
pop ax
jmp @looop1:

and ax,07fffh
@looop2:
push ax
mov bl,[0c2deh]
test bl,bl
jns @skip2:
div bl
mov [0c2ddh],ah
@skip2:
pop ax
jmp @looop2:

and ax,07fffh
@looop3:
push ax
mov bl,[0c3deh]
test bl,bl
jns @skip3:
div bl
mov [0c3ddh],ah
@skip3:
pop ax
jmp @looop3:

and ax,07fffh
@looop4:
push ax
mov bl,[0c4deh]
test bl,bl
jns @skip4:
div bl
mov [0c4ddh],ah
@skip4:
pop ax
jmp @looop4:

and ax,07fffh
@looop5:
push ax
mov bl,[0c5deh]
test bl,bl
jns @skip5:
div bl
mov [0c5ddh],ah
@skip5:
pop ax
jmp @looop5:
