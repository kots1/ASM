
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib
include gdi32.inc
includelib gdi32.lib
include masm32.inc
includelib masm32.lib

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const

;lab6.dlg
IDD_DIALOG1						equ 101
IDC_BTN1						equ 1001
IDC_BTN2						equ 1002
load_image						equ 1003
img_neg							equ 1004
gray							equ 1005
sepia							equ 1006

;#########################################################################
.data

	img_path		db '1.bmp',0
	_3				dd 3
.data?
hdc_b				dd ?
hbitmap				dd ?
hInstance			dd ?
hdc					dd ?
himage				dd ?

;#########################################################################
