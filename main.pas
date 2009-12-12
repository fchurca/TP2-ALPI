program TP2;

uses crt, dos, info, menu, color{, tamano, objeto};

const
	PROGNAME = 'TP2 Grupo 4';

procedure mainmenu;
	procedure modificar(var parent : Rmenu);
		var
			this : Rmenu;
			ans:char;
		begin
			initmenu(parent, this, 'Modificar');
			repeat
				vprompt(this);
				readln(ans);
				case	ans of
//					'o': Omenu(this);
					'c': Cmenu(this);
//					't': Tmenu(this);
					's': ;
				end;
			until (ans='s');
		end;
	var
		this : Rmenu;
		ans:char;
	begin
		initrootmenu(this, PROGNAME, 'Principal');
		repeat
			vprompt(this);
			readln(ans);
			case	ans of
				'm': modificar(this);
//				'i': informar(archc);
//				'a': actualizar;
				's': ;
			end;
		until (ans = 's');
	end;
	
var
	y,m,d,w:word;
begin
	clrscr;
	man(PROGNAME);
	pause;

	mainmenu;

	getdate(y,m,d,w);
	writeln('date: ',y,'-',m,'-',d,':',w);
end.
