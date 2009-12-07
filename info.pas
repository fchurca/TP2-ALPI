unit info;

interface
	procedure prompt(menulevel: integer);
	procedure about;
	procedure help;
	
implementation
	const
		HELPFILE = 'help';

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
		{$I-}
		reset(fhelpfile);
		{$I+}
		if (ioresult <> 0) then
			writeln('Help file not available')
		else
			while not eof(fhelpfile) do
			begin
				readln(fhelpfile, dump);
				writeln(dump);
			end;
	end;
end.

