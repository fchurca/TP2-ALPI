unit objeto;

interface
	uses info;
	type
		Tobjeto = record
			codigo : string[2];
			Descripcion : string [20];
			color : byte;
			tamano : char;
		end;

		TFobjeto = file of Tobjeto;

	function alta(var archivo : TFobjeto) : boolean overload;
	function baja(var archivo : TFobjeto) : boolean overload;
	function modificar(var archivo : TFobjeto) : boolean overload;
	function informar(var archivo : TFobjeto) : boolean overload;

implementation
	function alta(var archivo : TFobjeto) : boolean overload;
	var
		reg : Tobjeto;
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

			repeat
			begin
				writeln('Ingrese color');
				readln(reg.color);
				end;
			until reg.color in [1..254];

			writeln('Ingrese tamaño ');
			readln(reg.tamano);

			write(archivo,reg);
			ret := true;
		end;
		alta := ret;
	end;

	function baja(var archivo : TFobjeto) : boolean overload;
	var
		ret : boolean;
	begin
		writeln('Dummy function for size entry deletion');
		ret := goodfile(archivo);
		baja := ret;
	end;

	function modificar(var archivo : TFobjeto) : boolean overload;
	var
		ret : boolean;
	begin
		writeln('Dummy function for size entry modification');
		ret := goodfile(archivo);
		modificar := ret;
	end;

	function informar(var archivo : TFobjeto) : boolean overload;
	var
		reg : Tobjeto;
		ret : boolean;
	begin
		ret := goodfile(archivo);
		if ret then
			while not eof(archivo) do
			begin
				read(archivo, reg);
				writeln(reg.codigo, '	', reg.descripcion, '	', reg.color, '	', reg.tamano);
			end;
		informar := ret;
	end;
end.
