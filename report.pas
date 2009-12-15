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
	var Tablacolores : TablaCcolores; var Tablatamanos : TablaCtamanos
) : boolean;
	var	
		Tablaobjetos : TTobjeto;
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
				tablacolores[i].codigo := 0;
				tablacolores[i].cantidad := 0;
			end;
			for j:='A' to 'Z' do begin
				tablatamanos[j].codigo := ' ';
				tablatamanos[j].cantidad := 0;
			end;

			while not eof(archivoC) do begin
				read(archivoC, regC);
				if goodcolorcode(regC.codigo) then begin
					tablacolores[regC.codigo].codigo := regC.codigo;
				end else writeln('Color inválido: ', regC.codigo);
			end;
			while not eof(archivoT) do begin
				read(archivoT, regT);
				if isalpha(regT.codigo) then begin
					regT.codigo := toupper(regT.codigo);
					tablatamanos[RegT.codigo].codigo := RegT.codigo;
				end else writeln('Tamaño inválido: ', regT.codigo);
			end;
			loadFTobjeto(archivoO, Tablaobjetos);

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
			   if Tablaobjetos[j][k].isactive then begin
			    if Tablaobjetos[j][k].pos > filesize(archivoO) then begin
			     writeln('Tabla de objetos inconsistente con ', OBJECTFILE);
			     pass := false;
			    end else begin
			     seek(archivoO, Tablaobjetos[j][k].pos);
			     read(archivoO, regO);
			     if (j <> regO.codigo[1]) or (k <> regO.codigo[2]) then begin
			      writeln('Tabla de objetos inconsistente con ', OBJECTFILE);
			      pass := false;
			     end else begin
			      if regO.tamano in ['A'..'Z'] then
			       if regO.color in [1..254] then begin
			        inc(tablacolores[regO.color].cantidad, c);
			        inc(tablatamanos[regO.tamano].cantidad, c);
			       end else writeln('Color inválido para ', j, k, PROMPT, regO.color)
			      else writeln('Tamaño inválido para ', j, k, PROMPT, regO.tamano);
			     end;
			    end;
			   end
			   else writeln('Objeto inexistente: ', j, k);
			  end
			  else if (j <> '?') or (k <> '?') then
			   writeln('Objeto inválido: ', j, k);
			  inc(i);
			 end;
			end;
		end;
		cargarcantidades := pass;
	end;


//2. Cuántos objetos hay de cada color y tamano
Procedure I2(var Tablacolores : TablaCcolores);
	var
		i:byte;
	begin
		writeln('Color | Cantidad');
		for i:=1 to 254 do
			if tablacolores[i].cantidad > 0 then
				writeln(tablacolores[i].codigo:5, ' | ', tablacolores[i].cantidad);
	end;

procedure I3(var Tablatamanos : TablaCtamanos);
	var
		i : char;
	begin
		writeln('Tamaño | Cantidad');
		for i:= 'A' to 'Z' do
			if tablatamanos[i].cantidad > 0 then
				writeln(tablatamanos[i].codigo:6, ' | ', tablatamanos[i].cantidad);
	end;


procedure burbujeoCOlores(var A : TablaCcolores; ascending : boolean);
	var
		i, j : integer;
		temp : TICC;

	begin
		for i:=1 to 253 do
		begin
			for j:=1 to 253 do
			begin
				if (A[j].cantidad > A[j+1].cantidad) xor ascending then
				begin
					temp := A[j];
					A[j] := A[j+1];
					A[j+1] := temp;
				end;
			end;
		end;
	end;

procedure burbujeotamanos(var A : TablaCtamanos; ascending : boolean);
	var
		i, j : char;
		temp:TICT;
	begin
		for i:='A' to 'Y' do
			begin
			for j:='A' to 'Y' do
			begin
				if (A[j].cantidad > A[suc(j)].cantidad) xor ascending then
				begin
					temp := A[j];
					A[j] := A[suc(j)];
					A[suc(j)] := temp;
				end;
			end;
		end;
	end;
//4. Para que color/es hay menos objetos.

Procedure I4 (var tablacolores : tablaCcolores);
	var
		i:byte;
	begin
		i:=1;
		burbujeocolores(tablacolores, false);

		while (tablacolores[i].cantidad = 0) and (i <= 254) do inc(i);
		repeat
			writeln(tablacolores[i].codigo,' ',tablacolores[i].cantidad);
			inc(i);
		until (tablacolores[i].cantidad<>tablacolores[i-1].cantidad) or (i > 254);
	end;
//5. Para que tamano hay mas objetos
procedure I5(var Tablatamanos : TablaCtamanos);
	var
		I:char;
	begin
		burbujeotamanos(tablatamanos, true);
		writeln(tablatamanos['A'].codigo, ' ', tablatamanos['A'].cantidad);
		for I:='B' to 'Z' do
			if tablatamanos[i].cantidad = tablatamanos['A'].cantidad then
				writeln(tablatamanos[i].codigo,' ',tablatamanos[i].cantidad);
	end;
var
	Cobjetos : FTobjeto;
	Ccolores : FTcolor;
	Ctamanos : FTtamano;
	Cdepositos : FTdeposito;
	Tablacolores : TablaCcolores;
	Tablatamanos : TablaCtamanos;
begin
	assign(Ccolores, COLOURFILE);
	assign(Ctamanos, SIZEFILE);
	assign(Cdepositos, DEPOTFILE);
	assign(Cobjetos, OBJECTFILE);
	cargarcantidades(Cobjetos, Ccolores, Ctamanos, Cdepositos, Tablacolores, Tablatamanos);
	pause;
end.

