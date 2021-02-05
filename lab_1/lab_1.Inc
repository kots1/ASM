include windows.inc	; приєднуємо модуль в якому знаходяться всі константи та структури
include user32.inc	; приєднуємо модуль всіх прототипів функцій, що знаходяться в динамічній бібліотеці  user32.dll
include kernel32.inc	;- || -kernel32.dll
include advapi32.inc
includelib advapi32.lib
includelib user32.lib	; приєднуємо статичну бібліотеку імпорту динамічній бібліотеки  user32.dll
includelib kernel32.lib	;- || -kernel32.dll

.data	; Вміст сегменту даних (глобальні змінні):
	hello_title           db ' Лабораторна робота № 1 ', 0; рядок символiв(string)(байтів)
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
