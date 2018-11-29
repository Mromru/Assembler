codeSegment    segment
			assume cs:codeSegment, ds:dataSegment, ss:stackSegment ;Mowimy, ktory blok/segment jest ktory
start:      
			;USTAWIAMY WSZYSTKIE POTRZEBNE REJESTRY NA WARTOSCI POCZATKOWE
			mov ax,dataSegment  ;najpierw ladujemy do akumulatora z 'labela'
			mov dx,ax    		;potem ladujemy z akumulatora do wlasciwego rejestru
			mov ax,stackSegment
			mov ss,ax
			mov sp,offset stackTop
			mov ax,0B800h
			mov es,ax
			
			;USTAWIAMY WARTOSCI DLA CZYSZCZENIA EKRANU (starszy bajt - atrybuty; mlodszy bajt - znak)
			mov ax,0720h ;07h szary, 20h spacja
			mov cx,8000  ;caly ekran ma 8000 bajtow
			mov di,0	 ;poczatkowy offset es
			
			;CZYSZCZIMY EKRAN
czysc:
			mov es:[di],ax
			add di,2
			loop czysc
			
			;USTAWIAMY WARTOSCI POCZATKOWE DLA PIRAMIDY
			mov dl,25		;dl - ilosc linii
			mov dh,1		;dh - ilosc liter
			mov di,78 		;miejsce pierwszego znaku to 39 od lewej
			mov bx,156  	;bx - przesuniecie dla di po kazdej linii = 156 (linia 35 odejmujemy jeszcze 2)
			mov ax,0741h	;07h - szary, 41h - 'A'
			xor ch,ch 		;czyscimy wyzszy bit cx
			;WYSWIETLAMY PIRAMIDE
linijki:
				mov cl,dh	;ladujemy ilosc liter
litery:
					mov es:[di],ax	;ladujemy word(2B) do pamieci ekranu
					add di,2		;przesuwamy sie o 2 bajty
					loop litery
				add ax,1	;zwiekszamy litere o 1
				add dh,2	;zwiekszamy ilosc liter o 2
				add di,bx	;przesuwamy di do nastepnego rzedu
				sub bl,4	;zmniejszamy przesuniecie (chcemy sie zawsze cofac o 1 miejsce w lewo)
				dec dl		;zmniejszamy licznik linii
				jnz linijki
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;WYCHODZIMY Z PROGRAMU
			mov     ah,4ch
			mov	    al,0
	        int	    21h
codeSegment     ends

dataSegment     segment

dataSegment     ends

stackSegment    segment
				dw    100h dup(0)
stackTop        Label word
stackSegment    ends
end start