sensor_d = 0x27
jump_d = 0x200
killer_loop_count = 10

push_attack_start_location = 0x0000

@begin:
mov bp,0 ; dont rememeber what it is
push ax ; backup our address
xor ax,ax ; wait
xor ax,ax ; wait

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

pop ax

@end_zombi_stuff:   
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

and bp,0FFFEH ; support for buggy version
inc bp

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