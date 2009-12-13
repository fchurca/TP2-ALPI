program TP2;

uses crt, dos, info, menu, color, tamano{, objeto};

const
	PROGNAME = 'TP2 Grupo 4';

procedure mainmenu;
	function modificar(var parent : Rmenu) : boolean;
		var
			this : Rmenu;
			ans : char;
			ret : boolean;
		begin
			initmenu(parent, this, 'Modificar');
			repeat
				vprompt(this);
				readln(ans);
				case	ans of
//					'o' : ret := Omenu(this);
					'c' : ret := Cmenu(this);
					't' : ret := Tmenu(this);
					's' : ;
				end;
			until (ans = 's') or not ret;
			modificar := ret;
		end;
	var
		this : Rmenu;
		ans:char;
		ret : boolean;
	begin
		initrootmenu(this, PROGNAME, 'Principal');
		repeat
			vprompt(this);
			readln(ans);
			case	ans of
				'm' : ret := modificar(this);
//				'a' : ret := actualizar;
//				'i' : informar(archc);
				's': ;
			end;
		until (ans = 's') or not ret;
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
