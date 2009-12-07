unit colour;

interface
	type
		Tcolor = record
			cod:word;
			Descripcion: string [20];
		end;
		tarchcolor=file of Tcolor;

	procedure alta(var Archivo:tarchcolor);
	procedure baja(var Archivo:tarchcolor);
	procedure modificar(var Archivo:tarchcolor);
	procedure informar(var archivo:tarchcolor);

implementation
	procedure alta(var Archivo:tarchcolor);
	var
		reg:tcolor;
	begin
		reset(archivo);
		while not eof(archivo) do
			read(Archivo,reg);

		repeat
			begin
			writeln('Ingrese código ');
			readln(reg.cod);
			end;
		until reg.cod in [1..254];

		writeln('Ingrese descripción');
		readln(reg.descripcion);
		write(archivo,reg);
	end;

	procedure baja(var Archivo:tarchcolor);
	begin
		writeln('Dummy function for colour entry deletion');
	end;

	procedure modificar(var Archivo:tarchcolor);
	begin
		writeln('Dummy function for colour entry modification');
	end;

	procedure informar(var archivo:tarchcolor);
	var
		reg:tcolor;

	begin
		reset(archivo);
		while not eof(archivo) do
		begin
			read(archivo,reg);
			writeln(reg.cod,'	',reg.descripcion);
		end;
	end;
end.

