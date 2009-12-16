program TP2;

uses crt, info, menu, color, tamano, objeto, deposito, processing, report;

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
	begin
		initrootmenu(this, PROGNAME, 'Principal');
		repeat
			vprompt(this);
			readln(ans);
				ans := toupper(ans);
			case	ans of
				'M' : modificar(this);
				'A' : actualizar;
				'I' : Imenu(this);
			end;
		until ans = 'S';
	end;
begin
	clrscr;
	man(PROGNAME);
	pause;

	mainmenu;
end.
