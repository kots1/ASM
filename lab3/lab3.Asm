.386
.model flat,STDCALL
option casemap :none  ;case sensitive

include lab3.inc
include RADbg.inc
.code
Begin:

	
	call main
	
invoke ExitProcess,NULL

Mem_Alloc proc Buf_Size:DWORD
add Buf_Size,4 ; виділяємо буфер на 4 байти більший
invoke GlobalAlloc,GMEM_MOVEABLE or GMEM_ZEROINIT,Buf_Size ; виділяємо область у динамічній пам’яті
push eax ; зберігаємо хендл області виділеного буфера у стек
invoke GlobalLock,eax ;фіксуємо у реальній
pop [eax] 	;Витягнемо зі стеку значення і запишемо у перші 4 байта виділеного масиву,
			;це значення є хенд області виділеної області
			;наступні Buf_Size байт використовуємо як масив
add eax,4 	;зсуваємо вказівних початку масиву на 4 байти, оскільки перші 4 байти

;заняті значенням хендлу буфера
ret ; виходимо з процедури
Mem_Alloc endp


Mem_Free proc DATA:DWORD
mov eax,DATA 	;копіюємо значення параметра процедури у регістр eax, параметром є
				;початкова (робоча) адреса буфера ( початок + 4 байти)
sub eax,4 		;пам`ятаємо, що перших 4 байти масиву - це хендл буфера
push [eax] 		;беремо чотирьох байтне значення по адресі, що лежить у регістрі eax, заносимо його у стек
invoke GlobalUnlock,eax ;розблоковуємо пам`ять (всю розміром Buf_Size+4)
call GlobalFree ;оскільки параметр вже у стеці, викликаємо процедуру без параметрів, за дапомогою інструкції
;call (знищуємо хендел буфера)
ret ;вихід з процедури
Mem_Free endp

main proc

call oFile
cmp eax,0
je @F
call keyFile
call result
invoke Mem_Free,pmem
call resultFile

invoke Mem_Free,pmem_file_read
invoke Mem_Free,pmem_key
invoke Mem_Free,pmem_result
@@:
invoke Mem_Free,pmem
	ret
main endp

result proc
	
	invoke Mem_Alloc,size_file
	mov pmem_result,eax
	mov edi, pmem_file_read
	mov esi,pmem_key
	mov ebx,pmem_result	
	mov ecx,size_file
@@:
	mov al,[edi]
	mov ah,[esi]
	xor al,ah
	mov  [ebx],al
	inc edi
	inc esi
	inc ebx
	loop @B
	ret

result endp

resultFile proc

invoke Mem_Alloc,sizeof OPENFILENAME
mov pmem,eax
mov edi,pmem
assume edi:ptr OPENFILENAME
mov [edi].lpstrFile,offset path_result
mov [edi].nMaxFile,260
mov [edi].lStructSize,sizeof OPENFILENAME
mov [edi].lpstrInitialDir,offset directory
invoke GetSaveFileName,edi
cmp eax,0
je @F
invoke CreateFile,addr path_result,GENERIC_WRITE,FILE_SHARE_READ,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
mov hfile,eax
invoke WriteFile,hfile, pmem_result,size_file,addr byte_writen,0
invoke CloseHandle,hfile
@@:
assume edi:dword
ret

resultFile endp

keyFile proc
	invoke Mem_Alloc,size_file
	mov pmem_key,eax
	invoke CreateFile,addr path_key,GENERIC_READ,FILE_SHARE_READ,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
	mov hfile,eax
	invoke ReadFile,hfile, pmem_key,size_file,addr byte_readed,0
	invoke CloseHandle,hfile
	ret

keyFile endp

oFile proc 	
invoke Mem_Alloc,sizeof OPENFILENAME
mov pmem,eax
mov edi,pmem
assume edi: ptr OPENFILENAME
invoke GetCurrentDirectory,260,addr directory
mov [edi].lpstrFile,offset path_file
mov [edi].nMaxFile,260
mov [edi].lStructSize,sizeof OPENFILENAME
mov [edi].lpstrInitialDir,offset directory
invoke GetOpenFileName,edi
cmp eax,0
je @F
invoke CreateFile,addr path_file,GENERIC_READ,FILE_SHARE_READ,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
mov hfile,eax
invoke GetFileSize,hfile,0
mov size_file,eax
invoke Mem_Alloc,size_file
mov pmem_file_read,eax
invoke ReadFile,hfile, pmem_file_read,size_file,addr byte_readed,0
invoke CloseHandle,hfile
@@:
assume edi: dword
ret

oFile endp
end Begin
