unit report;

interface
	uses menu;

	procedure Imenu(var parent : Rmenu);

implementation

	uses deposito, color, tamano, objeto, info;

	type
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
			depo : Tdeposito;
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
					tablacolores[i].codigo := i;
					tablacolores[i].cantidad := 0;
				end;
				for j:='A' to 'Z' do begin
					tablatamanos[j].codigo := j;
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
				 read(archivoD, depo);
				 pass := goodcolorcode(depo.color);
				 if not pass then writeln('Color inválido para el depósito ', depo.codigo, PROMPT, depo.color);
				 if pass then begin
				  pass := goodtamanocode(depo.tamano);
				  if not pass then writeln('Tamaño inválido para el depósito ', depo.codigo, PROMPT, depo.tamano);
				 end;
				 i := 1;
				 while pass and (i <= DEPOTSIZE) do begin
				  j := depo.objetos[i].codigo[1];
				  k := depo.objetos[i].codigo[2];
				  if (j in ['A'..'Z']) and (k in ['A'..'Z']) then begin
				   c := depo.objetos[i].cantidad;
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

	//2. Cuántos objetos hay de cada color y tamano
	procedure I2(var Tablacolores : TablaCcolores);
		var
			i:byte;
		begin
			writeln('Color | Cantidad');
			for i:=1 to 254 do
				writeln(tablacolores[i].codigo:5, ' | ', tablacolores[i].cantidad);
		end;

	procedure I3(var Tablatamanos : TablaCtamanos);
		var
			i : char;
		begin
			writeln('Tamaño | Cantidad');
			for i:= 'A' to 'Z' do
				writeln(tablatamanos[i].codigo:6, ' | ', tablatamanos[i].cantidad);
		end;
	//4. Para que color/es hay menos objetos.

	procedure I4 (var tablacolores : tablaCcolores);
		var
			i:byte;
		begin
			writeln('Color | Cantidad');
			i:=1;
			burbujeocolores(tablacolores, false);

			while (tablacolores[i].cantidad = 0) and (i <= 254) do inc(i);
			repeat
				writeln(tablacolores[i].codigo:5, ' | ', tablacolores[i].cantidad);
				inc(i);
			until (tablacolores[i].cantidad<>tablacolores[i-1].cantidad) or (i > 254);
		end;
	//5. Para que tamano hay mas objetos
	procedure I5(var Tablatamanos : TablaCtamanos);
		var
			I:char;
		begin
			writeln('Tamaño | Cantidad');
			burbujeotamanos(tablatamanos, true);
			writeln(tablatamanos['A'].codigo:6, ' | ', tablatamanos['A'].cantidad);
			for I:='B' to 'Z' do
				if tablatamanos[i].cantidad = tablatamanos['A'].cantidad then
					writeln(tablatamanos[i].codigo:6, ' | ', tablatamanos[i].cantidad);
		end;

	procedure I6 (var TablaTamanos : TablaCtamanos);
		var
			I:char;
		begin
			writeln('Tamaño | Cantidad');
			burbujeotamanos(tablatamanos, true);
				for I:='A' to 'Z' do
				writeln(tablatamanos[i].codigo:6, ' | ', tablatamanos[i].cantidad);
		end;

	procedure P4(var Fdepositos : FTdeposito; var Tabladepositos : TTdeposito);
		var
			i,j,k:char;
			v,u:byte;
			o : Ocodigo;
			D : Tdeposito;
			encontrado:boolean;
		begin
			encontrado := false;
			writeln('ingrese codigo de objeto :');
			readocodigo(o);
			if not goodFTdeposito(Fdepositos) then
			 writeln(NO_FILE, PROMPT, DEPOTFILE)
			else begin
			 for i:='A' to 'Z' do
			  for j:='A' to 'Z' do
			   for k:='A' to 'Z' do
			    if Tabladepositos[i][j][k].isactive then begin
			     if filesize(Fdepositos) < Tabladepositos[i][j][k].pos then
			      writeln('Archivo corrupto?')
			     else begin
			      seek(Fdepositos,Tabladepositos[i][j][k].pos);
			      read(Fdepositos,D);
			      for u:=1 to 30 do
			       if (D.objetos[u].codigo[1]=o[1]) and (D.objetos[u].codigo[2]=o[2]) then
			       begin
			       	writeln('El objeto ',o,' se encuentra en el deposito ',i,j,k);
			       	writeln('Cantidad almacenada: ', D.objetos[u].cantidad);
			       	encontrado:=true;
			       end;
			      end;
			    end;
			 close(Fdepositos);
			end;
			if not encontrado then
				writeln('Objeto no encontrado');
		end;

	procedure Imenu(var parent : Rmenu);
		var
			this : Rmenu;
			ans : char;
			Cobjetos : FTobjeto;
			Ccolores : FTcolor;
			Ctamanos : FTtamano;
			Cdepositos : FTdeposito;
			Tablacolores : TablaCcolores;
			Tablatamanos : TablaCtamanos;
			Tabladepositos : TTdeposito;
		begin
			initmenu(parent, this, 'Informar');
			assign(Ccolores, COLOURFILE);
			assign(Ctamanos, SIZEFILE);
			assign(Cdepositos, DEPOTFILE);
			assign(Cobjetos, OBJECTFILE);
			if goodFTdeposito(Cdepositos) then begin
				loadFTdeposito(Cdepositos, Tabladepositos);
				cargarcantidades(Cobjetos, Ccolores, Ctamanos, Cdepositos, Tablacolores, Tablatamanos);
				repeat
					vprompt(this);
					readln(ans);
					ans := toupper(ans);
					case ans of
						'1' : dumpTTdeposito(Cdepositos, Tabladepositos);
						'2' : I2(Tablacolores);
						'3' : I3(Tablatamanos);
						'4' : I4(tablacolores);
						'5' : I5(tablatamanos);
						'6' : I6(Tablatamanos);
						'O' : P4(Cdepositos, Tabladepositos);
						'S' : ;
					end;
					if ans <> 'S' then pause;
				until ans = 'S';
			end else writeln(NO_FILE, PROMPT, DEPOTFILE);
		end;
end.
