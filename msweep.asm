section .data               
;Canviar Nom i Cognom per les vostres dades.
developer db "Yasin Radi",0

;Constants que també estan definides en C.
DimMatrix    equ 10
SizeMatrix   equ 100

section .text            
;Variables definides en Assemblador.
global developer     
                         
;Subrutines d'assemblador que es criden des de C.
global posCurScreenP1, showMinesP1, updateBoardP1, moveCursorP1
global mineMarkerP1, checkMinesP1, printMessageP1, playP1	 

;Variables globals definides en C.
extern rowScreen, colScreen, rowMat, colMat, indexMat
extern charac, mines, marks, numMines, state

;Funcions de C que es criden des de assemblador
extern gotoxyP1_C, getchP1_C, printchP1_C
extern printBoardP1_C, printMessageP1_C	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓ: Recordeu que les variables i els paràmetres de tipus 'char',
;;   en assemblador s'han d'assignar a registres de tipus  
;;   BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;;   les de tipus 'int' s'han d'assignar a registres de tipus 
;;   DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;;   les de tipus 'long' s'han d'assignar a registres de tipus 
;;   QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Les subrutines en assemblador que heu d'implementar són:
;;   posCurScreenP1, showMinesP1, updateBoardP1
;;   moveCursorP1, mineMarkerP1, checkMinesP1
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Situar el cursor a la fila indicada per la variable (rowScreen) i a 
; la columna indicada per la variable (colScreen) de la pantalla,
; cridant la funció gotoxyP1_C.
; 
; Variables globals utilitzades:	
; rowScreen: fila de la pantalla on posicionem el cursor.
; colScreen: columna de la pantalla on posicionem el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call gotoxyP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Mostrar un caràcter guardat a la variable (charac) a la pantalla, 
; en la posició on està el cursor, cridant la funció printchP1_C
; 
; Variables globals utilitzades:	
; charac   : caràcter que volem mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call printchP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Llegir una tecla i guarda el caràcter associat a la variable (charac)
; sense mostrar-la per pantalla, cridant la funció getchP1. 
; 
; Variables globals utilitzades:	
; charac   : caràcter que llegim de teclat.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call getchP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret 
   

;;;;;
; Posiciona el cursor a la pantalla dins del tauler, en funció 
; de l'índex de la matriu (indexMat), posició del cursor dins del tauler.
; Per a calcular la posició del cursor a la pantalla utilitzar 
; aquestes fórmules:
; rowScreen=((indexMat/10)*2)+7
; colScreen=((indexMat%10)*4)+7
; Per a posicionar el cursor cridar a la subrutina gotoxyP1.
;
; Variables globals utilitzades:	
; indexMat : Índex per a accedir a les matrius mines i marks des d'assemblador.
; rowScreen: Fila de la pantalla on posicionem el cursor.
; colScreen: Columna de la pantalla on posicionem el cursor.
;;;;;
posCurScreenP1:
	push rbp
	mov  rbp, rsp
   push rax
   push rdx
   push rbx
   push r8
   push r9
	
   ; [64bit] QWORD DIV - RDX:RAX / RBX 
   ; rowScreen
	mov rax, QWORD [indexMat]    ; Move indexMat value to RAX register
   xor rdx, rdx                 ; Clear value from RDX
   mov rbx, 10                  ; Load divisor

   div rbx                      ; Division execution
   
   mov r8, 2                    ; Move multiplier to R8
   mov r9, rdx                  ; Save remainder for colScreen

   mul r8                       ; Multiply RAX * R8, store in RAX
   add rax, 7                   ; Add 7 to RAX
   mov QWORD [rowScreen], rax   ; Save computed value in rowScreen

   ; colScreen
   mov rax, r9                  ; Move remainder saved in R9 to RAX
   mov r8,  4                   ; colScreen multiplication value

   mul r8                       ; Multiply RAX * R8, store in RAX
   add rax, 7                   ; Add 7 to RAX
   mov QWORD [colScreen], rax   ; Save computed value in colScreen
	
   call gotoxyP1                ; Goto call to computed position

   pop r9
   pop r8
   pop rbx
   pop rdx
   pop rax
	mov rsp, rbp
	pop rbp
	ret


;;;;;
; Converteix el valor del Número de mines que queden per marcar (numMines)
; (entre 0 i 99) a dos caràcters ASCII. 
; S'ha de dividir el valor (numMines) entre 10, el quocient representarà 
; les desenes i el residu les unitats, i després s'han de convertir 
; a ASCII sumant 48, carácter '0'.
; Mostra els dígits (caràcter ASCII) de les desenes a la fila 27, 
; columna 24 de la pantalla i les unitats a la fila 27, columna 26, 
; (la posició s'indica a través de les variables rowScreen i colScreen).
; Per a posicionar el cursor cridar a la subrutina gotoxyP1 i per a mostrar 
; els caràcters a la subrutina printchP1.
;
; Variables globals utilitzades:	
; rowScreen: Fila de la pantalla on posicionem el cursor.
; colScreen: Columna de la pantalla on posicionem el cursor.
; numMines : Nombre de mines que queden per marcar.
; charac   : Caràcter a escriure a pantalla.
;;;;;
showMinesP1:
	push rbp
	mov  rbp, rsp
   push rax
   push rcx
   push rdx
		
	mov eax, DWORD [numMines]     ; Load numMines value into EAX
   xor edx, edx                  ; Clear EDX
   mov ecx, 10                   ; Load divisor to ECX

   div ecx                       ; Execute division

   add eax, '0'                  ; Cast EAX value to char
   add edx, '0'                  ; Cast EDX value to char

   mov QWORD [rowScreen], 27     ; Set rowScreen to position 27

   ; For EAX value
   mov DWORD [charac], eax       ; Load EAX value to charac var
   mov QWORD [colScreen], 24     ; Set colScreen to position 24

   call gotoxyP1                 ; Go to position
   call printchP1                ; Print character in charac

   ; For EDX value
   mov DWORD [charac], edx       ; Load EDX value to charac var
   mov QWORD [colScreen], 26     ; Set colScreen to position 26

   call gotoxyP1                 ; GotoXY -- God bless <conio.h>
   call printchP1                ; Print
   
   pop rdx
   pop rcx
   pop rax
	mov rsp, rbp
	pop rbp
	ret


;;;;;
; Actualitzar el contingut del Tauler de Joc amb les dades de la matriu 
; (marks) i el nombre de mines que queden per marcar. 
; S'ha de recórrer tot la matriu (marks), i per a cada element de la matriu
; posicionar el cursor a la pantalla i mostrar els caràcters de la matriu.
; Després mostrar el valor de (numMines) a la part inferior del tauler.
; Per a posicionar el cursor cridar a la subrutina gotoxyP1, per a mostrar 
; els caràcters a la subrutina printchP1 i per a mostrar (numMines) 
; es crida la subrutina ShowMinesP1.
;
; Variables globals utilitzades:	
; rowScreen: Fila de la pantalla on posicionem el cursor.
; colScreen: Columna de la pantalla on posicionem el cursor.
; charac   : Caràcter a escriure a pantalla.
; marks    : Matriu amb les mines marcades i les mines de les obertes.   
;;;;;  
updateBoardP1:
	push rbp
	mov  rbp, rsp
   push rax
   push rbx
   push rcx
   push rsi
   push r8
   push r9
   push r10

   mov ebx, 0                          ; Init marks counter to 0
   mov ecx, 0                          ; Init l1 counter to 0
   mov rax, 7                          ; Init rowScreen offset in position 7
   mov r8d, DimMatrix                  ; Load DimMatrix into EDX
   dec r8d                             ; EDX--

	; Iterate over matrix
   l1:
      cmp ecx, r8d                     ; Compare ECX and EDX
      je done                          ; Jump to done if ECX == EDX
      mov esi, 0                       ; Init l2 counter to 0
      mov r10, 7                       ; Init colScreen offset at position 7
      mov QWORD [rowScreen], rax       ; Update rowScreen value

   l2:
      cmp esi, r8d                     ; Compare ESI and EDX
      je reloop                        ; Jump to reloop if ESI == EDX
      mov r9d, DWORD [marks + ebx]     ; Load n-th (char) element from vector
      mov DWORD [charac], r9d          ; Load vector element onto charac
      mov QWORD [colScreen], r10       ; Update colScreen value
      call gotoxyP1                    ; Goto screen position
      call printchP1                   ; Print current character
      add r10, 4                       ; Add offset to colScreen
      inc esi                          ; ESI++
      inc ebx                          ; EBX++
      jmp l2                           ; Jump to l2

   reloop:
      ; Add offset to rowScreen
      inc rax                          ; Increment
      inc rax                          ;   RAX
      inc ecx                          ; ECX++
      jmp l1                           ; Jump to l1

   done:
      call showMinesP1                 ; Call showMinesP1

   pop r10
   pop r9
   pop r8
   pop rsi
   pop rcx
   pop rbx
   pop rax
	mov rsp, rbp
	pop rbp
	ret


;;;;;		
; Actualitzar la posició del cursor al tauler, que tenim indicada 
; amb la variable (indexMat), en funció a la tecla premuda,
; que tenim a la variable (charac).
; Si es surt fora del tauler no actualitzar la posició del cursor.
; (i:amunt, j:esquerra, k:avall, l:dreta)
; Amunt i avall:    ( indexMat = indexMat +/- 10 ) 
; Dreta i esquerra: ( indexMat = indexMat +/- 1 ) 
; No s'ha de posicionar el cursor a la pantalla.
;
; Variables globals utilitzades:	
; indexMat : Índex per a accedir a les matrius mines i marks des d'assemblador.
; charac   : Caràcter llegit de teclat.
;;;;;  
moveCursorP1:
	push rbp
	mov  rbp, rsp
   push rax
   push rbx
   push rcx
   push rdx
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13

   xor rdx, rdx               ; Clear RDX register
   mov r8, DimMatrix          ; Set R8 to DimMatrix value
   dec r8                     ; R8--

   xor r9d, r9d               ; Clear R9D register
   mov r9d, 'i'               ; Set R9D to i

   xor r10d, r10d             ; Clear R10D register
   mov r10d, 'j'              ; Set R10D to j

   xor r11d, r11d             ; Clear R11D register
   mov r11d, 'k'              ; Set R11D to k

   xor r12d, r12d             ; Clear R12D register
   mov r12d, 'l'              ; Set R12D to l

   mov rcx, QWORD [indexMat]  ; Set RCX to indexMat value
	mov rax, QWORD [indexMat]  ; Set RAX to indexMat value
   xor rbx, rbx               ; Clear RBX register
   mov rbx, 10                ; Set RBX to 10

   div rbx                    ; Perform RDX:RAX / RBX

   xor r13d, r13d               ; Clear EAX register
   mov r13d, DWORD [charac]    ; Set EAX to charac value

   cmp r13d, r9d               ; charac == 'i'
   je i_lab

   cmp r13d, r10d              ; charac == 'j'
   je j_lab

   cmp r13d, r11d              ; charac == 'k'
   je k_lab

   cmp r13d, r12d              ; charac == 'l'
   je l_lab

   jmp end                    ; No match, get out

   i_lab:
      cmp rax, 0              ; Compare RAX to 0
      jle end                 ; if RAX <= 0 jump to end
      sub rcx, 10             ; RCX - 10
      jmp end                 ; Jump to end

   j_lab:
      cmp rdx, 0              ; Compare RDX to 0
      jle end                 ; if RDX <= 0 jump to end
      dec rcx                 ; RCX--
      jmp end                 ; Jump to end

   k_lab:
      cmp rax, r8             ; Compare RAX to R8 (DimMatrix - 1)
      jge end                 ; if RAX >= DimMatrix - 1 jump to end
      add rcx, 10             ; RCX + 10
      jmp end                 ; Jump to end

   l_lab:
      cmp rdx, r8             ; Compare RDX to R8
      jge end                 ; if RDX >= DimMatrix - 1 jump to end
      inc rcx                 ; RCX++

   end:
      mov QWORD [indexMat], rcx  ; Set indexMat value to RCX

   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdx
   pop rcx
   pop rbx
   pop rax
	mov rsp, rbp
	pop rbp
	ret


;;;;;  
; Marcar/desmarcar una mina a la matriu (marks) a la posició actual del
; cursor indicada per la variable (indexMat).
; Si en aquella posició de la matriu (marks) hi ha un espai en blanc i 
; no hem marcat totes les mines, marquem una mina posant una 'M' a la 
; matriu (marks) i decrementarem el nombre de mines que queden per 
; marcar (numMines), si en aquella posició de la matriu (marks) hi ha 
; una 'M', posarem un espai (' ') a la matriu (marks) i incrementarem 
; el nombre de mines que queden per marcar (numMines).
; Si hi ha un altre valor no canviarem res.
; No s'ha de mostrar la matriu, només actualitzar la matriu (marks) i 
; la variable (numMines).
;
; Variables globals utilitzades:	
; indexMat : índex per a accedir a la matriu marks.
; marks    : Matriu amb les mines marcades i les mines de les obertes. 
; numMines : nombre de mines que queden per marcar.
;;;;;  
mineMarkerP1:
	push rbp
	mov  rbp, rsp

	mov rax, QWORD [indexMat]  ; Set RAX to indexMat value
   xor rbx, rbx               ; Clear RBX register
   mov rbx, 10                ; Set RBX to 10

   div rbx                    ; Perform RDX:RAX / RBX
	
	mov rsp, rbp
	pop rbp
	ret
	

;;;;;  
; Verificar si hem marcat totes les mines ,
; Si (numMines==0) canvia l'estat (state=2) (Guanya).
;
; Variables globals utilitzades:	
; numMines : Nombre de mines que queden per posar. 
; state    : Estat del joc.
;;;;;  
checkMinesP1:
	push rbp
	mov  rbp, rsp

	
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Mostra un missatge a sota del tauler segons el valor de la variable 
; (state) cridant la funció printMessageP1_C.
; (state) 0: Sortir, hem premut la tecla 'ESC' per a sortir.
;         1: Continuem jugant.
;         2: Guanyat, s'han marcat totes les mines.
; S'espera que es premi una tecla per a continuar.
;  
; Variables globals utilitzades:	
; rowScreen: Fila de la pantalla on posicionem el cursor.
; colScreen: Columna de la pantalla on posicionem el cursor.
; state    : Estat del joc.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printMessageP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ;Cridem la funció printMessageP1_C() des d'assemblador, 
   call printMessageP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   
   
;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Joc del Buscamines.
; Subrutina principal del joc.
; Permet jugar al joc del buscamines cridant totes les funcionalitats.
;
; Pseudo codi:
; Inicialitzar estat del joc, (state=1).
; Inicialitzar posició inicial del cursor:
; fila: 5 i columna: 4, (indexMat=54).
; Mostrar el tauler de joc cridant la funció PrintBoardP1_C.
; Mentre (state=1) fer:
;   Actualitzar el contingut del Tauler de Joc i el nombre de mines que 
;     queden per marcar (cridar la subrutina updateBoardP1).
;   Posicionar el cursor dins del tauler (cridar la subrutina posCurScreenP1)
;   Llegir una teclar i guradarla a la variable (charac) (cridar la subrutina getchP1)
;   Segons la tecla llegida cridarem a la funció corresponent.
;     - ['i','j','k' o 'l']      (cridar a la subrutina MoveCursorP1).
;     - 'm'                      (cridar a la subrutina MineMarkerP1).
;     - '<ESC>'  (codi ASCII 27) posar (state = 0) per a sortir.   
;   Verificar si hem marcat totes les mines (crida a la subrutina CheckMinesP1).
; Fi mentre.
; Sortir: 
;   Actualitzar el contingut del Tauler de Joc i el nombre de mines que 
;   queden per marcar (cridar la subrutina updateBoardP1).
;   Mostrar missatge de sortida que correspongui (cridar a la subrutina
;   printMessageP1)
; S'acabat el joc.
;
; Variables globals utilitzades:	
; indexMat : índex per a accedir a la matriu marks.
; charac   : Caràcter llegit de teclat.
; state    : Estat del joc.
;;;;;  
playP1:
	push rbp
	mov  rbp, rsp

	mov DWORD[state], 1       ;state = 1;

	mov QWORD[indexMat], 54   ;indexMat = 54;
	
	call printBoardP1_C       ;printBoardP1_C();

	playP1_Loop:              
		cmp  DWORD[state], 1  ;while (state == 1)
		jne  playP1_PrintMessage

		call updateBoardP1    ;updateBoardP1_C();
		
		call posCurScreenP1   ;posCurScreenP1_C();
		
		call getchP1          ;getchP1_C(); 
		mov  al, BYTE[charac] 

		cmp al, 'i'		      ;if (charac>='i' && charac<='l')
		je  playP1_MoveCursor
		cmp al, 'j'		      
		je  playP1_MoveCursor
		cmp al, 'k'		      
		je  playP1_MoveCursor
		cmp al, 'l'		      
		je  playP1_MoveCursor
		cmp al, 'm'		      ;if (charac=='m')
		je  playP1_MineMarker
		cmp al, 27		      ;if (charac==27)
		je  playP1_Exit
		jmp playP1_Check

		playP1_MoveCursor     
		call moveCursorP1     ;moveCursorP1_C();
		jmp  playP1_Check

		playP1_MineMarker     ;mineMarkerP1_C();
		call mineMarkerP1
		jmp  playP1_Check

		playP1_Exit:
		mov DWORD[state], 0   ;state = 0;
		
		playP1_Check:
		call checkMinesP1     ;checkMinesP1_C();

		jmp  playP1_Loop

	playP1_PrintMessage:
	call updateBoardP1        ;updateBoardP1_C();
	call printMessageP1       ;printMessageP1_C();
    
	playP1_End:		
	mov rsp, rbp
	pop rbp
	ret

