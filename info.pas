unit info;

interface
	const
		PROMPT	= ': ';

		NO_FILE = 'Archivo no disponible';
		EMPTY_FILE = 'Archivo vacío';
		PRESSTOCONTINUE = 'Presione una tecla para continuar';

	procedure readbyte(var ret : byte);
	procedure pause;
	function goodtext(var archivo : text) : boolean;
	
implementation
	uses crt;

	procedure readbyte(var ret : byte);
	begin
		repeat
			{$I-}
			readln(ret);
			{$I+}
		until ioresult = 0;
	end;

	function goodtext(var archivo : text) : boolean;
	begin
		{$I-}
		reset(archivo);
		{$I+}
		if (ioresult = 0) then
			goodtext := true
		else
			goodtext := false;
	end;

	procedure pause;
	begin
		writeln(PRESSTOCONTINUE);
		readkey;
	end;
end.

