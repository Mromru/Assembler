codeSegment    segment
			assume cs:codeSegment, ds:dataSegment, ss:stackSegment ;Mowimy, ktory blok/segment jest ktory
start:      
			;USTAWIAMY WSZYSTKIE POTRZEBNE REJESTRY NA WARTOSCI POCZATKOWE
			mov ax,dataSegment  ;najpierw ladujemy do akumulatora z 'labela'
			mov ds,ax    		;potem ladujemy z akumulatora do wlasciwego rejestru
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
			
			mov dh, 12 ; dh = y
			mov dl, 3 ; dl = x
			
			call setCursor
			
			add zmienna+1,1 
			mov si, offset zmienna+1
			movsb
			
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;WYCHODZIMY Z PROGRAMU
			mov     ah,4ch
			mov	    al,0
	        int	    21h
			;PROCEDURY
	setCursor: ;ustawianie kursora ekranu na odpowiednich koordynatach 
				mov di, 0 ; zerujemy adres kursora
				mov cl,dh ;ustawiamy licznik petli dla przesuwania y
				cmp dh,0
				je addX ;jeśli y = 0, czyli jestemy w 1szym rzedzie
				call loopY ; jestli y != 0, przesuwamy kursor w pionie
			addX:
				call checkEven
				mov dh,0 ;zerujemy dodanego juz y, zeby mozna bylo dodac x jako 16-bit
				add di,dx ; przesuwamy kursor w poziomie 
			RET		
			
	loopY: ;przesuwamy kursor wg y
		add di,160
		loop loopY
	RET
	checkEven: ;jesli x jest nieparzyste, to dodaje 1
			mov dh, 1
			and dh,dl ;jesli dl jest parzyste, to dh bedzie rowne 0
			jz checkEvenEnd
			add dl,1
		checkEvenEnd:	
	RET
			
codeSegment     ends

dataSegment     segment
	zmienna db 'a','c','e'
dataSegment     ends
stackSegment    segment
				dw    100h dup(0)
stackTop        Label word
stackSegment    ends
end start