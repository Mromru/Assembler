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
			
			
			copyFragment: ; NIE MOZE KORZYSTAC ZE ZMIENNYCH (ewentualnie stos)
				;AX - width,heightS
				;BX - coords from
				;CX
				;DX - coords to
				push cx
				call makeindexXY
				pop cx
			RET
			
			startProgram:
				;call drawTrojkat
				;call setupCopy
				;quit
			RET
			
			setupCopy: ;MOZE KORZYSTAC ZE ZMIENNYCH
				;AX -> załaduj rozmiar dotychczas zrobionego trojkata sierpinskiego
				;BX -> zaladuj lewy gorny rog dotychczas zrobionego trojkata sierpinskiego
			
				;DX -> zaladuj miejsce, w ktore trzeba skopiowac calosc
				;WYWOLANIE COPYFRAGMENT
				;DX -> zaladuj miejsce -||- jako drugi trojkat
				;WYWOLANIE COPYFRAGMENT
			RET
			
			
			pointDSToScreen:
				mov ax,0B800h
				mov ds,ax
			RET
			
			revertDS:
				mov ax,dataSegment
				mov ds,ax
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