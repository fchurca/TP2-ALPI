program informar;
uses crt, info, deposito, color, tamano, objeto;



Type
	TICC = record
		codigo:byte;
		cantidad:longint;
	end;
	TICT = Record
		codigo:char;
		cantidad:longint;
	end;

	TablaCcolores = array[1 .. 254] of TICC;
	TablaCtamanos = array['A' .. 'Z'] of TICT;

function cargarcantidades(
	var archivoO : FTobjeto; var archivoC : FTcolor; var archivoT : FTtamano; var archivoD : FTdeposito;
	var TablaCcolores : TablaCcolores; var TablaCtamanos : TablaCtamanos
) : boolean;
	var	
		TablaCobjetos : TTobjeto;
		regO : Tobjeto;
		regD : Tdeposito;
		regC : Tcolor;
		regT : Ttamano;
		i : byte;
		j, k : char;
		c : longint;
		pass : boolean;
	begin
		pass := goodFTcolor(archivoC);
		if not pass then writeln(NO_FILE, PROMPT, COLOURFILE);
		if pass then begin
			pass := goodFTtamano(archivoT);
			if not pass then writeln(NO_FILE, PROMPT, SIZEFILE);
		end;
		if pass then begin
			pass := goodFTdeposito(archivoD);
			if not pass then writeln(NO_FILE, PROMPT, DEPOTFILE);
		end;
		if pass then begin
			pass := goodFTobjeto(archivoO);
			if not pass then writeln(NO_FILE, PROMPT, OBJECTFILE);
		end;
		if pass then begin
			for i:=1 to 254 do begin
				tablaCcolores[i].codigo := 0;
				tablaCcolores[i].cantidad := 0;
			end;
			for j:='A' to 'Z' do begin
				tablaCtamanos[j].codigo := ' ';
				tablaCtamanos[j].cantidad := 0;
			end;

			while not eof(archivoC) do begin
				read(archivoC, regC);
				if goodcolorcode(regC.codigo) then begin
					tablaCcolores[regC.codigo].codigo := regC.codigo;
				end else writeln('Color inválido: ', regC.codigo);
			end;
			while not eof(archivoT) do begin
				read(archivoT, regT);
				if isalpha(regT.codigo) then begin
					regT.codigo := toupper(regT.codigo);
					tablaCtamanos[RegT.codigo].codigo := RegT.codigo;
				end else writeln('Tamaño inválido: ', regT.codigo);
			end;
			loadFTobjeto(archivoO, TablaCobjetos);

			while pass and not eof(archivoD) do begin
			 read(archivoD, regD);
			 pass := goodcolorcode(regD.color);
			 if not pass then writeln('Color inválido para el depósito ', regD.codigo, PROMPT, regD.color);
			 if pass then begin
			  pass := goodtamanocode(regD.tamano);
			  if not pass then writeln('Tamaño inválido para el depósito ', regD.codigo, PROMPT, regD.tamano);
			 end;
			 i := 1;
			 while pass and (i <= DEPOTSIZE) do begin
			  j := regD.objetos[i].codigo[1];
			  k := regD.objetos[i].codigo[2];
			  if (j in ['A'..'Z']) and (k in ['A'..'Z']) then begin
			   c := regD.objetos[i].cantidad;
			   if TablaCobjetos[j][k].isactive then begin
			    if TablaCobjetos[j][k].pos > filesize(archivoO) then begin
			     writeln('Tabla de objetos inconsistente con ', OBJECTFILE);
			     pass := false;
			    end else begin
			     seek(archivoO, TablaCobjetos[j][k].pos);
			     read(archivoO, regO);
			     if (j <> regO.codigo[1]) or (k <> regO.codigo[2]) then begin
			      writeln('Tabla de objetos inconsistente con ', OBJECTFILE);
			      pass := false;
			     end else begin
			      if regO.tamano in ['A'..'Z'] then
			       if regO.color in [1..254] then begin
			        inc(tablaCcolores[regO.color].cantidad, c);
			        inc(tablaCtamanos[regO.tamano].cantidad, c);
			       end else writeln('Color inválido para ', j, k, PROMPT, regO.color)
			      else writeln('Tamaño inválido para ', j, k, PROMPT, regO.tamano);
			     end;
			    end;
			   end
			   else writeln('Objeto inexistente: ', j, k);
			  end
			  else if (j <> '?') or (k <> '?') then
			   writeln('Objeto inválido: ', j, k);
			 end;
			end;
		end;
		cargarcantidades := pass;
	end;


//2. Cuántos objetos hay de cada color y tamano
Procedure I2(var TablaCcolores : TablaCcolores);

		var
	i:byte;
	begin

	writeln('cod color','	cantidad');
	For i:=1 to 254 do
	writeln(tablaccolores[i].codigo,'	',tablaccolores[i].cantidad);

	end;

procedure I3(var TablaCtamanos : TablaCtamanos);

	var
	i:char;
	begin
	writeln('tamano	cantidad');
	for i:='a' to 'z' do
	writeln(tablaCtamanos[i].codigo,tablaCtamanos[i].cantidad);
	end;


procedure burbujeoCOlores(var A : TablaCcolores);
	var
	i,j:integer;
	temp:TICC;
	 tope:byte;

	begin
	 tope:=254;
	for i:=2 to tope do
		begin
		for j:=1 to tope-1 do
		begin
		if A[j].cantidad > A[j+1].cantidad then
		begin
			 temp:=A[j];
		 A[j]:=A[j+1];
		 A[j+1]:=temp;
		end;
		end;
		end;
		end;

Procedure burbujeotamanos(var A : TablaCtamanos);

var
	i,j:char;
	temp:TICT;
	begin
	for i:='A' to 'Z' do
		begin
		for j:='B' to 'Y' do
		begin
		if A[j].cantidad < A[suc(j)].cantidad then
		begin
			 temp:=A[j];
		 A[j]:=A[suc(j)];
		 A[suc(j)]:=temp;
		end;
		end;
	 end;
	 end;
//4. Para que color/es hay menos objetos.

Procedure I4 (var tablaCcolores : tablaCcolores);
var
i:byte;
begin
		i:=1;
	burbujeocolores(tablaCcolores);

	while tablaCcolores[i].cantidad = 0 do
	inc(i);
	repeat
	writeln(tablaCcolores[i].codigo,'	',tablaCcolores[i].cantidad);
	inc(i);
	until tablaCcolores[i].cantidad<>tablaccolores[i-1].cantidad;

	end;
//5. Para que tamano hay mas objetos
procedure I5(var TablaCtamanos : TablaCtamanos);

	var
	I:char;
	begin
	burbujeotamanos(tablaCtamanos);
	for I:='A'to 'Z' do
		writeln(tablaCtamanos[i].codigo,'	',tablactamanos[i].cantidad);
	end;


var

Ccolores:FTcolor;
Ctamanos:FTtamano;
Cdepositos:FTdeposito;


begin
	assign(Ccolores,COLOURFILE);
	assign(Ctamanos,SIZEFILE);
	assign(Cdepositos,DEPOTFILE);

	pause;
end.

