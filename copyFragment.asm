codeSegment    segment
			assume cs:codeSegment, ds:dataSegment, ss:stackSegment ;Mowimy, ktory blok/segment jest ktory
start:      
			;USTAWIAMY WSZYSTKIE POTRZEBNE REJESTRY NA WARTOSCI POCZATKOWE
			mov ax,dataSegment  ;najpierw ladujemy do akumulatora z 'labela'
			mov ds,ax    		
			mov ax,stackSegment
			mov ss,ax
			mov sp,offset stackTop
			mov ax,0B800h
			mov es,ax
			
			mov ax,0
			mov bx,0
			mov cx,5
			mov dx,0
			
			copyFragment: ; NIE MOZE KORZYSTAC ZE ZMIENNYCH (ewentualnie stos) ;TODO: SPRAWDZANIE OUT OF BOUNDS
				;AX - width,height XY
				;BX - coords from YX
				;CX
				;DX - coords to YX
				mov cl,al	;HEIGHT razy bedzie sie wykonywac petla
				copyY:
					push cx
					call reverseRange ;AH, CL -> CH (offset)
					push dh
						mov cl,dh ;COPY Y ES
						add cl,ch ;Y + OFFSET
						mov dh,ch ;ES Y
						call makeIndexXY		;zamieniam x,y na adres pola
						mov di,dx					;W DX ZNAJDUJA SIE COORDY LEWEGO GORNEGO ROGU ES
					pop dh
					
					push dh	
						mov cl,bh ;COPY Y DS
						add cl,ch ;Y + OFFSET
						mov dh,ch ;DS Y
						call makeIndexXY		;zamieniam x,y na adres pola
						mov si,dx					;W DX ZNAJDUJA SIE COORDY LEWEGO GORNEGO ROGU DS
					pop dh
					
					xor ch,ch	;zeruje counter
					mov cl,ah	;WIDTH razy bedzie sie wykonywac petla
					copyX:
						movsw
						loop copyX
					pop cx
					loop copyY
			RET
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;WYCHODZIMY Z PROGRAMU
			mov     ah,4ch
			mov	    al,0
	        int	    21h
			
			reverseRange:
				mov ch,ah 
				sub ch,cl ;N-0 na 0-N
			RET
			
			makeIndexXY:
			
			RET
codeSegment     ends

dataSegment     segment
			zmienna db 'a'
dataSegment     ends

stackSegment    segment
				dw    100h dup(0)
stackTop        Label word
stackSegment    ends
end start