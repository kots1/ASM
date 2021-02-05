.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include lab6.inc

.code

start:
	invoke GetTickCount
	invoke nseed,eax
	invoke GetModuleHandle,NULL
	mov		hInstance,eax

    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

;########################################################################

draw_random_line proc
LOCAL x,y:dword
	
;	not true
	invoke nrandom,5
	mov x,eax	
	invoke nrandom,0ffffffh
	mov y,eax	

	invoke CreatePen,PS_SOLID,x,y
	invoke SelectObject,hdc_b,eax
	invoke DeleteObject,eax
	
	invoke nrandom,400
	mov x,eax	
	invoke nrandom,400
	mov y,eax	
	
	invoke MoveToEx,hdc_b,x,y,0
	
	invoke nrandom,400
	mov x,eax	
	invoke nrandom,400
	mov y,eax	
	
	invoke LineTo,hdc_b,x,y	
	ret
draw_random_line endp


draw_neg proc
LOCAL x,y:dword
	mov x,0
	mov y,0
	.while y < 400
		.while x < 400 
			invoke GetPixel,hdc_b,x,y
			sub eax, 0ffffffh
			neg eax
			invoke SetPixel,hdc_b,x,y,eax
			inc x
		.endw
		mov x,1
		inc y
	.endw	
	ret
draw_neg endp

draw_gray proc
LOCAL x,y,color:dword
	mov x,0
	mov y,0
	.while y < 400
		.while x < 400 
			invoke GetPixel,hdc_b,x,y
			mov color,eax
			xor eax,eax
			mov bl,byte ptr color
			add eax,ebx
			
			mov bl,byte ptr color+1
			add eax,ebx
			
			mov bl,byte ptr color+2
			add eax,ebx
			
			xor edx,edx ; edx =0
			div _3		;eax = eax/3
			
			
			mov byte ptr color,al
			mov byte ptr color+1,al
			mov byte ptr color+2,al
			
			invoke SetPixel,hdc_b,x,y,color
			inc x
		.endw
		mov x,1
		inc y
	.endw	
	ret
draw_gray endp

draw_sepia proc
LOCAL x,y:dword
	mov x,0
	mov y,0
	.while y < 400
		.while x < 400 
			invoke GetPixel,hdc_b,x,y
			xor edx, edx
			xor ebx, ebx
			mov bl,al 	;r
			add edx,ebx ; dx +r
			mov bl,ah	; g
			add edx,ebx ; dx = r+g
			shr eax,8	; >> 8
			mov bl,ah 	;b
			add edx,ebx ; dx = r+b+g
			mov eax,edx ;eax = edx
			xor edx,edx ; edx =0
			div _3		;eax = eax/3
			
			mov ah,al	;
			shl eax,8
			mov al,ah
			
			
			
			add al,40
			jnc @F
			mov al,255 
		@@:	
			add ah,20
			jnc @F
			mov ah,255 
		@@:	
		
			invoke SetPixel,hdc_b,x,y,eax
			inc x
		.endw
		mov x,1
		inc y
	.endw	
	ret
draw_sepia endp
DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
LOCAL x,y:dword

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		invoke GetDC,0
		mov hdc,eax
		invoke CreateCompatibleDC,eax
		mov hdc_b,eax
		invoke CreateCompatibleBitmap,hdc,400,400
		mov hbitmap,eax
		invoke ReleaseDC,0,hdc
		invoke SelectObject,hdc_b,hbitmap
		invoke Rectangle,hdc_b,0,0,400,400
		invoke GetDC,hWin
		mov hdc,eax
		invoke SetTimer,hWin,12,100,0
		
	.elseif eax == WM_TIMER
		invoke BitBlt,hdc,10,10,400,400,hdc_b,0,0,SRCCOPY	 

	.elseif eax==WM_COMMAND
		.if wParam == IDC_BTN1
			mov x,1
			mov y,1
			.while y < 400
				.while x < 400 
					invoke MulDiv,x,y,1
					invoke SetPixel,hdc_b,x,y,eax
					inc x
				.endw
				mov x,1
				inc y
			.endw	
		.elseif wParam == IDC_BTN2
			invoke SetTimer,hWin,13,10,addr draw_random_line
		.elseif wParam == load_image
			invoke LoadImage,hInstance,addr img_path,IMAGE_BITMAP,0,0,LR_LOADFROMFILE
			mov himage,eax
			invoke SelectObject,hdc_b,eax
		.elseif wParam ==img_neg
			call draw_neg
			
		.elseif wParam ==gray
			call draw_gray
			
		.elseif wParam ==sepia
			call draw_sepia
			
		.endif

	.elseif eax==WM_CLOSE
		invoke ReleaseDC,hWin,hdc
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

DlgProc endp

end start
