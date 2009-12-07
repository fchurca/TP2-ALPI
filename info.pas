unit info;

interface
	procedure prompt(menulevel: integer);
	procedure about;
	procedure help;
	function goodfile(var archivo : file) : boolean overload;
	function goodfile(var archivo : text) : boolean overload;
	
implementation
	const
		HELPFILE = 'help';

	function goodfile(var archivo : file) : boolean;
	var
		ret : boolean;
	begin
		{$I-}
		reset(archivo);
		{$I+}
		if (ioresult <> 0) then
		begin
			writeln('Archivo no disponible');
			ret := false;
		end
		else
			ret := true;
		goodfile := ret;
	end;

	function goodfile(var archivo : text) : boolean overload;
	var
		ret : boolean;
	begin
		{$I-}
		reset(archivo);
		{$I+}
		if (ioresult <> 0) then
		begin
			writeln('Archivo no disponible');
			ret := false;
		end
		else
			ret := true;
		goodfile := ret;
	end;

	procedure prompt(menulevel: integer);
	begin
		while(menulevel > 0) do
		begin;
			write('>');
			dec(menulevel);
		end;
	end;

	procedure about;
	begin
	end;

	procedure help;
	var
		fhelpfile : text;
		dump : string;
	begin
		assign(fhelpfile, HELPFILE);
		if goodfile(fhelpfile) then
			while not eof(fhelpfile) do
			begin
				readln(fhelpfile, dump);
				writeln(dump);
			end;
	end;
end.

