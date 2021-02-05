include rgr.inc                                    ; needed header

	.code
	start:                                                   ; entry point
	  invoke  GetModuleHandle,NULL                           ; get a module handle
	  mov     hInstance,eax                                  ; and store it
	  invoke  InitCommonControls                             ; init treeview usage
	  invoke  DialogBoxParam,hInstance,IDD_DIALOG,NULL,offset DlgProc,NULL
	  invoke  ExitProcess,NULL                               ; cleanup and kill process
	  
DlgProc      proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	  .if     uMsg==WM_INITDIALOG                            ; WM_INITDIALOG
	    invoke  ShowWindow,hWin,SW_MINIMIZE                  ; pop up effect
	    invoke  LoadIcon,hInstance,IDI_ICON                  ; set application icon
	    mov     hIcon,eax                                    ; and store it's handle
	    invoke  SendMessage,hWin,WM_SETICON,1,hIcon          ; show the icon
	    invoke  SendMessage,hWin,WM_SETTEXT,0,offset szAppName ; show application name
	    invoke  ShowWindow,hWin,SW_SHOWNORMAL                ; show the final dialog 
	    invoke  myOGL_InitGL,hWin
	    invoke  SetTimer,hWin,1,10,NULL                      ; setup a timer
		invoke PlaySound,addr sound,NULL,SND_FILENAME + SND_ASYNC
	  .elseif uMsg==WM_TIMER                                 ; WM_TIMER
	    invoke  myOGL_DrawScene                              ; redraw openGL scene
	  .elseif uMsg==WM_LBUTTONDOWN
@1:
		mov mouse,1
		xor eax,eax
		mov ax,[ebp+20]
		mov x0,eax
		mov ax,[ebp+22]
		mov y0,eax
	  .elseif uMsg==WM_LBUTTONUP
	  	mov mouse,0
	  .elseif uMsg==WM_MOUSEMOVE
	  .if	mouse==1
	  	xor eax,eax
	  	mov ax,[ebp+20]
	  	mov xc,eax
	  	mov ax,[ebp+22]
	  	mov yc,eax
	  	
	  	fld xr
	  	fild yc
	  	fisub y0
	  	fdiv _2
	  	fsubp st(1),st
	  	fstp xr
	  	
	  	fld yr
	  	fild xc
	  	fisub x0
	  	fdiv _2
	  	fsubp st(1),st
	  	fstp yr
	  	jmp @1
	  .endif
	  .elseif uMsg==WM_CLOSE                                 ; WM_CLOSE
	    invoke  ShowWindow,hWin,SW_MINIMIZE                  ; minimize the window to taskbar
	    invoke  KillTimer,hWin,1                             ; delete timer                                        
	    invoke  myOGL_KillGL                                 ; delete openGL crap
	    invoke  ReleaseDC,hWin,hDC                           ; release device context
	    invoke  EndDialog,hWin,0                             ; end the dialog
	.elseif uMsg==WM_KEYDOWN
		.if	wParam ==VK_SPACE && button ==0
			mov button,1
			invoke PlaySound,NULL,NULL,0
			.else 
				invoke PlaySound,addr sound,NULL,SND_FILENAME + SND_ASYNC
				mov button,0
		.endif
	  .elseif uMsg==WM_COMMAND  ; WM_COMMAND
	    nop                                                  ; do nothing
	
	  .else
	    mov     eax,FALSE                                    ; delete unhandeled message
	    ret                                                  ; and continue
	  .endif
	  mov    eax,TRUE                                        ; message handled with success
	  ret                                                    ; and continue
	DlgProc      endp			
	
myOGL_InitGL proc theWindowHandle:DWORD
	  LOCAL    pfd:PIXELFORMATDESCRIPTOR                     ; ...
	  LOCAL    PixelFormat:DWORD                             ; correct pixelformat for static window
	  pushad                                                 ; store all registers
	  mov     pfd.nSize,sizeof PIXELFORMATDESCRIPTOR         ; setup pixelformatdescriptor struct
	  mov     pfd.nVersion,1
	  mov     pfd.dwFlags, PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER
	  mov     pfd.iPixelType, PFD_TYPE_RGBA
	  mov     pfd.cColorBits, 16
	  mov     pfd.cDepthBits, 16
	  mov     pfd.dwLayerMask, PFD_MAIN_PLANE
	  invoke  GetDC,theWindowHandle                            ; get the device context
	  mov     hDC,eax                                        ; and store it
	  invoke  GetClientRect,theWindowHandle,addr staticRect       ; we need the dimensions of the static
	  invoke  ChoosePixelFormat, hDC, ADDR pfd               ; and the correct pixelformat
	  mov     PixelFormat,eax                                ; thats the correct one
	  invoke  SetPixelFormat, hDC, PixelFormat, ADDR pfd     ; so set it!
	  invoke  wglCreateContext, hDC                          ; create rendering context
	  mov     hRC, eax                                       ; store the handle
	  invoke  wglMakeCurrent, hDC, hRC                       ; it's our OpenGL context
	  invoke  glViewport, 0, 0, staticRect.right, staticRect.bottom  ;reset viewport
	  invoke  glMatrixMode, GL_MODELVIEW                     ; select modelview matrix
	  invoke  glLoadIdentity                                 ; reset it
	  invoke  glShadeModel,GL_SMOOTH                         ; Enable Smooth Shading
	  invoke  glClearColor,0,0,0,0                         ; Black Background
	  invoke  glClearDepth,0,3FF00000h                       ; Depth Buffer Setup
	  invoke  glEnable,GL_DEPTH_TEST                         ; Enables Depth Testing
	  invoke  glDepthFunc,GL_LEQUAL                          ; The Type Of Depth Testing To Do
	  invoke  glHint,GL_PERSPECTIVE_CORRECTION_HINT,GL_NICEST; Really Nice Perspective Calculations
	  invoke gluNewQuadric
	  mov hobj,eax
	  
	  invoke glEnable,GL_COLOR_MATERIAL
	invoke glEnable,GL_LIGHTING
	invoke glEnable,GL_LIGHT0
	invoke glLightfv,GL_LIGHT0,GL_POSITION,addr pos
	invoke glLightfv,GL_LIGHT0,GL_SPOT_DIRECTION,addr dest
	
	  
	  call built
	  popad                                                  ; retore all registers
	  ret                                                    ; return to caller
myOGL_InitGL endp
built proc
	
	

	
invoke glNewList,1,GL_COMPILE
	invoke glTranslatef p4(0.0,1.0,0.0)
	invoke glRotatef p4(70.0,1.0,0.0,0.0)
	invoke glColor3f p4(1.0,0.0,0.0)
	invoke gluCylinder,hobj p8(1.0,1.0,2.0),800,100
	invoke gluSphere,hobj p8(1.0),50,50
	invoke glTranslatef p4(0.0,0.0,2.0)
	invoke gluSphere,hobj p8(1.0),50,50
	invoke glTranslatef p4(0.5,0.0,0.0)
	invoke gluCylinder,hobj p8(0.3,0.3,1.6),800,100
	invoke glTranslatef p4(-1.0,0.0,0.0)
	invoke gluCylinder,hobj p8(0.3,0.3,1.6),800,100
	invoke glTranslatef p4(0.0,0.0,1.6)
	invoke gluSphere,hobj p8(0.3),50,50
	invoke glTranslatef p4(1.0,0.0,0.0)
	invoke gluSphere,hobj p8(0.3),50,50
	
	invoke glColor3f p4(0.2,0.0,0.0)
	invoke glScalef p4(0.5,0.5,0.5)
	invoke glTranslatef p4(-0.0,2.0,-6.0)
	invoke glRotatef p4(90.0,0.0,0.0,1.0)
	invoke gluCylinder,hobj p8(1.0,1.0,2.0),800,100 
	invoke glTranslatef p4(0.0,1.8,0.0)
	invoke gluCylinder,hobj p8(1.0,1.0,2.0),800,100
	invoke glRotatef p4(90.0,1.0,0.0,0.0)
	invoke gluCylinder,hobj p8(1.0,1.0,2.0),800,100
	invoke gluSphere,hobj p8(1.0),50,50
	invoke glTranslatef p4(0.0,0.0,1.8)
	invoke gluSphere,hobj p8(1.0),50,50
	invoke glTranslatef p4(1.0,0.0,0.0) 
	invoke glRotatef p4(90.0,0.0,1.0,0.0)
	invoke glNormal3f p4(1.0,1.0,1.0)
	invoke glBegin,GL_QUADS
	invoke glVertex3f p4(-0.2,2.0,0.0)
	invoke glVertex3f p4(2.0,2.0,0.0)
	invoke glVertex3f p4(2.0,-0.1,0.0)
	invoke glVertex3f p4(-0.2,-0.1,0.0)
	invoke glEnd  
	invoke glTranslatef p4(0.0,2.0,-1.0)
	invoke glRotatef p4(90.0,1.0,0.0,0.0)
	invoke glNormal3f p4(1.0,1.0,1.0)
	invoke gluDisk,hobj p8(0.0,1.0),50,50
	invoke glTranslatef p4(1.8,0.0,0.0)
	invoke gluDisk,hobj p8(0.0,1.0),50,50
	
	invoke glTranslatef p4(-0.8,-4.1,2.8)
	invoke glRotatef p4(90.0,1.0,0.0,0.0)
	invoke glRotatef p4(180.0,0.0,1.0,0.0)
	invoke glColor3f p4(0.0,0.0,0.0)
	invoke gluCylinder,hobj p8(1.2,1.2,0.6),8,5
	invoke glColor3f p4(0.9,0.7,0.7)
	invoke gluDisk,hobj p8(0.0,1.2),8,5

	invoke glEndList
	
	
	ret

built endp
myOGL_DrawScene proc
	  pushad                                                 ; store all registers
	 invoke  glClear,GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT ; Clear Screen And Depth Buffer
	 invoke  glLoadIdentity   

	 invoke glRotatef, xr p4(1.0,0,0) 
	 invoke glRotatef, yr p4(0,1.0,0)
	  
	 invoke glScalef p4(0.3,0.3,0.3)
	 .if button==0
	
	 	fld a
	  fadd fi
	  fstp a   
	 .endif
	  	invoke glRotatef,a p4(0.1,0.1,0.0)
	invoke glCallList,1

	  invoke  SwapBuffers, hDC                               ; show the result
	  popad                  
	                    ; restore all registers
	  
	  ret                                                    ; return to caller
	myOGL_DrawScene endp
	
	myOGL_KillGL proc
	  pushad
	  invoke  wglMakeCurrent,NULL,NULL
	  invoke  wglDeleteContext,hRC
	  popad
	  ret
	myOGL_KillGL endp

	end start                                                ; end of application
