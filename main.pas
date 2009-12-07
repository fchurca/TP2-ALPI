program TP2;

uses crt, dos, info, color, tamano, objeto;

const
	COLOURFILE = 'colores.dat';

procedure Coperacion(var archivo : TFcolor);
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
			'b': baja(archivo);
			'm': modificar(archivo);
			'i': informar(archivo);
			's': ;
		end;
	until (ans='s');
	end;


procedure modificar(var archivocolores:TFcolor);
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
			'c': Coperacion(archivocolores);
			't': ;
	{idea: manage(sfile); manage(cfile) overloads in units}
			's': ;
		end;
	until (ans='s');
end;

var
	rp: char;
	archC:TFcolor;
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
			'm': modificar(archC);
			'i': informar(archc);
			'b': ;
			's': ;
			else writeln('Comando inválido');
		end;
	until (rp = 's');

	getdate(y,m,d,w);
	writeln('date: ',y,'-',m,'-',d,':',w);
end.
