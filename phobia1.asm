sensor_d = 0x27
jump_d = 0x200
killer_loop_count = 10

push_attack_start_location = 0x0000

@begin:
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