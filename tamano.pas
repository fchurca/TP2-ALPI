unit tamano;

interface
	uses menu;
	const
		TDESCLEN = 20;
		SIZEFILE = 'tamanos.dat';

	type
		Ttamano = record
			codigo : char;
			Descripcion : string [20];
		end;

		Fttamano = file of Ttamano;
		TTtamano = array ['A'..'Z'] of record
			isactive : boolean;
			descripcion : string [TDESCLEN];
		end;

	function Tmenu(var parent : Rmenu) : boolean;

	function goodtamanocode(code : char) : boolean;
	procedure readtamanocode(var code : char);

	function goodFTtamano(var archivo : FTtamano) : boolean;
	function ensuregoodFTtamano(var archivo : FTtamano) : boolean;

	function loadFTtamano(var archivo : FTtamano; var tabla :TTtamano) : boolean;
	function saveFTtamano(var archivo : FTtamano; var tabla :TTtamano) : boolean;

	function addTTtamanoentry(var tabla : TTtamano) : boolean;
	function removeTTtamanoentry(var tabla : TTtamano) : boolean;
	function editTTtamanoentry(var tabla : TTtamano) : boolean;
	procedure dumpTTtamano(var tabla : TTtamano);

implementation
	uses info;

	function goodtamanocode(code : char) : boolean;
		begin
			if code in ['A'..'Z'] then
				goodtamanocode := true
			else
				goodtamanocode := false;
		end;

	procedure readtamanocode(var code : char);
		begin
			repeat
				readln(code);
				code := toupper(code);
			until goodtamanocode(code);
		end;

	function goodFTtamano(var archivo : FTtamano) : boolean;
		var
			ret : boolean;
		begin
			ret := false;
			{$I-}
			reset(archivo);
			{$I+}
			if (ioresult = 0) then
				ret := true;
			goodFTtamano := ret;
		end;

	function ensuregoodFTtamano(var archivo : FTtamano) : boolean;
		var
			ret : boolean;
		begin
			ret := goodFTtamano(archivo) ;
			if not ret then
			begin
				{$I-}
				rewrite(archivo);
				{$I+}
				if (ioresult = 0) then
					ret := true;
			end;
			ensuregoodFTtamano := ret;
		end;


	function loadFTtamano(var archivo : FTtamano;var tabla :TTtamano) : boolean;
		var
			reg : Ttamano;
			c, ans, i : char;
		begin
			if goodFTtamano(archivo) then
			begin
				for i := 'A' to 'Z' do
					tabla[i].isactive := false;
				while (not eof(archivo)) do
				begin
					read(archivo,reg);
					c := toupper(reg.codigo);
					if tabla[c].isactive then
					begin
						writeln(c, ' ya existe (',tabla[c].descripcion, '). Sobreescribir con ', reg.descripcion, '? (s/N)');
						readln(ans);
						if toupper(ans) = 'S' then
						begin
							tabla[c].descripcion := reg.descripcion;
							tabla[c].isactive := true;
						end;
					end
					else
					begin
						tabla[c].descripcion := reg.descripcion;
						tabla[c].isactive := true;
					end;
				end;
				loadFTtamano := true;
			end
			else loadFTtamano := false;
		end;

	function saveFTtamano(var archivo : FTtamano; var tabla : TTtamano) : boolean;
		var
			reg : Ttamano;
			i : char;
		begin
			{$I-}
			rewrite(archivo);
			{$I+}
			if (ioresult = 0) then
			begin
				for i := 'A' to 'Z' do
					if tabla[i].isactive then
					begin
						reg.codigo := i;
						reg.descripcion := tabla[i].descripcion;
						write(archivo,reg);
					end;
				saveFTtamano := true;
			end
			else saveFTtamano := false;
		end;

	function Tmenu(var parent : Rmenu) : boolean;
		var
			this : Rmenu;
			ans : char;
			archivo : FTtamano;
			tabla : TTtamano;
		begin
			Tmenu := false;
			initmenu(parent, this, 'Tamaños');
			assign(archivo, SIZEFILE);
			if ensuregoodFTtamano(archivo) then
			begin
				if loadFTtamano(archivo, tabla) then
				begin
					repeat
						vprompt(this);
						readln(ans);
						case	ans of
							'a' : addTTtamanoentry(tabla);
							'b' : removeTTtamanoentry(tabla);
							'm' : editTTtamanoentry(tabla);
							'v' : dumpTTtamano(tabla);
							's' : ;
						end;
						if ans in ['a','b','m','v'] then pause;
					until (ans = 's');
					if saveFTtamano(archivo, tabla) then
						Tmenu := true;
				end
				else
					writeln(NO_FILE, SIZEFILE);
			end;
			if not Tmenu then
				writeln('Error al procesar ', SIZEFILE);
		end;

	function addTTtamanoentry (var tabla : TTtamano): boolean;
		var
			agregado : boolean;
			cod : char;
			desc : string;
		begin
			agregado := false;
			writeln('Código del tamaño: ');
			readtamanocode(cod);
			if tabla[cod].isactive then
				writeln('El tamaño existe')
			else
			begin
				repeat
					writeln('Descripcion: ');
					read(desc);
				until length(desc) < TDESCLEN;
				tabla[cod].descripcion := desc;
				tabla[cod].isactive := true;
				agregado := true;
			end;
			addTTtamanoentry := agregado;
		end;

	function removeTTtamanoentry (var tabla : TTtamano): boolean;
		var
			cod : char;
			existe : boolean;
		begin
			existe := false;
			writeln('Código del tamaño: ');
			readtamanocode(cod);
			if tabla[cod].isactive then
			begin
				tabla[cod].isactive := false;
				existe := true;
				writeln(tabla[cod].descripcion);
			end
			else writeln('No hay qué borrar');
			removeTTtamanoentry := existe;
		end;

	function editTTtamanoentry(var tabla : TTtamano): boolean;
		var
			cod : char;
			desc : string;
		begin
			writeln ('Código del tamaño: ');
			readtamanocode(cod);
			if tabla[cod].isactive = true then
			begin
				repeat
					writeln('Descripción vieja: ', tabla[cod].descripcion);
					writeln('Descripción nueva: ');
					read(desc);
				until length(desc) < TDESCLEN;
				tabla[cod].descripcion := desc;
			end
			else writeln('No hay qué modificar');
			editTTtamanoentry := tabla[cod].isactive;
		end;

	procedure dumpTTtamano(var tabla : TTtamano);
		var
			i : char;
		begin
			writeln('Código | Descripción');
			for i := 'A' to 'Z' do
				if tabla[i].isactive then
					writeln(i : 6,' | ',tabla[i].descripcion);
		end;
end.
