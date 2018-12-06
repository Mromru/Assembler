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
				
				call isNumber	  ;sprawdzamy czy jest liczbą
				jnc checkNoData ;jezeli ustawilismy C=0, to nie jest i przerywamy wprowadzanie danych
				
				mov es:[di],al  ;wyswietlenie znaku na ekranie
				add di,2	    ;i przesuniecie kursora
				sub al,'0'		;char do int
				
				;mnozymy przez 10
				call tenMultiplyDx
					jnc noOverflowMul
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
checkNoData:
			cmp cl,5
			jnz endUserLoop
			call noData
endUserLoop:
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;WYSWIETLANIE HEX
			mov bx,dx ;kopiuj wynik
			xor ch,ch
			mov cl,4
showHex:	
				mov ah,cl ;zapisuję counter glownej petli
				fourCyclicLeft:
					;TODO PRZESUNIECIE CYKLICZNE W LEWO
					loop fourCyclicLeft
				mov cl,ah ;przywracam counter glownej petli
				mov al,bl ;kopiuję 8 bitow
				and al,0fh ;biore 4 najmlodsze
				call toHex ;zamieniam na znak w akumulatorze
				mov es:[di],al ;piszę na ekran
				add di,2 ;przesuwam kursor
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;BINARNIE
				mov bx,dx
				xor ch,ch
				mov cl, 8
			loop showHex
			mov bx,dx
			xor ch,ch
			mov cl, 8
showBin:
				mov al,bl ;kopiuję 8 bitow
				and al,01h ;biore 1 najmlodszy
				add al,'0';zamieniam na znak w akumulatorze
				mov es:[di],al ;piszę na ekran
				add di,2 ;przesuwam kursor
				loop showBin
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;WYCHODZIMY Z PROGRAMU
				mov     ah,4ch
				mov	    al,0
				int	    21h
		;PROCEDURY
		isNumber:
			cmp al,'0'
			jl notNumber
			cmp al,'9'
			jg notNumber
			stc
		RET   
			notNumber:
			clc
		RET
		indicateOverflow:
				mov si,offset overflowString
				mov ah,cl
				mov cx, 24
				printOverflowString:
				movsb
				add di,1
				loop printOverflowString
				mov cl,ah
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
		noData:
			mov si, offset noDataString
			mov cx, 16
			printNoDataString:
				movsb
				add di,1
				loop printNoDataString
		RET
		toHex:
			cmp al,10
			jge letter
			add al,'0'
			jmp finnishToHex
			letter:
			add al,'A'	
		finnishToHex:
		RET
code ends
data segment
	overflowString db ' -> 65535; PRZEPELNIENIE'
	noDataString db   'BRAK DANYCH -> 0'
data ends
stackS segment
stackTop 	label word
stackS ends
end start