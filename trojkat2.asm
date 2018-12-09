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
			
			mov di,160
			add zmienna, 1 
			mov si, offset zmienna
			movsb
			;mov es:[di],zmienna

			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;WYCHODZIMY Z PROGRAMU
			mov     ah,4ch
			mov	    al,0
	        int	    21h
codeSegment     ends

dataSegment     segment
	zmienna db 'a'
dataSegment     ends
stackSegment    segment
				dw    100h dup(0)
stackTop        Label word
stackSegment    ends
end start