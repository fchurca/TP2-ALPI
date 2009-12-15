unit deposito;

interface
	uses info, menu, objeto;

	const
		DEPOTFILE = 'depositos.dat';
		LOCLEN = 30;
		DEPOTSIZE = 30;

	type
		Dcodigo = string[3];
		TvectorObj = array[1..DEPOTSIZE] of record
			codigo : Dcodigo;
			cantidad : longint;
		end;
		Tdeposito = record
			codigo : Dcodigo;
			descripcion : string[DESCLEN];
			ubicacion : String[LOCLEN];
			tamano : char;
			color : byte;
			Objetos : tvectorobj;
		end;

		FTdeposito = file of Tdeposito;
		TTdepositoentry = record
			isactive : boolean;
			pos:integer;
		end;
		TTdeposito = array ['A'..'Z','A'..'Z','A'..'Z'] of TTdepositoentry;

	function Dmenu(var parent : Rmenu) : boolean;

	function goodFTdeposito(var archivo : FTdeposito) : boolean;

	procedure loadFTdeposito (var archivo: FTdeposito; var regT: TTdeposito);
	function saveFTdeposito(var archivo: FTdeposito; var tabla : TTdeposito) : boolean;
	function emptyFTdepositoresults(var archivo : FTdeposito) : boolean;
// addTTdepositoentry: agrega un deposito traído de teclado
	procedure addTTdepositoentry(var archivo : FTdeposito; var tabla : TTdeposito);

// removeTTdepositoentry: marca como inactivo un deposito traido de teclado
	procedure removeTTdepositoentry(var archivo : FTdeposito; var tabla : TTdeposito);

// editTTdepositoentry : cambian el tamano, color y descripcion de un deposito
	procedure editTTdepositoentry(var archivo: FTdeposito; var tabla : TTdeposito; var parent : Rmenu);

// informarTTdeposito : vuelca el contenido de la tabla a la pantalla (saltear inactivos)
	procedure dumpTTdeposito(var archivo: FTdeposito; var tabla : TTdeposito);
	procedure seeTTdeposito(var archivo: FTdeposito; var tabla : TTdeposito);

implementation
	function emptyFTdepositoresults(var archivo : FTdeposito) : boolean;
		var
			ret : boolean;
			i, pos : integer;
			reg : Tdeposito;
		begin
			ret := goodFTdeposito(archivo);
			if ret then begin
				pos := 0;
				while not eof(archivo) do begin
					seek(archivo, pos);
					read(archivo, reg);
					for i := 1 to DEPOTSIZE do
					begin
						reg.objetos[i].codigo[1] := '?';
						reg.objetos[i].codigo[2] := '?';
						reg.objetos[i].cantidad := 0;
					end;
					seek(archivo, pos);
					write(archivo, reg);
					inc(pos);
				end;
				close(archivo);
			end;
			emptyFTdepositoresults := ret;
		end;

	function goodFTdeposito(var archivo : FTdeposito) : boolean;
		var
			ret : boolean;
		begin
			ret := false;
			{$I-}
			reset(archivo);
			{$I+}
			if (ioresult = 0) then
				ret := true;
			goodFTdeposito := ret;
		end;

	function ensuregoodFTdeposito(var archivo : FTdeposito) : boolean;
		var
			ret : boolean;
		begin
			ret := goodFTdeposito(archivo) ;
			if not ret then
			begin
				{$I-}
				rewrite(archivo);
				{$I+}
				if (ioresult = 0) then
					ret := true;
			end;
			ensuregoodFTdeposito := ret;
		end;

	function Dmenu(var parent : Rmenu) : boolean;
		var
			this : Rmenu;
			ans : char;
			archivo : FTdeposito;
			tabla : TTdeposito;
		begin
			Dmenu := false;
			initmenu(parent, this, 'Depositos');
			assign(archivo, DEPOTFILE);
			if ensuregoodFTdeposito(archivo) then
			begin
				loadFTdeposito(archivo, tabla);
				repeat
					vprompt(this);
					readln(ans);
					ans := toupper(ans);
					case	ans of
						'A' : addTTdepositoentry(archivo, tabla);
						'B' : removeTTdepositoentry(archivo, tabla);
						'M' : editTTdepositoentry(archivo, tabla, this);
						'V' : seeTTdeposito(archivo, tabla);
						'I' : dumpTTdeposito(archivo, tabla);
						'S' : ;
					end;
					if ans in ['A','B','M','V','I'] then pause;
				until (ans = 'S');
				if saveFTdeposito(archivo, tabla) then
					Dmenu := true;
				reset(archivo);
				close(archivo);
			end
			else writeln(NO_FILE, DEPOTFILE);
		end;

	procedure readDcodigo(var reg : dcodigo);
		var
			str : string;
		begin
			repeat
				readln(str);
			until isalpha(str[1]) and isalpha(str[2]) and isalpha(str[3]);
			reg := toupper(str[1]) + toupper(str[2]) + toupper(str[3]);
		end;

{Cargamos la Tabla tipo TTdeposito donde guardamos: }
	procedure loadFTdeposito (var archivo: FTdeposito; var regT: TTdeposito);
		var
			i, j, k: char;
			reg : Tdeposito;
			pos : integer;
		begin
			for i:='A' to 'Z' do for j:='A' to 'Z' do for k:='A' to 'Z' do
			begin
				regT[i][j][k].isactive := false;
			end;
			pos := 0;
			
			reset(archivo);
		{Recorremos el archivo cargando isactive:=TRUE y pos:=posicion del registro en base a los depositos encontrados}
			while not eof(archivo) do
			begin
				read(archivo, reg);
				regT[reg.codigo[1], reg.codigo[2], reg.codigo[3]].isactive := true;
				regT[reg.codigo[1], reg.codigo[2], reg.codigo[3]].pos := pos;
				inc(pos);
			end;
		end;

	procedure addTTdepositoentry(var archivo : FTdeposito; var tabla : TTdeposito);
		var
			reg: Tdeposito;
		begin
			writeln('Ingrese Codigo de deposito:');
			readDcodigo(reg.codigo);
			if tabla[reg.codigo[1], reg.codigo[2], reg.codigo[3]].isactive then
				writeln('Ya existe')
			else begin
				writeln('Ingrese descripción del deposito');
				readdesc(reg.descripcion, DESCLEN);

				writeln('Ingrese ubicación del deposito');
				readdesc(reg.ubicacion, LOCLEN);

				writeln('Ingrese Codigo del color del deposito: ');
				readln(reg.color);

				writeln('Ingrese Codigo del tamaño: ');
				readln(reg.tamano);
				reg.tamano := toupper(reg.tamano);

				seek(archivo, filesize(archivo));

				write(archivo,reg);
				tabla[reg.codigo[1], reg.codigo[2], reg.codigo[3]].isactive := true;
				tabla[reg.codigo[1], reg.codigo[2], reg.codigo[3]].pos := filesize(archivo) - 1;
			end;
		end;

	procedure removeTTdepositoentry(var archivo:FTdeposito; var tabla : TTdeposito);
		var
			reg : Tdeposito;
		begin
			writeln('Ingrese Codigo de deposito:');
			readDcodigo(reg.codigo);

			if tabla[reg.codigo[1],reg.codigo[2], reg.codigo[3]].isactive then
				tabla[reg.codigo[1],reg.codigo[2], reg.codigo[3]].isactive := false
			else
				writeln('El deposito que intenta borrar no existe!!');
		end;

	procedure editTTdepositoentry(var archivo: FTdeposito; var tabla : TTdeposito; var parent : Rmenu);
		var
			ans : char;
			reg : Tdeposito;
			this : Rmenu;
		begin
			initmenu(parent, this, 'Modificar deposito');
			writeln('Ingrese Codigo de deposito:');
			readDcodigo(reg.codigo);
			if tabla[reg.codigo[1], reg.codigo[2], reg.codigo[3]].isactive then
			begin
				repeat
					seek(archivo, tabla[reg.codigo[1], reg.codigo[2], reg.codigo[3]].pos);
					read(archivo, reg);
					seek(archivo,(tabla[reg.codigo[1],reg.codigo[2], reg.codigo[3]].pos));
					vprompt(this);
					writeln(reg.codigo[1],reg.codigo[2], reg.codigo[3]);
					writeln('Descripción: ', reg.descripcion);
					writeln('Ubicación:   ', reg.ubicacion);
					writeln('Color:       ', reg.color);
					writeln('Tamaño:      ', reg.tamano);
					write(PROMPT);
					readln(ans);
					ans := toupper(ans);
					case ans of
					'D' :
					begin
						writeln('Nueva descripicion:');
						readdesc(reg.descripcion, DESCLEN);
						write(archivo, reg);
					end;
					'U' :
					begin
						writeln('Nueva ubicación:');
						readdesc(reg.ubicacion, LOCLEN);
						write(archivo, reg);
					end;
					'C' :
					begin
						writeln('Nuevo color: ');
						readbyte(reg.color);
						write(archivo, reg);
					end;
					'T' :
					begin
						writeln('Nuevo tamaño: ');
						readln(reg.tamano);
						reg.tamano := toupper(reg.tamano);
						write(archivo, reg);
					end;
					'S' : ;
					end;
				until ans = 'S';
			end;
		end;

{Una vez terminado el procedimiento de ABM de depositos, se actualizan los cambios}
{en un nuevo archivo temporal segun los cambios en la Tabla, se borra el original}
{y se renombra el temporal}
	function saveFTdeposito(var archivo : FTdeposito; var tabla :TTdeposito) : boolean;
		var
			reg : Tdeposito;
			temp : FTdeposito;
		begin
			assign(temp,'$temp.dat$');
			rewrite(temp);
			reset(archivo);

			while not eof(archivo) do
			begin
				read(archivo,reg);
				if tabla[reg.codigo[1], reg.codigo[2], reg.codigo[3]].isactive then
					write(temp,reg);
			end;

			close(archivo);
			erase(archivo);

			close(temp);
			saveFTdeposito := true;
			rename(temp,DEPOTFILE);
		end;

	procedure dumpTTdeposito(var archivo: FTdeposito; var tabla : TTdeposito);
		var
			i, j, k : char;
			reg : Tdeposito;

		begin
		reset(archivo);
		writeln;
		writeln('Código|      Descripción     |            Ubicacion           | Color | Tamaño');
		for i:='A' to 'Z' do for j:='A' to 'Z' do for k:='A' to 'Z' do
				if tabla[i,j,k].isactive then
				begin
					seek(archivo, (tabla[i,j,k].pos));
					read(archivo,reg);
					writeln(reg.codigo[1], reg.codigo[2], reg.codigo[3], '   | ',
						reg.descripcion : DESCLEN, ' | ',
						reg.ubicacion:LOCLEN, ' | ',
						reg.color:5, ' | ', reg.tamano:6
					);
				end;
		end;

	procedure seeTTdeposito(var archivo: FTdeposito; var tabla : TTdeposito);
		var
			reg : Tdeposito;
		begin
			writeln('Ingrese Codigo de deposito:');
			readDcodigo(reg.codigo);
			if tabla[reg.codigo[1], reg.codigo[2], reg.codigo[3]].isactive then
			begin
				seek(archivo, (tabla[reg.codigo[1], reg.codigo[2], reg.codigo[3]].pos));
				read(archivo,reg);
				writeln('Código|      Descripción     |            Ubicacion           | Color | Tamaño');
				writeln(reg.codigo[1], reg.codigo[2], reg.codigo[3], '   | ',
						reg.descripcion : DESCLEN, ' | ',
						reg.ubicacion:LOCLEN, ' | ',
						reg.color:5, ' | ', reg.tamano:6
					);
			end
			else writeln('No existe');
		end;
end.

