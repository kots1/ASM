.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include lab5.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax

    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

;########################################################################

DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	mov		eax,uMsg
	.if eax==WM_INITDIALOG
	invoke GetDlgItem ,hWin,IDC_LST1
	mov hList,eax
	mov openF.lpstrFilter,offset szFilterExeAndDll 
	mov openF.lStructSize,sizeof OPENFILENAME
	mov openF.lpstrFile,offset pathToResourse
	mov openF.nMaxFile,MAX_PATH
	mov openF.lpstrInitialDir,offset dir
	.elseif eax==WM_COMMAND
		mov eax,wParam
		.if eax==Choose
			call ListItem
		.elseif	eax==Edit
			call Edit_
		.elseif eax==Delete
			call DeleteItem
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
Edit_ proc
	invoke SendMessage,hList,LB_GETCURSEL,0,0
	mov esi,eax
	mov edi,Resources[esi*sizeof(RES)].typeRes
	.if edi==offset RT_ICON || edi==offset RT_MENU
	invoke changeResourse,Resources[esi*sizeof(RES)].id,Resources[esi*sizeof(RES)].typeRes
	.endif
	@@:
	ret

Edit_ endp

changeResourse proc id:dword, typeRes: dword
	LOCAL pathToNew[MAX_PATH]:BYTE
	LOCAL idNewRes:dword,hNewRes:dword,hResModule:dword,sizeRes:dword,hResLoad:dword,hResLock:dword
	
	lea esi,pathToNew
	mov openF.lpstrFile,esi
	
	invoke GetOpenFileName,offset openF
	cmp eax,0
	je @F
	
	invoke LoadLibrary,esi
	mov hResModule,eax
	invoke LoadLibrary, esi
	mov hLib,eax
	invoke EnumResourceNames,hLib,typeRes,addr GetId,0
	mov idNewRes,edx
	invoke FreeLibrary,hLib
	
	invoke FindResource,hResModule,idNewRes,typeRes	
	mov hNewRes,eax
	invoke LoadResource,hResModule,eax
	mov hResLoad,eax
	invoke LockResource,eax
	mov hResLock,eax
	
	invoke BeginUpdateResource,addr pathToResourse,0
	mov hRes,eax
	invoke SizeofResource,hResModule,hNewRes	
	invoke UpdateResource,hRes,typeRes,id,0,hResLock,eax
	invoke EndUpdateResource,hRes,0
	
	cmp eax,0
	je	@F
	invoke MessageBox,0,addr success,addr titles,MB_OK
	jmp ex
@@:
	invoke MessageBox,0,addr error,addr titles,MB_OK
ex:
	invoke FreeLibrary,hResModule
	ret

changeResourse endp
GetId proc hModule:HMODULE,lpType:LPCSTR,lpName:LPCSTR,lParam:LPARAM
	mov edx,lpName
	ret

GetId endp
DeleteItem proc
	invoke SendMessage,hList,LB_GETCURSEL,0,0
	cmp eax,-1
	je ex
	mov esi,eax
	invoke BeginUpdateResource,addr pathToResourse,0
	mov hRes,eax
	mov edi,Resources[esi*sizeof(RES)].typeRes
	mov ebx,Resources[esi*sizeof(RES)].id
	invoke UpdateResource,hRes,edi, ebx,0,0,0
	invoke EndUpdateResource,hRes,0
	cmp eax,1
	je @f
	invoke MessageBox,0,addr error,addr titles,MB_OK
	ret
@@:
	invoke MessageBox,0,addr success,addr titles,MB_OK
	invoke SendMessage,hList,LB_DELETESTRING,esi,0
	invoke ShiftList,esi
ex:
	ret

DeleteItem endp


ShiftList proc num:dword
	mov ecx,num
	lea edi,Resources[ecx*sizeof(RES)]
	assume edi:ptr RES
@@:
	cmp [edi].id,0
	je @F
	mov esi,[edi+sizeof(RES)].id
	mov eax,[edi+sizeof(RES)].typeRes
	mov [edi].id,esi
	mov [edi].typeRes,eax
	add edi,sizeof(RES)
	jmp @B
@@:
	assume edi:dword
	
	ret

ShiftList endp

ListItem proc
invoke SendMessage,hList,LB_RESETCONTENT,0,0
lea edi,pathToResourse
mov byte ptr[edi],0
mov openF.lpstrFile,edi

invoke GetOpenFileName,offset openF
cmp eax,0
je @f

invoke LoadLibrary,addr pathToResourse
mov hLib,eax
invoke EnumResourceTypes,hLib,addr EnumTypeFunc,0
invoke FreeLibrary,hLib

@@:
ret
ListItem endp

EnumTypeFunc proc hWin:HWND,lpType:LPTSTR ,lParam:LONG 
	invoke EnumResourceNames,hWin,lpType,addr EnumNameFunc,0
	or eax,1
ret 

EnumTypeFunc endp

 GetResoursTypeStr proc lpType:dword
	mov ecx,17
	mov edi,offset masType
	mov eax,lpType
@@:
	mov ebx,[edi]
	cmp	 eax, [edi]
	je @F
	add edi,4
	loop @B
@@:	
	sub edi,offset masType
	add edi,offset masTypeStr
	ret

  GetResoursTypeStr endp

EnumNameFunc proc hModule:HMODULE,lpType:LPCSTR,lpName:LPCSTR,lParam:LPARAM
	LOCAL buf[100]:BYTE
	LOCAL TypeRes:dword
	
	invoke GetResoursTypeStr,lpType
	push [edi]
	pop TypeRes
	mov eax,lpName
	test eax,0ffff0000h
	jz two
	invoke wsprintf,addr buf,addr string_format,TypeRes,eax
	jmp @f
two:
	invoke wsprintf,addr buf,addr chysl_format,TypeRes,eax
@@:
	invoke SendMessage,hList,LB_ADDSTRING,0,addr buf
	mov eax,lpName
	mov ebx,count
	mov Resources[ebx*sizeof(RES)].id,eax
	mov eax,lpType
	mov Resources[ebx*sizeof(RES)].typeRes,eax
	inc count
	or eax,1
ret
EnumNameFunc endp
end start
