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
			mov ax, 0B800h ;inicjowanie adresu poczatku pamieci ekranu
			mov es, ax
			mov di, 0 ;zerujemy di - przesuniecie kursora po ekranie
			
			;przygotowanie do czyszczenia ekranu
			mov cx,2000 ;liczba slow do wyczyszczenia - 80x25??
			mov ax,0720h ;szara spacja na czarnym tle - puste miejsce
			czysc:
				mov es:[di],ax ; kopiowanie spacji do aktualnego kursora na ekranie
				add di,2 ;przesuwanie kursora do nastepnego slowa (1 slowo = 2bajty)
				loop czysc 
			;zerowanie rejestrow
			xor ax,ax ;tu bedzie pobierana liczba
			xor bx,bx
			xor cx,cx
			xor dx,dx ;tu bedzie przechowywany i przesuwany wynik
			;przygotowanie do otrzymania znakow 
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
			cmp cl,5 ;sprawdza, czy mamy jakiekolwiek dane
			jnz endUserLoop ;jesli cokolwiek zostalo wpisane
			call noData ;jesli nic nie zostalo wprowadzone
endUserLoop:
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;WYSWIETLANIE HEX
			mov bx,dx ;kopiuj wynik
			xor ch,ch ;zeruj rejestr ch
			mov cx,0004h ;będziemy obracac 4 razy petle
showHex:	
				RCL bx,4 ; przesuwamy cyklicznie w lewo 4 razy
				mov al,bl ;kopiuję 8 bitow
				and al,0fh ;biore 4 najmlodsze
				call toHex ;zamieniam na znak w akumulatorze
				mov es:[di],al ;piszę na ekran
				add di,2 ;przesuwam kursor
			loop showHex
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;BINARNIE
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
			stc ;ustawienie flagi carry = 1
		RET   
			notNumber:
			clc ;ustawienie flagi carry = 0
		RET
		indicateOverflow:
				mov si,offset overflowString
				mov ah,cl ;zapisujemy stan petli
				mov cx, 24
				printOverflowString: ;drukuje stringa znak po znaku
				movsb ;printowanie jednego znaku oraz przesuwanie o kursora o 1 bajt
				add di,1 ;przesuniecie kursora o drugi bajt, w taki sposob, aby moglo wyswietlic kolejny znak
				loop printOverflowString
				mov cl,ah ;przywracamy stan petli
				mov dx,0FFFFh ;nadpisanie wyniku overflowem - musi byc 0 jesli pierwszy znak to litera
		RET
		tenMultiplyDx:
			mov ah,cl ;zapisujemy stan petli dla userInput
			mov cx,9
			mov bx,dx ;bx bedzie dodane 9 razy
			multiplyBegin:
				add dx,bx
				jc multiplyEnd
			loop multiplyBegin
			mov cl,ah ;przywracamy stan petli dla userInput
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
			sub al,10 ;odejmujemy 10, zeby pozniej moc przesunac ewentualnie literke o x miejsc dalej
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