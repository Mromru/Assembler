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