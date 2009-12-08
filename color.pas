unit color;

interface
	type
		Tcolor = record
			codigo : byte;
			Descripcion : string [20];
		end;

		FTcolor = file of Tcolor;

	function goodFTcolor(var archivo : FTcolor) : boolean;
	function validCdesc(desc:string):boolean;

	function altaFTcolor(var archivo : FTcolor) : boolean;
	function bajaFTcolor(var archivo : FTcolor) : boolean;
	function modificarFTcolor(var archivo : FTcolor) : boolean;
	function informarFTcolor(var archivo : FTcolor) : boolean;

implementation
	uses info;

	function validCdesc(desc:string):boolean;
	begin
		if length(desc) in [1..20] then validCdesc := true
		else validCdesc := false;
	end;

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

	function altaFTcolor(var archivo : FTcolor) : boolean;
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

			if not eof(archivo) then
			begin
				read(archivo, reg);
				while not (eof(archivo) or (codigo = reg.codigo))  do
					read(archivo,reg);
			end;

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

	function bajaFTcolor(var archivo : FTcolor) : boolean;
	var
		ret : boolean;
	begin
		writeln('Dummy function for colour entry deletion');
		ret := goodFTcolor(archivo);
		bajaFTcolor := ret;
	end;

	function modificarFTcolor(var archivo : FTcolor) : boolean;
	var
		cod : byte;
		pos : byte;
		reg : tcolor;
		desc : string;
		encontrado:boolean;
	begin
		encontrado := goodFTcolor(archivo);
		if encontrado then
		begin
			writeln('Ingrese codigo');
			readln(cod);
			encontrado := false;
			pos := 0;
			while not (encontrado or eof(archivo)) do
			begin
				read(archivo,reg);
				inc(pos);
				if ((reg.codigo) = cod) then
					encontrado:=true;
			end;
			reset(archivo);
			while pos > 1 do
			begin
				read(archivo,reg);
				dec(pos);
			end;
			writeln('Descripción previa:');
			writeln(reg.descripcion);
			repeat
				writeln('Ingrese la nueva descripción');
				readln(desc);
			until validCdesc(desc);
			reg.descripcion := desc;
			write(archivo,reg);
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
		else writeln('Archivo no disponible');
		informarFTcolor := ret;
	end;
end.

