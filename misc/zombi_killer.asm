mov [0c0ddh],0ffh
push cs
push cs
push cs
push cs
mov [0c0deh],80h
push cs
push cs
push cs
push cs
mov bl,[0c0ddh]
mov cx,512
@l:
cmp [bx],0eh
jz @found
add bx,80h
loop @l
@found:
add bx,17h
mov [bx],0xcc