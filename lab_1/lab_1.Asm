.386			;  ��� ��������� �� ����� INTEL-386
.model flat, STDCALL	;  ���������� �� �������� ��� WIN32; 
option casemap :none  ;case sensitive
;��������� ���� ������ ����� ������� ����� ��������:
include lab_1.inc; 
.code       ; ���� �������� ����:
Start:

invoke GetUserName,addr user_name,addr buflen
invoke GetComputerName,addr computer_name,addr buflen
invoke GetCurrentDirectory,MAX_PATH,addr current_directory
invoke GetWindowsDirectory,addr	windows_directory,MAX_PATH
invoke wsprintf,addr res,addr format,addr computer_name,addr current_directory,addr user_name,addr windows_directory
invoke MoveFile,
 lea esi,offset res
	@@:
	mov al ,[esi] 
	test al,al
	jz @F
	test esi,1
	jnz next
	mov byte ptr [esi],'*'
	next:
	inc esi
	jmp @B
	
	
@@:
invoke MessageBox,NULL,addr res,addr hello_title,MB_OK
 invoke ExitProcess,NULL
 end Start