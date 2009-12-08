unit info;

interface
	procedure help;
	procedure pause;
	function goodtext(var archivo : text) : boolean;
	
implementation
	uses crt;

	const
		HELPFILE = 'help';

	function goodtext(var archivo : text) : boolean;
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
		goodtext := ret;
	end;

	procedure pause;
	begin
		writeln('Presione una tecla para continuar...');
		readkey;
	end;

	procedure help;
	var
		fhelpfile : text;
		dump : string;
	begin
		assign(fhelpfile, HELPFILE);
		if goodtext(fhelpfile) then
			while not eof(fhelpfile) do
			begin
				readln(fhelpfile, dump);
				writeln(dump);
			end;
	end;
end.

