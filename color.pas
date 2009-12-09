unit color;

interface
	const
		CDESCLEN = 20;
		COLOURFILE = 'colores.dat';

	type
		Tcolor = record
			codigo : byte;
			Descripcion : string [CDESCLEN];
		end;

		FTcolor = file of Tcolor;

	function goodFTcolor(var archivo : FTcolor) : boolean;
	function ensuregoodFTcolor(var archivo : FTcolor) : boolean;

	function altaFTcolor(var archivo : FTcolor) : boolean;
	function bajaFTcolor(var archivo : FTcolor) : boolean;
	function modificarFTcolor(var archivo : FTcolor) : boolean;
	function informarFTcolor(var archivo : FTcolor) : boolean;

implementation
	uses info;

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

	function altaFTcolor(var archivo : FTcolor) : boolean;
	var
		reg : Tcolor; codigo : byte;
		desc : string;
		ret : boolean;
	begin
		ret := ensuregoodFTcolor(archivo);
		if ret then
		begin
			repeat
				begin
				writeln('Ingrese código ');
				readbyte(codigo);
				end;
			until codigo in [0..254];

			if not eof(archivo) and (codigo < 255)  then
			begin
				read(archivo, reg);
				while not (eof(archivo) or (codigo = reg.codigo))  do
					read(archivo,reg);

				if codigo = reg.codigo then
				begin
					writeln('Ya existe (', reg.descripcion, ')');
					ret := false;
				end
				else
				begin
					reg.codigo := codigo;
					repeat
						writeln('Ingrese descripción');
						readln(desc);
					until length(desc) <= CDESCLEN;
					reg.descripcion := desc;
					write(archivo,reg);
				end;
			end;
		end
		else writeln(NO_FILE);
		altaFTcolor := ret;
	end;

	function bajaFTcolor(var archivo : FTcolor) : boolean;
	var
		ret : boolean;
		codigo : byte;
		archaux : FTcolor;
		reg : Tcolor;
	begin
		ret := false;
		if goodFTcolor(archivo) then
		begin
			assign(archaux,'$TMP$');
			{$I-}
			rewrite(archaux);
			{$I+}
			if ioresult = 0 then
			begin
				ret := true;
				writeln('Ingrese el código del color a borrar');
				readbyte(codigo);
				while not eof(archivo) do
				begin
					read(archivo,reg);
					if codigo <> reg.codigo then
						write(archaux,reg)
					else
						writeln(reg.descripcion);
				end;
				close(archaux);
				close(archivo);
				erase(archivo);
				rename(archaux, COLOURFILE);
			end
			else close(archivo);
		end;
		bajaFTcolor := ret;
	end;

	function modificarFTcolor(var archivo : FTcolor) : boolean;
	var
		pos : word;
		reg, aux : tcolor;
		desc : string;
		encontrado:boolean;
	begin
		encontrado := goodFTcolor(archivo);
		if encontrado then
		begin
			writeln('Ingrese el código del color a modificar');
			readbyte(aux.codigo);
			encontrado := false;
			pos := 0;
			while not (encontrado or eof(archivo)) do
			begin
				read(archivo,reg);
				inc(pos);
				if ((reg.codigo) = aux.codigo) then
				begin
					encontrado:=true;
					aux.descripcion := reg.descripcion;
				end;
			end;
			reset(archivo); { When translating to objects: seek(archivo, pos -1) }
			while pos > 1 do
			begin
				read(archivo,reg);
				dec(pos);
			end;		{ End translation note }
			
			writeln('Descripción previa:');
			writeln(aux.descripcion);
			repeat
				writeln('Ingrese la nueva descripción');
				readln(desc);
			until length(desc) <= CDESCLEN;
			aux.descripcion := desc;
			write(archivo, aux);
		end;
		modificarFTcolor := encontrado;
	end;

	function informarFTcolor(var archivo : FTcolor) : boolean;
	var
		reg : Tcolor;
		ret : boolean;
	begin
		ret := goodFTcolor(archivo);
		if ret then
		begin
			if not eof(archivo) then
				writeln('Codigo | Descripción');
			while not eof(archivo) do
			begin
				read(archivo, reg);
				writeln(reg.codigo:3, '    | ', reg.descripcion);
			end
		end
		else writeln(NO_FILE);
		informarFTcolor := ret;
	end;
end.

