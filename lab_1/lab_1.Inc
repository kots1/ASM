include windows.inc	; �������� ������ � ����� ����������� �� ��������� �� ���������
include user32.inc	; �������� ������ ��� ��������� �������, �� ����������� � ��������� ��������  user32.dll
include kernel32.inc	;- || -kernel32.dll
include advapi32.inc
includelib advapi32.lib
includelib user32.lib	; �������� �������� �������� ������� ��������� ��������  user32.dll
includelib kernel32.lib	;- || -kernel32.dll

.data	; ���� �������� ����� (��������� �����):
	hello_title           db ' ����������� ������ � 1 ', 0; ����� ������i�(string)(�����)
	computer_name		  db 100 dup(0)
	user_name             db 100 dup(0)	
	buflen				  db 100
	current_directory     db MAX_PATH dup(0)
	windows_directory	  db MAX_PATH dup(0)
	format db "Computer Name: %s ",13,10
 		   db "Current Directory: %s ",13,10
 		   db "User Name: %s ",13,10
 		   db "Windows Directory: %s ",0
 	res db 0 dup(500)
