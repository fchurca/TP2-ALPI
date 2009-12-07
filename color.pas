unit color;

interface
	uses info;
	type
		Tcolor = record
			codigo : byte;
			Descripcion : string [20];
		end;

		TFcolor = file of Tcolor;

	function alta(var archivo : TFcolor) : boolean overload;
	function baja(var archivo : TFcolor) : boolean overload;
	function modificar(var archivo : TFcolor) : boolean overload;
	function informar(var archivo : TFcolor) : boolean overload;

implementation
	function alta(var archivo : TFcolor) : boolean overload;
	var
		reg : Tcolor;
		ret : boolean;
	begin
		ret := goodfile(archivo);
		if ret then
		begin
			while not eof(archivo) do
				read(archivo,reg);

			repeat
				begin
				writeln('Ingrese código ');
				readln(reg.codigo);
				end;
			until reg.codigo in [1..254];

			writeln('Ingrese descripción');
			readln(reg.descripcion);
			write(archivo,reg);
			ret := true;
		end;
		alta := ret;
	end;

	function baja(var archivo : TFcolor) : boolean overload;
	var
		ret : boolean;
	begin
		writeln('Dummy function for colour entry deletion');
		ret := goodfile(archivo);
		baja := ret;
	end;

	function modificar(var archivo : TFcolor) : boolean overload;
	var
		ret : boolean;
	begin
		writeln('Dummy function for colour entry modification');
		ret := goodfile(archivo);
		modificar := ret;
	end;

	function informar(var archivo : TFcolor) : boolean overload;
	var
		reg : Tcolor;
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

