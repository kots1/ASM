 
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc
include RADbg.inc
include comdlg32.inc

includelib comdlg32.lib
includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM
EnumTypeFunc proto hWin:HWND,lpType:WPARAM,lParam:LPARAM
EnumNameFunc proto hModule:HMODULE,lpType:LPCSTR,lpName:LPCSTR,lParam:LPARAM
GetResoursTypeStr proto lpType:dword
changeResourse proto id:dword, type_:dword
GetId proto hModule:HMODULE,lpType:LPCSTR,lpName:LPCSTR,lParam:dword
ShiftList proto num:dword

RES struct
id 		dd ? 
typeRes dd ?
RES ends

.const
IDD_DIALOG1						equ 101
IDC_LST1						equ 1001
Edit							equ 1003
Delete							equ 1002
Choose							equ 1005



;#########################################################################

.data?
hList			dd ?	
hInstance		dd ?
hRes			dd ?
hLib			dd ?


;#########################################################################
.data
Resources RES	50 dup(<>)
count		dd	0
openF OPENFILENAME <0>
chysl_format db "%s (id = %d)",0
string_format db "%s (id = %s)",0
pathToResourse db MAX_PATH dup(0)
dir db"D:\asm\ASM\Masm\Projects",0
szFilterExeAndDll db "ExE or DLL modude",0,"*.exe;*.dll;",0,0
success 	db "Successful",0
error		db "Error",0
titles		db "lab 5",0



masTypeStr dd	offset RT_ACCELERATOR_,offset RT_ANICURSOR_,offset RT_ANIICON_,\
			offset RT_BITMAP_,offset RT_CURSOR_,offset RT_DIALOG_,\
			offset RT_FONT_,offset RT_FONTDIR_,offset RT_GROUP_CURSOR_,\
			offset RT_GROUP_ICON_,offset RT_ICON_,offset RT_MANIFEST_,\
			offset RT_MENU_,offset RT_MESSAGETABLE_,\
			offset RT_RCDATA_,offset RT_STRING_,offset RT_VERSION_
			
RT_ACCELERATOR_		db 	'RT_ACCELERATOR',0
RT_ANICURSOR_		db	'RT_ANICURSOR',0
RT_ANIICON_			db	'RT_ANIICON',0
RT_BITMAP_			db	'RT_BITMAP',0
RT_CURSOR_			db	'RT_CURSOR',0
RT_DIALOG_			db	'RT_DIALOG',0
RT_FONT_			db	'RT_FONT',0
RT_FONTDIR_			db	'RT_FONTDIR',0
RT_GROUP_CURSOR_	db	'RT_GROUP_CURSOR',0
RT_GROUP_ICON_		db	'RT_GROUP_ICON',0
RT_ICON_			db	'RT_ICON',0
RT_MANIFEST_		db	'RT_MANIFEST',0
RT_MENU_			db	'RT_MENU',0
RT_MESSAGETABLE_	db	'RT_MESSAGETABLE',0
RT_RCDATA_			db	'RT_RCDATA',0
RT_STRING_			db	'RT_STRING',0
RT_VERSION_			db	'RT_VERSION',0
			

	 	



masType dd 	RT_ACCELERATOR,RT_ANICURSOR,RT_ANIICON,\
			RT_BITMAP,RT_CURSOR,RT_DIALOG,\
			RT_FONT,RT_FONTDIR,RT_GROUP_CURSOR,\
			RT_GROUP_ICON,RT_ICON,RT_MANIFEST,\
			RT_MENU,RT_MESSAGETABLE,\
			RT_RCDATA,RT_STRING,RT_VERSION







