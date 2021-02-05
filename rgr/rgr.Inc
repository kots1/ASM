
.386                                                     ; minimum processor
.model flat,stdcall                                      ; win32 application
option casemap:none                                      ; case sensitive

include windows.inc                                      ; win32 structures etc.

incboth macro incl                                       ; macro for lazy coders
  include    incl.inc
  includelib incl.lib
endm

var4 macro  x
	LOCAL r
	.data
		r dd x
	.code
	exitm<r>
endm

p4 macro x:vararg
	r equ <>
	for i,<x>
		r catstr r,<,var4(i)>
	endm
	exitm<r>
endm
var8 macro  x
	LOCAL r
	.data
		r dq x
	.code
	exitm<dword ptr r,dword ptr r+4>
endm

p8 macro x:vararg
	r equ <>
	for i,<x>
		r catstr r,<,var8(i)>
	endm
	exitm<r>
endm

incboth kernel32                                         ; functions from kernel32
incboth user32                                           ; functions from user32
incboth comctl32                                         ; functions from comctl32
incboth gdi32                                            ; functions from gdi32
incboth opengl32                                         ; functions from opengl32
incboth glu32    
incboth glaux                                   ; functions from glu32
incboth winmm

; ** function prototypes
DlgProc           PROTO :HWND,:UINT,:WPARAM,:LPARAM      ; main dialog procedure
myOGL_InitGL      PROTO :DWORD                           ; setup openGL
myOGL_DrawScene   PROTO                                  ; update the openGL scene
myOGL_KillGL      PROTO                                  ; cleanup openGL
built				proto

; ** uninitialized data
.data?
hobj				 dd			?
hInstance            HINSTANCE  ?                        ; application instance
hIcon                HICON      ?                        ; application icon 
hDC                  dd         ?                        ; device context
hRC                  dd         ?                        ; openGL rendering context
hOGLWindow           HWND       ?                        ; openGL window handle
staticRect           RECT       <?>                      ; dimensions of static openGL "window"


; ** initialized data
.data
szAppName            db " Óˆ¸ÍÓ",0 ; dialog caption
a		dd 	0.0
fi		dd	1.0
pos 	dd  5.0,8.0,-1.0
dest   dd   1.0,1.0,1.0,0
mouse	dd	0
button  dd  0

sound	db "3.wav",0


xc		dd	0
yc		dd	0

x0		dd	0
y0		dd	0

xr		dd	0
yr		dd	0
_2 dd 2.0
; ** constants
.const
IDI_ICON             equ 100                             ; application icon
IDD_DIALOG           equ 1000                            ; dialog resource
IDI_OPENGL           equ 1001                            ; openGL static area
