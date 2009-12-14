unit depositos;

interface
	uses menu, objeto, info;

	type


		Tcodigo = string[3];

		Tobj = record
			codigo : Ocodigo;
			Cant : integer;
		end;

		TvectorObj = array[1..30] of tobj;

		Tdeposito = record
			codigo : tcodigo;
			denominacion : string[20];
			ubicacion : String[30];
			CODcolor : byte;
			CODtam : char;
			Objetos : tvectorobj;
		end;

		FTdeposito = file of Tdeposito;
//

implementation

	function readobjeto(var archivo, errfile : text; var Otabla : TTobjeto) : boolean;
		var
			Dfile : FTdeposito;
			Ofile : FTobjeto;
			found : boolean;
			c1,c2: char;
			code : Ocodigo;
			Scantidad, SOpos : string;
			err : integer;
			cantidad : word;
			i : integer;
			depo : Tdeposito;
			Dpos, Opos : integer;
			Objeto:Tobjeto;			
		begin
			Opos := 0;
			while not eof(archivo) do begin
				read(archivo,c1);
				inc(Opos);
				str(Opos, SOpos);
				if not eoln(archivo) then begin
					read(archivo,c2);
					if isalpha(c1) and isalpha(c2) then begin
						c1 := toupper(c1);
						c2 := toupper(c2);
						if Otabla[c1, c2].isactive then begin
							if not eoln(archivo) then begin
								read(archivo,c1);
								if c1 = ',' then begin
									if not eoln then begin
{Leo un string, que deberia ser la cantidad, intento pasarlo a integer}
										readln(archivo, Scantidad);
										val(Scantidad, cantidad, err);
{Se accede al condicional si previamente ValidarObjeto:=TRUE, entcones quedan suplidas ambas condiciones y se puede pasar al archivo deposito}
										if (err = 0) and (cantidad in [0..99999])then
										begin
											reset(Dfile);
											found := false;
											seek(Ofile, Otabla[c1,c2].pos);
											read(Ofile, Objeto);
											while not (eof(Dfile) or found) do
											begin
												read(Dfile, depo);
												if depo.CODcolor = Objeto.color then found := true;
											end;
											if not found then
											begin
												depo.CODcolor := Objeto.color;
												depo.CODtam := Objeto.tamano;
												for i := 1 to 30 do
													depo.Objetos[i].cant := 0;
												write(Dfile, depo);
											end;
											Dpos := filepos(Dfile) - 1;
											i := 0;
											found := false;
											while not(found or (i >= 30)) do
											begin
												code :=depo.Objetos[i].codigo;
												inc(i);
												if (code[1] = c1) and (code[2] = c2) then
													found := true;
											end;
											if found then
											begin
												inc(depo.Objetos[i].Cant, cantidad);
												seek(Dfile, Dpos);
												write(Dfile,depo);
											end else writeln(errfile, SOpos + ': Demasiados objetos diferentes en el depósito con esas características');
										end else writeln(errfile, SOpos + ': Cantidad inválida: ' + Scantidad);
									end else writeln(errfile, SOpos + ': Esperaba una cantidad después de' + c1 + c2);
								end else writeln(errfile, SOpos + ': No hay coma después de ' + c1 + c2);
							end else writeln(errfile, SOpos + ': No hay coma después de ' + c1 + c2);
						end else writeln(errfile, SOpos + ': Objeto no existente: ' + c1 + c2);
					end else writeln(errfile, SOpos + ': Código inválido: ' + c1 + c2);
				end else writeln(errfile, SOpos + ': Código inválido: ' + c1);
			end;
		end;end.
