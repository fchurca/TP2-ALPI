program TP2;

uses crt, info, menu, color, tamano, objeto, deposito, processing;

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
					'D' : ret := Dmenu(this);
					'S' : ret := true;
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
				'A' : ret := actualizar;
//				'I' : informar(archc);
				'S': ret := true;
			end;
		until (ans = 'S') or not ret;
	end;
begin
	clrscr;
	man(PROGNAME);
	pause;

	mainmenu;
end.
