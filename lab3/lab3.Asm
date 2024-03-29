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
add Buf_Size,4 ; �������� ����� �� 4 ����� ������
invoke GlobalAlloc,GMEM_MOVEABLE or GMEM_ZEROINIT,Buf_Size ; �������� ������� � ��������� �����
push eax ; �������� ����� ������ ��������� ������ � ����
invoke GlobalLock,eax ;������� � ��������
pop [eax] 	;��������� � ����� �������� � �������� � ����� 4 ����� ��������� ������,
			;�� �������� � ���� ������ ������� ������
			;�������� Buf_Size ���� ������������� �� �����
add eax,4 	;������� �������� ������� ������ �� 4 �����, ������� ����� 4 �����

;����� ��������� ������ ������
ret ; �������� � ���������
Mem_Alloc endp


Mem_Free proc DATA:DWORD
mov eax,DATA 	;������� �������� ��������� ��������� � ������ eax, ���������� �
				;��������� (������) ������ ������ ( ������� + 4 �����)
sub eax,4 		;���`�����, �� ������ 4 ����� ������ - �� ����� ������
push [eax] 		;������ �������� ������ �������� �� �����, �� ������ � ������ eax, �������� ���� � ����
invoke GlobalUnlock,eax ;������������ ���`��� (��� ������� Buf_Size+4)
call GlobalFree ;������� �������� ��� � �����, ��������� ��������� ��� ���������, �� ��������� ����������
;call (������� ������ ������)
ret ;����� � ���������
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
