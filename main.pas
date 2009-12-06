program TP2;

uses crt, dos;

type
	Tcolor = record
		cod:word;
		Descripcion: string [20];
	end;

	tarchcolor=file of Tcolor;

procedure prompt(menulevel: integer);
begin
	while(menulevel > 0) do
	begin;
		write('>');
		dec(menulevel);
	end;
end;

procedure Alta(var Archivo:tarchcolor);
var
	reg:tcolor;
	long:byte;
begin
	reset(archivo);
	while not eof(archivo) do
		read(Archivo,reg);

	repeat
		begin
		writeln('Ingrese código ');
		readln(reg.cod);
		end;
	until (reg.cod>0) and (reg.cod<255);

	repeat
	writeln('Ingrese descripción');
	readln(reg.descripcion);
	long:=length(reg.descripcion);{funcion q devuelve la longitud de un string}
	until (long>0) and (long<21);

	write(archivo,reg);

end;

procedure about;
begin
end;

procedure help;
begin
end;

procedure informar(var archivo:tarchcolor);
var
	reg:tcolor;

begin
	reset(archivo);
	while not eof(archivo) do
	begin
		read(archivo,reg);
		writeln(reg.cod,'	',reg.descripcion);
	end;
end;

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
	assign(archC,'Colores.dat');
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
