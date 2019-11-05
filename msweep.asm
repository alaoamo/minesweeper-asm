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

