program TP2;

uses crt, dos, info, menu, color{, tamano, objeto};

const
	PROGNAME = 'TP2 Grupo 4';

procedure modificar(var archivo:FTcolor; var parent : Rmenu);
	procedure Coperacion(var parent : Rmenu);
	var
		this : Rmenu;
		ans:char;
	begin
		initmenu(parent, this, 'Colores');
		repeat
			vprompt(this);
			readln(ans);
			case	ans of
				'a': altaFTcolor(archivo);
				'b': bajaFTcolor(archivo);
				'm': modificarFTcolor(archivo);
				'v': informarFTcolor(archivo);
				's': ;
			end;
			if not (ans = 's') then pause;
		until (ans='s');
	end;
var
	this : Rmenu;
	ans:char;
begin
	initmenu(parent, this, 'Modificar');
	repeat
		vprompt(this);
		readln(ans);
		case	ans of
			'o': ;
			'c': Coperacion(this);
			't': ;
			's': ;
		end;
	until (ans='s');
end;

var
	ans: char;
	archC:FTcolor;
	y,m,d,w:word;
	this : Rmenu;
begin
	initrootmenu(this, PROGNAME, 'Principal');
	assign(archC, COLOURFILE);
	clrscr;
	help;
	pause;
	repeat
		vprompt(this);
		readln(ans);
		case	ans of
			'm': modificar(archC, this);
{			'i': informar(archc);
			'a': actualizar;}
			's': ;
			else writeln('Comando inválido');
		end;
	until (ans = 's');

	getdate(y,m,d,w);
	writeln('date: ',y,'-',m,'-',d,':',w);
end.
