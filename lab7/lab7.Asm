.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include lab7.inc
include RADbg.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax

    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

;########################################################################
string proc Fstart:dword
local size_:dword
LOCAL random[20]:byte

	invoke lstrcpy,addr random, Fstart
	invoke lstrlen, Fstart
	dec eax
	mov size_,eax
	lea esi,random
start_:
	.if flag == 1	
		jmp ex
	.endif
	invoke lstrcmp,addr random,addr password
	.if eax == 0
	    mov flag,1
		invoke wsprintf,addr buf,addr format,addr random
		invoke MessageBox,0,addr buf,addr title_,MB_OK
		jmp ex
	.endif
	lea edi, random
	add edi,size_
@@:
	.if edi== esi
		jmp ex
	.endif
	.if byte ptr [edi]=='z'
		mov byte ptr [edi],'a'
		dec edi
		jmp @b
	.endif
@@:
	inc byte ptr [edi]
	jmp start_
ex:
	ret

string endp

;string proc Fstart:dword
;local size_:dword
;LOCAL random[20]:dword
;
;	invoke lstrcpy,addr random, Fstart
;	invoke lstrlen, Fstart
;	dec eax
;	mov size_,eax
;start_:
;	invoke WaitForSingleObject,hEvent,0
;	.if eax == WAIT_OBJECT_0	
;		jmp ex
;	.endif
;	invoke lstrcmp,addr random,addr password
;	.if eax == 0
;		invoke wsprintf,addr buf,addr format,addr random
;		invoke MessageBox,0,addr buf,Fstart,MB_OK
;		invoke SetEvent,hEvent
;		ret
;	.endif
;	lea edi, random
;	add edi,size_
;@@:
;    lea esi,random
;	.if edi==esi
;		jmp ex
;	.endif
;	cmp byte ptr [edi],'z'
;	jne @f
;	mov byte ptr [edi],'a'
;	dec edi
;	jmp @b
;@@:
;
;	inc byte ptr [edi]
;	jmp start_
;ex:
;	ret
;
;string endp


DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
LOCAL text[20]:byte
	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		mov eax,hWin
		mov hwin,eax
		;invoke CreateEvent,0,1,0,0
		;mov hEvent,eax
	.elseif eax==WM_COMMAND
		.if wParam == IDC_BTN1
			mov flag,0
			invoke SendDlgItemMessage,hwin,IDC_EDT1,WM_GETTEXT,20,addr password
			invoke lstrlen,addr password
			lea edi,text
			.if eax==0
				jmp @F
			.else
			.while eax!=0
				mov byte ptr [edi],'a'
				inc edi
				dec eax
			.endw
				mov byte ptr [edi],0	
			.endif
		
			lea edi,text
			xor ecx,ecx
			.while ecx!=26
			    push ecx
				invoke CreateThread,0,0,addr string,edi,0,0
				invoke Sleep,50
				pop ecx
				inc byte ptr [edi]
				inc ecx
			.endw
			
		@@:
		.endif
	.elseif eax==WM_CLOSE
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

DlgProc endp

end start
