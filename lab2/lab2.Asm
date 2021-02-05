.386
.model flat,STDCALL
option casemap :none ;case sensitive
include lab2.inc
include RADbg.inc
.code
Begin:
call main

invoke ExitProcess,NULL

month proc nmonth:dword
	
	mov edx,nmonth
	shl edx,2  ; edx=edx*4
	lea esi,months
	add esi,edx
ret 

month endp


createFormat proc
LOCAL Time:SYSTEMTIME
invoke GetLocalTime,addr Time
xor eax,eax
mov ax,Time.wMinute
push eax
mov ax,Time.wHour
push eax
mov ax,Time.wYear
push eax
mov Save_esp,esp 
invoke month,Time.wMonth
mov esp, Save_esp
push [esi]
mov ax,Time.wDay
push eax
push offset formatFile
push offset buf
call wsprintf
ret

createFormat endp

main proc
LOCAL fhandle:dword
call createFormat
invoke MoveFile,addr file,addr buf
ret

main endp

end Begin