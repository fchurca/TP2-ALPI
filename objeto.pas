unit objeto;

interface
	uses info, menu, color, tamano;

	const
		OBJECTFILE = 'objetos.dat';

	type
		Ocodigo = array[1..2] of char;
		Tobjeto = record
			codigo : Ocodigo;
			color : byte;
			tamano : char;
			descripcion : string [DESCLEN];
		end;

		FTobjeto = file of Tobjeto;
		TTobjetoentry = record
			isactive : boolean;
			pos:integer;
		end;
		TTobjeto = array ['A'..'Z','A'..'Z'] of TTobjetoentry;

		Cset = set of byte;
		Tset = set of char;

	function Omenu(var parent : Rmenu) : boolean;

	procedure loadFTobjeto (var archivo: FTobjeto; var regT: TTobjeto);
	function saveFTobjeto(var archivo: FTobjeto; var tabla : TTobjeto) : boolean;

// addTTobjetoentry: agrega un objeto traído de teclado
	procedure addTTobjetoentry(var archivo : FTobjeto; var tabla : TTobjeto; var colores : Cset ; var tamanos : Tset);

// removeTTobjetoentry: marca como inactivo un objeto traido de teclado
	procedure removeTTobjetoentry(var archivo : FTobjeto; var tabla : TTobjeto);

// editTTobjetoentry : cambian el tamano, color y descripcion de un objeto
	procedure editTTobjetoentry(var archivo: FTobjeto; var tabla : TTobjeto; var colores : Cset ; var tamanos : Tset; parent : Rmenu);

// informarTTobjeto : vuelca el contenido de la tabla a la pantalla (saltear inactivos)
	procedure dumpTTobjeto(var archivo: FTobjeto; var tabla : TTobjeto);
	procedure seeTTobjeto(var archivo: FTobjeto; var tabla : TTobjeto);

implementation
	function goodFTobjeto(var archivo : FTobjeto) : boolean;
		var
			ret : boolean;
		begin
			ret := false;
			{$I-}
			reset(archivo);
			{$I+}
			if (ioresult = 0) then
				ret := true;
			goodFTobjeto := ret;
		end;

	function ensuregoodFTobjeto(var archivo : FTobjeto) : boolean;
		var
			ret : boolean;
		begin
			ret := goodFTobjeto(archivo) ;
			if not ret then
			begin
				{$I-}
				rewrite(archivo);
				{$I+}
				if (ioresult = 0) then
					ret := true;
			end;
			ensuregoodFTobjeto := ret;
		end;
	function Omenu(var parent : Rmenu) : boolean;
		var
			this : Rmenu;
			ans : char;
			Oarchivo : FTobjeto;
			Otabla : TTobjeto;
			Tarchivo : FTtamano;
			Ttabla : TTtamano;
			tamanos : set of char;
			Carchivo : FTcolor;
			Ctabla : TTcolor;
			colores : set of byte;
			i : byte;
			c : char;
		begin
			Omenu := false;
			initmenu(parent, this, 'Objetos');
			assign(Oarchivo, OBJECTFILE);
			assign(Carchivo, COLOURFILE);
			assign(Tarchivo, SIZEFILE);
			if ensuregoodFTobjeto(Oarchivo) then
			begin
				loadFTobjeto(Oarchivo, Otabla);
				if goodFTcolor(Carchivo) then
				begin
					loadFTcolor(Carchivo, Ctabla);
					close(Carchivo);
					colores := [];
					for i := 1 to 254 do
						if Ctabla[i].isactive then
							colores := colores + [i];
					if goodFTtamano(Tarchivo) then
					begin
						loadFTtamano(Tarchivo, Ttabla);
						close(Tarchivo);
						tamanos := [];
						for c := 'A' to 'Z' do
							if Ttabla[c].isactive then
								tamanos := tamanos + [c];
						repeat
							vprompt(this);
							readln(ans);
							ans := toupper(ans);
							case	ans of
								'A' : addTTobjetoentry(Oarchivo, Otabla, colores, tamanos);
								'B' : removeTTobjetoentry(Oarchivo, Otabla);
								'M' : editTTobjetoentry(Oarchivo, Otabla, colores, tamanos, this);
								'V' : seeTTobjeto(Oarchivo, Otabla);
								'I' : dumpTTobjeto(Oarchivo, Otabla);
								'S' : ;
							end;
							if ans in ['A','B','M','V','I'] then pause;
						until (ans = 'S');
						if saveFTobjeto(Oarchivo, Otabla) then
							Omenu := true;
					end
					else writeln(NO_FILE, SIZEFILE);
				end
				else writeln(NO_FILE, COLOURFILE);
				reset(Oarchivo);
				close(Oarchivo);
			end
			else writeln(NO_FILE, OBJECTFILE);
		end;

	procedure readOcodigo(var reg : Ocodigo);
		var
			str : string;
		begin
			repeat
				readln(str);
			until isalpha(str[1]) and isalpha(str[2]);
			reg[1] := toupper(str[1]);
			reg[2] := toupper(str[2]);
		end;

{Cargamos la Tabla tipo TTobjeto donde guardamos: }
	procedure loadFTobjeto (var archivo: FTobjeto; var regT: TTobjeto);
		var
			i, j: char;
			reg : Tobjeto;
			pos : integer;
		begin
			for i:='A' to 'Z'  do for j:='A' to 'Z' do
					regT[i][j].isactive := false;
			pos := 0;
			
			reset(archivo);
		{Recorremos el archivo cargando isactive:=TRUE y pos:=posicion del registro en base a los objetos encontrados}
			while not eof(archivo) do
			begin
				read(archivo, reg);
				regT[reg.codigo[1], reg.codigo[2]].isactive := true;
				regT[reg.codigo[1], reg.codigo[2]].pos := pos;
				inc(pos);
			end;
		end;

	procedure addTTobjetoentry(var archivo : FTobjeto; var tabla : TTobjeto; var colores : Cset ; var tamanos : Tset);
		var
			reg: Tobjeto;
		begin
			writeln('Ingrese Codigo de Objeto:');
			repeat
				readOcodigo(reg.codigo);
				if tabla[reg.codigo[1], reg.codigo[2]].isactive then
					writeln('Ya existe');
			until not tabla[reg.codigo[1], reg.codigo[2]].isactive;

			writeln('Ingrese Descricion del objeto');
			readdesc(reg.descripcion);

			repeat
				writeln('Ingrese Codigo del color del objeto: ');
				readln(reg.color);
			until reg.color in colores;
			repeat
				writeln('Ingrese Codigo del Tamano: ');
				readln(reg.tamano);
				reg.tamano := toupper(reg.tamano);
			until reg.tamano in tamanos;

			seek(archivo, filesize(archivo));

			write(archivo,reg);
			tabla[reg.codigo[1], reg.codigo[2]].isactive := true;
			tabla[reg.codigo[1], reg.codigo[2]].pos := filesize(archivo) - 1;
		end;

	procedure removeTTobjetoentry(var archivo:FTobjeto; var tabla : TTobjeto);
		var
			reg : Tobjeto;
		begin
			writeln('Ingrese Codigo de Objeto:');
			readOcodigo(reg.codigo);

			if tabla[reg.codigo[1],reg.codigo[2]].isactive then
				tabla[reg.codigo[1],reg.codigo[2]].isactive := false
			else
				writeln('El objeto que intenta borrar no existe!!');
		end;

	procedure editTTobjetoentry(var archivo: FTobjeto; var tabla : TTobjeto; var colores : Cset ; var tamanos : Tset; parent : Rmenu);
		var
			ans : char;
			reg : Tobjeto;
			this : Rmenu;
		begin
			initmenu(parent, this, 'Modificar objeto');
			writeln('Ingrese Codigo de Objeto:');
			readOcodigo(reg.codigo);
			if tabla[reg.codigo[1], reg.codigo[2]].isactive then
			begin
				repeat
					seek(archivo, tabla[reg.codigo[1], reg.codigo[2]].pos);
					read(archivo, reg);
					seek(archivo,(tabla[reg.codigo[1],reg.codigo[2]].pos));
					vprompt(this);
					writeln(reg.codigo[1],reg.codigo[2]);
					writeln('Descripción: ', reg.descripcion);
					writeln('Color:       ', reg.color);
					writeln('Tamaño:      ', reg.tamano);
					write(PROMPT);
					readln(ans);
					ans := toupper(ans);
					case ans of
					'D' :
					begin
						writeln('Nueva descripicion:');
						readdesc(reg.descripcion);
						write(archivo, reg);
					end;
					'C' :
					begin
						repeat
							writeln('Nuevo color: ');
							readbyte(reg.color);
						until reg.color in colores;
						write(archivo, reg);
					end;
					'T' :
					begin
						repeat
							writeln('Nuevo tamaño: ');
							readln(reg.tamano);
							reg.tamano := toupper(reg.tamano);
						until reg.tamano in tamanos;
						write(archivo, reg);
					end;
					'S' : ;
					end;
				until ans = 'S';
			end;
		end;

{Una vez terminado el procedimiento de ABM de objetos, se actualizan los cambios}
{en un nuevo archivo temporal segun los cambios en la Tabla, se borra el original}
{y se renombra el temporal}
	function saveFTobjeto(var archivo : FTobjeto; var tabla :TTobjeto) : boolean;
		var
			reg : Tobjeto;
			temp : FTobjeto;
		begin
			assign(temp,'$temp.dat$');
			rewrite(temp);
			reset(archivo);

			while not eof(archivo) do
			begin
				read(archivo,reg);
				if tabla[reg.codigo[1], reg.codigo[2]].isactive then
					write(temp,reg);
			end;

			close(archivo);
			erase(archivo);

			close(temp);
			saveFTobjeto := true;
			rename(temp,OBJECTFILE);
		end;

	procedure dumpTTobjeto(var archivo: FTobjeto; var tabla : TTobjeto);
		var
			i, j : char;
			reg : Tobjeto;

		begin
		reset(archivo);
		writeln;
		writeln('Código|      Descripción     | Color | Tamaño');
		for i:='A' to 'Z'  do for j:='A' to 'Z' do
				if tabla[i,j].isactive then
				begin
					seek(archivo, (tabla[i,j].pos));
					read(archivo,reg);
					writeln(reg.codigo[1], reg.codigo[2], '    | ', reg.descripcion : 20, ' | ', reg.color:5, ' | ', reg.tamano:6);
				end;
		end;

	procedure seeTTobjeto(var archivo: FTobjeto; var tabla : TTobjeto);
		var
			reg : Tobjeto;
		begin
			writeln('Ingrese Codigo de Objeto:');
			readOcodigo(reg.codigo);
			if tabla[reg.codigo[1], reg.codigo[2]].isactive then
			begin
				seek(archivo, (tabla[reg.codigo[1], reg.codigo[2]].pos));
				read(archivo,reg);
				writeln('Código|      Descripción     | Color | Tamaño');
				writeln(reg.codigo[1], reg.codigo[2], '    | ', reg.descripcion : 20, ' | ', reg.color:3, ' | ', reg.tamano:4);
			end
			else writeln('No existe');
		end;
end.

