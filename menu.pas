unit menu;

interface
	const
		HSEP = '/';
		EMPTY = '';
		PROMPT = ':';
		MANFILE = 'manfile';

	type
		Rmenu = record
			owner, name, fullname : string;
			level : integer;
		end;

	procedure RTFM(fun : string);

	procedure initrootmenu(var menu : Rmenu; owner, name : string);
	procedure inheritmenu(var parent, child : Rmenu);
	procedure initmenu(var parent, child : Rmenu; name : string);
	procedure promptmenu(var menu : Rmenu);

implementation
	uses crt, info;

{
Read The Fabulous Manual!
Format:
	<terminator>
	<fun1>
		help
		contents
		can
		use
		several
		lines
	<terminator>
	<fun2>
	...
	<terminator> // optional at end of file
Actually, fun can be anything, not just a function.
}
	procedure RTFM(fun : string);
	var
		doc : text;
		terminator, dump : string;
		found : boolean;
	begin
	{ Assume we won't find fun }
		found := false;
	{ Need a readable non-empty manual }
		assign(doc, MANFILE);
		if goodtext(doc) and not eof(doc) then
		begin
		{ Recognize terminator }
			readln(doc, terminator);
		{ Find fun }
			while not (eof(doc) or found) do
			begin
			{ Do we have fun? }
				read(dump);
				if fun = dump then
				begin
				{ If we have more than just a header, we have fun }
					if not eof then found := true;
					{ Help with using fun }
					while not (eof(doc) or (dump = terminator)) do
					begin
						readln(doc, dump);
						writeln(dump);
					end;
				end;
			end;
		end;
		{ We didn't find fun }
		if not found then
			writeln('No hay entrada de manual para ', fun);
	end;

	procedure initrootmenu(var menu : Rmenu; owner, name : string);
	begin
		menu.owner := owner;
		menu.name := name;
		menu.fullname := name + HSEP;
		menu.level := 0;
	end;

	procedure inheritmenu(var parent, child : Rmenu);
	begin
		child.owner := parent.owner;
		child.level := parent.level + 1;
		child.fullname := parent.fullname + child.name + HSEP;
	end;

	procedure initmenu(var parent, child : Rmenu; name : string);
	begin
		child.name := name;
		inheritmenu(parent, child);
	end;

	procedure promptmenu(var menu : Rmenu);
	begin
		clrscr;
		writeln(menu.owner);
		writeln(menu.fullname + PROMPT);
	end;
end.
