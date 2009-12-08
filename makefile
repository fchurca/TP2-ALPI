.PHONY: clean

all: main.o info.o menu.o color.o tamano.o objeto.o

main.o: main.pas
	fpc $?

info.o: info.pas
	fpc $?

color.o: color.pas
	fpc $?

tamano.o: tamano.pas
	fpc $?

objeto.o: objeto.pas
	fpc $?

tidy:
	rm *.o *.ppu

debug: all
	./main

clean:
	make tidy; rm main *~
