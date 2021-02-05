
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const
IDD_DIALOG1						equ 101
IDC_EDT1						equ 1001
IDC_BTN1						equ 1002

;#########################################################################

.data?
hwin 	dd ?
hInstance			dd ?
hEvent 		dd ?
.data 
flag	db 0
password db 20 dup(0)

format db "Your password - %s",0
title_ db "Lab 7",0
buf		db 100 dup(0)
;#########################################################################
