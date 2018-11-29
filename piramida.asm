codeSegment    segment
			assume cs:codeSegment, ds:dataSegment, ss:stackSegment ;Mowimy, ktory blok/segment jest ktory
start:      
			;USTAWIAM WSZYSTKIE POTRZEBNE REJESTRY NA WARTOSCI POCZATKOWE
			mov ax,dataSegment  ;najpierw laduje do akumulatora z 'labela'
			mov dx,ax    		;potem laduje z akumulatora do wlasciwego rejestru
			mov ax,stackSegment
			mov ss,ax
			mov sp,offset stackTop
			mov ax, B800h
			mov es, ax
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;USTAWIAM WARTOSCI POCZATKOWE
			mov di,39
			mov bh,65
			mov bl,158
			mov dh,1
			mov dl,5
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
linijki:    ;petla zewnetrzna, przechodzi przez linijki
			;TU WEWNETRZNA PETLA
			mov cx,dh
litery:			
			mov es[di],bh 	;wyswietl litere
			inc di 			;przesun kursor o 1
			loop litery 	;wyswietlamy litery dh razy
			;KONIEC WEWNETRZNEJ PETLI
			; koniec petli litery
			add di,bl ; przesuwamy adres pamieci ekranu do nastepnej linijki
			add dh,2  ; zwiekszamy liczbe literek o 2 
			sub dl,1  ; zmniejszamy licznik petli linijki o 1
			jnz dl,linijki ; jesli licznik petli dl jest rowny 0, to konczymy drukowanie, bo nie ma wiecej linii do druku

			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;WYCHODZE Z PROGRAMU
			
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