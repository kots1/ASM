include WINDOWS.inc
include user32.inc
include kernel32.inc
includelib user32.lib
includelib kernel32.lib
.data 

file db "1.exe",0
formatFile db "%2d%s%4d(%2d_%02d).exe",0
buf db 0 dup(100)


months  dd 0
		dd	offset January
		dd	offset February
		dd	offset March
		dd	offset April
		dd	offset May
		dd	offset June
		dd	offset July
		dd	offset August
		dd	offset September
		dd	offset October
		dd	offset November
		dd	offset December
		
January      db "����",0
February     db "������",0 
March        db "�������",0
April        db "�����",0
May          db "������",0
June         db "������",0
July         db "�����",0
August       db "������",0
September    db "�������",0
October      db "������",0
November     db "���������",0
December     db "������",0
.data?
Save_esp dd ?