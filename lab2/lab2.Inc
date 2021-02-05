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
		
January      db "січня",0
February     db "лютого",0 
March        db "березня",0
April        db "квітня",0
May          db "травня",0
June         db "червня",0
July         db "липня",0
August       db "серпня",0
September    db "вересня",0
October      db "жовтня",0
November     db "листопада",0
December     db "грудня",0
.data?
Save_esp dd ?