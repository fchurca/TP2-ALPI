unit color;

interface
	type
		Tcolor = record
			codigo : byte;
			Descripcion : string [20];
		end;

		FTcolor = file of Tcolor;

	function goodFTcolor(var archivo : FTcolor) : boolean;
	function altaFTcolor(var archivo : FTcolor) : boolean overload;
	function bajaFTcolor(var archivo : FTcolor) : boolean overload;
	function modificarFTcolor(var archivo : FTcolor) : boolean overload;
	function informarFTcolor(var archivo : FTcolor) : boolean overload;

implementation
	uses info;

	function goodFTcolor(var archivo : FTcolor) : boolean;
	var
		ret : boolean;
	begin
		ret := true;
		{$I-}
		reset(archivo);
		{$I+}
		if (ioresult <> 0) then
		begin
			{$I-}
			rewrite(archivo);
			{$I+}
			if (ioresult <> 0) then
				ret := false;
		end;
		goodFTcolor := ret;
	end;

	function altaFTcolor(var archivo : FTcolor) : boolean overload;
	var
		reg : Tcolor; codigo : byte;
		ret : boolean;
	begin
		ret := goodFTcolor(archivo);
		if ret then
		begin
			repeat
				begin
				writeln('Ingrese código ');
				readln(codigo);
				end;
			until codigo in [1..254];

			while not (eof(archivo) or (codigo = reg.codigo))  do
				read(archivo,reg);

			if codigo = reg.codigo then
			begin
				writeln('Ya existe. Tal vez quiere modificarlo.');
				ret := false;
			end
			else
			begin
				reg.codigo := codigo;
				writeln('Ingrese descripción');
				readln(reg.descripcion);
				write(archivo,reg);
			end;
		end
		else writeln('Archivo no disponible');
		altaFTcolor := ret;
	end;

	function bajaFTcolor(var archivo : FTcolor) : boolean overload;
	var
		ret : boolean;
	begin
		writeln('Dummy function for colour entry deletion');
		ret := goodFTcolor(archivo);
		bajaFTcolor := ret;
	end;

	function modificarFTcolor(var archivo : FTcolor) : boolean overload;
	var
		reg : Tcolor;
		ret : boolean;
		pos : integer;
	begin
		ret := goodFTcolor(archivo);
		modificarFTcolor := ret;
	end;

	function informarFTcolor(var archivo : FTcolor) : boolean overload;
	var
		reg : Tcolor;
		ret : boolean;
	begin
		ret := goodFTcolor(archivo);
		if ret then
		begin
			if not eof(archivo) then
				writeln('Codigo	Descripción');
			while not eof(archivo) do
			begin
				read(archivo, reg);
				writeln(reg.codigo, '	', reg.descripcion);
			end
		end
		else writeln('Archivo no disponible');
		informarFTcolor := ret;
		pause;
	end;
end.

