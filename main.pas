program TP2;

uses crt, dos, info, menu, color, tamano, objeto;

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
				ans := toupper(ans);
				case	ans of
					'O' : ret := Omenu(this);
					'C' : ret := Cmenu(this);
					'T' : ret := Tmenu(this);
					'S' : ;
				end;
			until (ans = 'S') or not ret;
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
				ans := toupper(ans);
			case	ans of
				'M' : ret := modificar(this);
//				'A' : ret := actualizar;
//				'I' : informar(archc);
				'S': ;
			end;
		until (ans = 'S') or not ret;
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
