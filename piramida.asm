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
			Label linijki ; petla zewnetrzna, przechodzi przez linijki
			
			
			Label litery ; petla wewnetrzna, drukuje odpowiednia ilosc literek w aktualnej linijce
			; tutaj wstawiamy kod do drukowania itd
			; koniec petli litery
			add di, bl ; przesuwamy adres pamieci ekranu do nastepnej linijki
			add dh, 2  ; zwiekszamy liczbe literek o 2 
			sub dl, 1  ; zmniejszamy licznik petli linijki o 1
			jnz dl linijki ; jesli licznik petli dl jest rowny 0, to konczymy drukowanie, bo nie ma wiecej linii do druku
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