unit menu;

interface
	const
		EMPTY	= '';
		HSEP	= '/';

	type
		Rmenu = record
			owner, name, fullname : string;
		end;

	function man(fun : string) : boolean;

	procedure initrootmenu(var menu : Rmenu; owner, name : string);
	procedure inheritmenu(var parent, child : Rmenu);
	procedure initmenu(var parent, child : Rmenu; name : string);
	procedure promptmenu(var menu : Rmenu);
	procedure vprompt(var menu : Rmenu);

implementation
	uses crt, info;
	const
		MANFILE		 = 'manfile';
	{ Messages }
		MAN_NOENTRY	= 'No hay entrada de manual para ';
		MAN_EMPTYENTRY	= 'Entrada de manual vacía para ';
{
manual
Format:
	<terminator>
	fun1
		help
		contents
		can
		use
		several
		lines
	<terminator>
	fun2
	...
	<terminator>
Actually, fun can be anything, not just a function.
}
	function man(fun : string) : boolean;
	var
		doc : text;
		terminator, dump : string;
		found, ret : boolean;
	begin
	{ Assume we won't find fun }
		found := false;
		ret := false;
	{ Need a readable non-empty manual }
		assign(doc, MANFILE);
		if goodtext(doc)then
		begin
			if not eof(doc) then
			begin
			{ Recognize terminator }
				readln(doc, terminator);
			{ Find fun }
				while not (eof(doc) or found) do
				begin
				{ Do we have fun? }
					readln(doc, dump);
					if fun = dump then
					begin
						found := true;
					{ If we have more than just a header, we have fun }
						if not eof(doc) then
							readln(doc,dump);
						if (dump <> terminator) and not eof(doc) then
						begin
							ret := true;
							{ Help with using fun }
							repeat
								writeln(dump);
								readln(doc, dump);
							until eof(doc) or (dump = terminator)
						end
					{ We found empty fun }
						else writeln(MAN_EMPTYENTRY, fun);
					end;
				end;
				{ We didn't find fun }
				if not found then writeln(MAN_NOENTRY, fun);
			end
			{ Empty manfile }
			else writeln(EMPTY_FILE, PROMPT, MANFILE);
			{ Close open good manfile }
			close(doc);
		end
		{ No manfile }
		else writeln(NO_FILE, PROMPT, MANFILE);
		man := ret;
	end;

	procedure initrootmenu(var menu : Rmenu; owner, name : string);
	begin
		menu.owner := owner;
		menu.name := name;
		menu.fullname := name + HSEP;
	end;

	procedure inheritmenu(var parent, child : Rmenu);
	begin
		child.owner := parent.owner;
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
		writeln(menu.fullname);
	end;

	procedure vprompt(var menu : Rmenu);
	begin
		promptmenu(menu);
		man(menu.name);
		write(PROMPT);
	end;
end.
