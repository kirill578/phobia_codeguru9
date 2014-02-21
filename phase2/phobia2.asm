sensor_d = 0x27
jump_d = 0x200
killer_loop_count = 10

zombi_kill_self_after_x_jumps = 6
zombi_landing_address = 0xbea0
zombi_extra_sygment = 0x2500

zombi_connection_a = 0x7531
zombi_connection_b = 0x1357

push_attack_start_location = 0x7FFF

@begin:
push es

push cs
pop es

mov si,ax
add si,@zombi_code-@begin
mov di,zombi_landing_address
mov cx,(@end_zombi-@zombi_code)/2 + 1
rep movsw

pop es

mov bh,0 ; master live for 256 jumps

jmp @end_of_zombi_stuff
    
    
    
    

   
@zombi_code:

mov cx,20
@wait_zombi_too_quick:
loop @wait_zombi_too_quick 

mov bp,zombi_extra_sygment
mov es,bp
mov ax,zombi_landing_address

call @zombi_segment_switch
mov bl,[3FFh]
inc bl
mov [3FFh],bl
call @zombi_segment_switch

cmp bl,2 ; the second zombi is the zombi protector
je @zombi_protector

add ax,@help_master-@zombi_code
mov [3E0h],ax

@wait_for_master:
mov bx,[zombi_connection_a]
mov dx,[zombi_connection_b]
cmp bx,dx
jne @wait_for_master
cmp bx,0cccch
je @wait_for_master

add bx,@checkloop-@start - 4
mov si,bx ; backup master main loop
mov di,300h ; we store master in 300h
mov cx,(@end - @checkloop)/2 + 4
rep movsw 

mov ax,1000 ; self kill after 1000 protection cycles

@help_master:
call @zombi_segment_switch 

jmp @zombi_argent_code_skip
@zombi_segment_switch:
push ds
push es
pop ds
pop es                    
ret
@zombi_argent_code_skip:

mov cx,10
@beta_loop:
mov di,bx
mov si,300h ; we store master in 300h 
movsw
movsw
movsw
movsw
movsw
movsw
movsw
movsw
movsw
movsw
movsw
movsw
movsw
movsw
loop @beta_loop     

call @zombi_segment_switch

; TODO self kill
     
mov bx,[zombi_connection_a]
mov dx,[zombi_connection_b]
cmp bx,dx
jne @wait_for_master
cmp bx,0cccch
je @wait_for_master     

add bx,@checkloop-@start - 4

dec ax
jz @zombi_self_kill
     
jmp [3E0h]     

@zombi_protector:
mov bx,3 ; jump self kill counter

xor di,di
add ax,@help_master-@zombi_code
mov si,ax
mov cx,(@end_zombi-@help_master)/2 +1
rep movsw

@zombi_protector_setup_checkers:

mov di,ax

mov [di - 200h],al
mov [di + @help_master-@zombi_code + 200h],al

@zombi_protector_check_loop:
; TODO self kill
cmp [di - 200h],al
jne @zombi_protector_found_before
cmp [di + @help_master-@zombi_code + 200h],al
je @zombi_protector_check_loop
@zombi_protector_found_after:
@zombi_protector_found_before:

add ax,500h

call @zombi_segment_switch
mov di,ax
xor si,si
mov cx,(@end_zombi-@help_master)/2 +1
rep movsw

dec bx
jz @zombi_self_kill

mov [3E0h],ax ; set loop address for master protector

call @zombi_segment_switch

mov bp,ax
add bp,@zombi_protector_setup_checkers-@help_master
jmp bp
@zombi_self_kill:
int 3

@end_zombi:

@end_of_zombi_stuff:
add ax,@start-@begin
mov bp,ax ; bp points to the next attack point (escaped location)
mov dx,bp ; dx points to the current code
mov si,bp
add cx,(@end-@start)/2
mov di,0
rep movsw

push ds ; public arena set to extra
push es ; private set to data
pop ds
pop es

push cs ; set stuck as public
pop ss

mov sp,ax
sub sp,200h

mov ah,bh ; master can move 256 before killing self

mov bx,0cch ; push attak
         
cmp ah,0
jne @skip_fix:
and bp,0ff00h
add bp,000c0h
mov dx,bp           
@skip_fix:             
             
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
mov [bp+60H],0xcc
mov [bp+60H],0xcc
mov [bp+60H],0xcc
mov [bp+60H],0xcc
mov [bp+60H],0xcc
mov [bp+60H],0xcc
mov [bp+60H],0xcc
mov [bp+60H],0xcc
loop @killing_loop
@end_killing_block:
movsw
movsw
movsw
movsw
mov cx,(@end-@final_copy)/2
rep movsw ; copy rest of the code

@final_copy:

cmp bl,0cch
jne @skip_zombi_mastring
mov bp,0
mov word [bp + zombi_connection_a],dx ; ss set to arena
mov word [bp + zombi_connection_b],dx
@skip_zombi_mastring:

mov bp,dx ; set next attack location to this code 

and bp,0FFFEH ; support for buggy version
inc bp

xor si,si ; get ready for copy jump


dec ah
jz @kill_self

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
@kill_self: 
int 3
@end:     


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