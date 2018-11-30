code segment
	assume cs:code, ds:data, ss:stackS
start:
			;inicjowanie segmentow
			mov ax,data
			mov ds,ax
			mov ax,stackS
			mov ss,ax
			mov sp,offset stackTop
			;inicjowanie es i di
			mov ax, 0B800h
			mov es, ax
			mov di, 0
			
			;przygotowanie do czyszczenia ekranu
			mov cx,4000
			mov ax,0720h
			czysc:
				mov es:[di],ax
				add di,2
				loop czysc
			;przygotowanie do otrzymania znakow
			xor ax,ax ;tu bedzie pobierana liczba
			xor bx,bx
			xor cx,cx
			xor dx,dx ;tu bedzie przechowywany i przesuwany wynik
			;wlasciwie to od tad
			mov di,0
			mov cx,0005h	;maksymalnie przyjmiemy 5 znakow
userInput:
				mov ah,00h	; pobranie znaku
				int 16h		; z klawiatury
				mov es:[di],al ;wyswietlenie znaku na ekranie
				add di,2	   ;i przesuniecie kursora
				sub al,30h
				
				call isNumber
				jnc endUserLoop
				
				;mnozymy przez 10
				call tenMultiplyDx
					jno noOverflowMul
						call indicateOverflow
						jmp endUserLoop
					noOverflowMul:
				;dodajemy biezaca liczbe
				xor ah,ah
				add dx,ax
					jnc noOverflowAdd
						call indicateOverflow
						jmp endUserLoop
					noOverflowAdd:
				loop userInput
endUserLoop:
			add dx,1
			add dx,1
			;WYCHODZIMY Z PROGRAMU
			mov     ah,4ch
			mov	    al,0
	        int	    21h
		;PROCEDURY
		isNumber:
			stc
		RET
		indicateOverflow:
				;TODO WYSWIETLENIE KOMUNIKATU
				mov dx,0FFFFh
		RET
		tenMultiplyDx:
			mov ah,cl
			mov cx,9
			mov bx,dx ;bx bedzie dodane 9 razy
			multiplyBegin:
				add dx,bx
				jc multiplyEnd
			loop multiplyBegin
			mov cl,ah
			multiplyEnd:
		RET
		
code ends
data segment
	
	
data ends
stackS segment
stackTop 	label word
stackS ends
end start