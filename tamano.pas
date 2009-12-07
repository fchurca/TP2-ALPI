unit tamano;

interface
	uses info;
	type
		Ttamano = record
			codigo : char;
			Descripcion : string [20];
		end;

		TFtamano = file of Ttamano;

	function alta(var archivo : TFtamano) : boolean overload;
	function baja(var archivo : TFtamano) : boolean overload;
	function modificar(var archivo : TFtamano) : boolean overload;
	function informar(var archivo : TFtamano) : boolean overload;

implementation
	function alta(var archivo : TFtamano) : boolean overload;
	var
		reg : Ttamano;
		ret : boolean;
	begin
		ret := goodfile(archivo);
		if ret then
		begin
			while not eof(archivo) do
				read(archivo,reg);

			writeln('Ingrese código ');
			readln(reg.codigo);

			writeln('Ingrese descripción');
			readln(reg.descripcion);

			write(archivo,reg);
			ret := true;
		end;
		alta := ret;
	end;

	function baja(var archivo : TFtamano) : boolean overload;
	var
		ret : boolean;
	begin
		writeln('Dummy function for size entry deletion');
		ret := goodfile(archivo);
		baja := ret;
	end;

	function modificar(var archivo : TFtamano) : boolean overload;
	var
		ret : boolean;
	begin
		writeln('Dummy function for size entry modification');
		ret := goodfile(archivo);
		modificar := ret;
	end;

	function informar(var archivo : TFtamano) : boolean overload;
	var
		reg : Ttamano;
		ret : boolean;
	begin
		ret := goodfile(archivo);
		if ret then
			while not eof(archivo) do
			begin
				read(archivo, reg);
				writeln(reg.codigo, '	', reg.descripcion);
			end;
		informar := ret;
	end;
end.
