sensor_d = 0x27
jump_d = 0x200
killer_loop_count = 10

push_attack_start_location = 0x0000

@begin:
std
call @clear_input
push es
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

mov cx,2
@attack_loop:
mov di,dx
mov si,ax
add si,@jmpcode-@begin +4h
movsw
movsw
movsw 
add dh,80h
loop @attack_loop

dec bx
jnz @get_a_zombie

@not_found:
jmp @end_zombi_stuff

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

@end_zombi_stuff:   
cld
pop es
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
mov [bp],0xcc
mov [bp],0xcc
mov [bp],0xcc
mov [bp],0xcc
mov [bp],0xcc
mov [bp],0xcc
mov [bp],0xcc
mov [bp],0xcc
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