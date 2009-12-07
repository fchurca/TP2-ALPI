program TP2;

uses crt, dos, color, info;

const
	COLOURFILE = 'colores.dat';

procedure operacion(var archivo:tarchcolor);
var
	ans:char;
begin
	repeat
		writeln('A	Dar de alta un registro');
		writeln('B	Dar de baja un registro');
		writeln('M	Modificar un registro');
		writeln('S	Atrás');
		prompt(3);
		readln(ans);
		case	ans of
			'a': alta(archivo);
			'b': ;
			'm': ;
			's': ;
		end;
	until (ans='s');
	end;


procedure modificar(var archivocolores:tarchcolor);
var
	ans:char;
begin
	repeat
		writeln('C	Archivo de colores');
		writeln('T	Archivo de tamaños');
		writeln('S	Atrás');
		prompt(2);
		readln(ans);
		case	ans of
			'c': Operacion(archivocolores);
			't': ;
			's': ;
		end;
	until (ans='s');
end;

var
	rp: char;
	archC:Tarchcolor;
	y,m,d,w:word;

begin
	assign(archC, COLOURFILE);
	repeat
		writeln('M	Modificar');
		writeln('I	Informar');
		writeln('A	About');
		writeln('H	Help');
		writeln('S	Salir');
		prompt(1);
		readln(rp);
		case	rp of
			'h': help;
			'a': about;
			'm': Modificar(archC);
			'i': informar(archc);
			'b': ;
			's': ;
			else writeln('Comando inválido');
		end;
	until (rp = 's');

	getdate(y,m,d,w);
	writeln('date: ',y,'-',m,'-',d,':',w);
end.
