unit color;

interface
	uses menu;
	const
		CDESCLEN = 20;
		COLOURFILE = 'colores.dat';

	type
		Tcolor = record
			codigo : byte;
			Descripcion : string [CDESCLEN];
		end;

		FTcolor = file of Tcolor;
		TTcolor = array [1..254] of record
			isactive : boolean;
			descripcion : string [CDESCLEN];
		end;

	function Cmenu(var parent : Rmenu) : boolean;

	function goodcolorcode(code : byte) : boolean;
	procedure readcolorcode(var code : byte);

	function goodFTcolor(var archivo : FTcolor) : boolean;
	function ensuregoodFTcolor(var archivo : FTcolor) : boolean;

	function loadFTcolor(var archivo : FTcolor; var tabla :TTcolor) : boolean;
	function saveFTcolor(var archivo : FTcolor; var tabla :TTcolor) : boolean;

	function addTTcolorentry(var tabla : TTcolor) : boolean;
	function removeTTcolorentry(var tabla : TTcolor) : boolean;
	function editTTcolorentry(var tabla : TTcolor) : boolean;
	procedure seeTTcolor(var tabla : TTcolor);
	procedure dumpTTcolor(var tabla : TTcolor);

implementation
	uses info;

	function goodcolorcode(code : byte) : boolean;
		begin
			if code in [1..254] then
				goodcolorcode := true
			else
				goodcolorcode := false;
		end;

	procedure readcolorcode(var code : byte);
		begin
			repeat
				readln(code);
			until goodcolorcode(code);
		end;

	function goodFTcolor(var archivo : FTcolor) : boolean;
		var
			ret : boolean;
		begin
			ret := false;
			{$I-}
			reset(archivo);
			{$I+}
			if (ioresult = 0) then
				ret := true;
			goodFTcolor := ret;
		end;

	function ensuregoodFTcolor(var archivo : FTcolor) : boolean;
		var
			ret : boolean;
		begin
			ret := goodFTcolor(archivo) ;
			if not ret then
			begin
				{$I-}
				rewrite(archivo);
				{$I+}
				if (ioresult = 0) then
					ret := true;
			end;
			ensuregoodFTcolor := ret;
		end;


	function loadFTcolor(var archivo : FTcolor;var tabla :TTcolor) : boolean;
		var
			reg : Tcolor;
			ans : char;
			i : byte;
		begin
			if goodFTcolor(archivo) then
			begin
				for i := 1 to 254 do
					tabla[i].isactive := false;
				while (not eof(archivo)) do
				begin
					read(archivo,reg);
					if tabla[reg.codigo].isactive then
					begin
						writeln(reg.codigo, ' ya existe (',tabla[reg.codigo].descripcion, '). Sobreescribir con ', reg.descripcion, '? (s/N)');
						readln(ans);
						if toupper(ans) = 'S' then
						begin
							tabla[reg.codigo].descripcion := reg.descripcion;
							tabla[reg.codigo].isactive := true;
						end;
					end
					else
					begin
						tabla[reg.codigo].descripcion := reg.descripcion;
						tabla[reg.codigo].isactive := true;
					end;
				end;
				loadFTcolor := true;
			end
			else loadFTcolor := false;
		end;

	function saveFTcolor(var archivo : FTcolor; var tabla : TTcolor) : boolean;
		var
			reg : Tcolor;
			i : byte;
		begin
			{$I-}
			rewrite(archivo);
			{$I+}
			if (ioresult = 0) then
			begin
				for i := 1 to 254 do
					if tabla[i].isactive then
					begin
						reg.codigo := i;
						reg.descripcion := tabla[i].descripcion;
						write(archivo,reg);
					end;
				saveFTcolor := true;
			end
			else saveFTcolor := false;
		end;

	function Cmenu(var parent : Rmenu) : boolean;
		var
			this : Rmenu;
			ans : char;
			archivo : FTcolor;
			tabla : TTcolor;
		begin
			Cmenu := false;
			initmenu(parent, this, 'Colores');
			assign(archivo, COLOURFILE);
			if ensuregoodFTcolor(archivo) then
			begin
				if loadFTcolor(archivo, tabla) then
				begin
					repeat
						vprompt(this);
						readln(ans);
						ans := toupper(ans);
						case	ans of
							'A' : addTTcolorentry(tabla);
							'B' : removeTTcolorentry(tabla);
							'M' : editTTcolorentry(tabla);
							'V' : seeTTcolor(tabla);
							'I' : dumpTTcolor(tabla);
							'S' : ;
						end;
						if ans in ['A','B','M','V','I'] then pause;
					until (ans = 'S');
					if saveFTcolor(archivo, tabla) then
						Cmenu := true;
				end
				else
					writeln(NO_FILE, COLOURFILE);
			end;
			if not Cmenu then
				writeln('Error al procesar ', COLOURFILE);
		end;

	function addTTcolorentry (var tabla : TTcolor): boolean;
		var
			agregado : boolean;
			cod : byte;
			desc : string;
		begin
			agregado := false;
			writeln('Código del color: ');
			readcolorcode(cod);
			if tabla[cod].isactive then
				writeln('El color existe')
			else
			begin
				repeat
					writeln('Descripcion: ');
					readln(desc);
				until length(desc) < CDESCLEN;
				tabla[cod].descripcion := desc;
				tabla[cod].isactive := true;
				agregado := true;
			end;
			addTTcolorentry := agregado;
		end;

	function removeTTcolorentry (var tabla : TTcolor): boolean;
		var
			cod : byte;
			existe : boolean;
		begin
			existe := false;
			writeln('Código del color: ');
			readcolorcode(cod);
			if tabla[cod].isactive then
			begin
				tabla[cod].isactive := false;
				existe := true;
				writeln(tabla[cod].descripcion);
			end
			else writeln('No existe');
			removeTTcolorentry := existe;
		end;

	function editTTcolorentry(var tabla : TTcolor): boolean;
		var
			cod : byte;
			desc : string;
		begin
			writeln ('Código del color: ');
			readcolorcode(cod);
			if tabla[cod].isactive = true then
			begin
				repeat
					writeln('Descripción vieja: ', tabla[cod].descripcion);
					writeln('Descripción nueva: ');
					readln(desc);
				until length(desc) < CDESCLEN;
				tabla[cod].descripcion := desc;
			end
			else writeln('No existe');
			editTTcolorentry := tabla[cod].isactive;
		end;

	procedure dumpTTcolor(var tabla : TTcolor);
		var
			i : byte;
		begin
			writeln('Código | Descripción');
			for i := 1 to 254 do
				if tabla[i].isactive then
					writeln(i : 6,' | ',tabla[i].descripcion);
		end;
	procedure seeTTcolor(var tabla : TTcolor);
		var
			cod : byte;
		begin
			writeln ('Código del color: ');
			readcolorcode(cod);
			if tabla[cod].isactive = true then
				writeln(tabla[cod].descripcion)
			else
				writeln('No existe');
		end;
end.
