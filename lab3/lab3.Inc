include WINDOWS.inc

include user32.inc
include kernel32.inc
include comdlg32.inc
includelib comdlg32.lib
includelib user32.lib
includelib kernel32.lib

.data 
pmem_file_read dd 0
pmem_key dd 0
pmem_result dd 0
pmem dd 0  ;вказівник на структуру OPENFILENAME

hfile dd 0

size_file dd 0
byte_readed dd 0
byte_writen dd 0

path_file db 260 dup(0)
path_key db "D:\asm\ASM\Masm\Projects\lab3\key.txt",0
path_result db 260 dup(0)
directory db 260 dup(0)

mas POINT 20 dup(<>)

