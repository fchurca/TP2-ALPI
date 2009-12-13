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

	function isalpha(c : char) : boolean;
	function isnumber(c : char) : boolean;
	function isupper(c : char) : boolean;
	function islower(c : char) : boolean;
	function toupper(c : char) : char;
	function tolower(c : char) : char;
	
implementation
	uses crt;


	function isalpha(c : char) : boolean;
		begin
			if isupper(c) or islower(c) then
				isalpha := true
			else
				isalpha := false;
		end;

	function isnumber(c : char) : boolean;
		begin
			if c in ['0'..'9'] then
				isnumber := true
			else
				isnumber := false;
		end;

	function isupper(c : char) : boolean;
		begin
			if c in ['A'..'Z'] then
				isupper := true
			else
				isupper := false;
		end;

	function islower(c : char) : boolean;
		begin
			if c in ['a'..'z'] then
				islower := true
			else
				islower := false;
		end;

	function toupper(c : char) : char;
		begin
			if islower(c) then
				toupper := c - 'a' + 'A';
			else
				toupper := c;
		end;

	function tolower(c : char) : char;
		begin
			if isupper(c) then
				tolower := c - 'A' + 'a';
			else
				tolower := c;
		end;


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

