unit processing;

interface
	function actualizar : boolean;

implementation
	uses menu, objeto, deposito, info, dos;

	function actualizar : boolean;
		var
			archivo, errfile : text;
			archname, errname : string;
			Dfile : FTdeposito;
			Ofile : FTobjeto;
			Otabla : TTobjeto;
			found : boolean;
			c1, c2, c3: char;
			code : Ocodigo;
			auxstr, s, SOpos : string;
			err : integer;
			cantidad : longint;
			i : integer;
			depo : Tdeposito;
			Dpos, Opos : integer;
			Objeto:Tobjeto;
			y,m,d,w:word;
		begin
			actualizar := false;
			assign(Dfile, DEPOTFILE);
			assign(Ofile, OBJECTFILE);
			writeln('Archivo CSV a usar?');
			write(PROMPT);
			readln(archname);
			assign(archivo, archname);
			if goodtext(archivo) then begin
			 getdate(y,m,d,w);
			 str(y,s);
			 errname := 'ER' + s;
			 str(m,s);
			 errname := errname + s;
			 str(d,s);
			 errname := errname + s + '.txt';
			 assign(errfile, errname);
			 {$I-}
			 rewrite(errfile);
			 {$I+}
			 if ioresult = 0 then begin
			  if goodFTdeposito(Dfile) then begin
			   emptyFTdepositoresults(Dfile);
			   if goodFTobjeto(Ofile) then begin
			    loadFTobjeto(Ofile, Otabla);
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
			         read(archivo,c3);
			         if c3 = ',' then begin
			          if not eoln(archivo) then begin
			           readln(archivo, auxstr);
			           val(auxstr, cantidad, err);
			           if (err = 0) and (cantidad >= 0) and (cantidad <= 99999)then
			           begin
			            reset(Dfile);
			            found := false;
			            seek(Ofile, Otabla[c1,c2].pos);
			            read(Ofile, Objeto);
			            while not (eof(Dfile) or found) do
			            begin
			             read(Dfile, depo);
			             if depo.color = Objeto.color then found := true;
			            end;
			            if found then
			            begin
			             Dpos := filepos(Dfile) - 1;
			             i := 0;
			             found := false;
			             while not(found or (i >= DEPOTSIZE)) do
			             begin
			              inc(i);
			              code := depo.Objetos[i].codigo;
			              if (code[1] = c1) and (code[2] = c2) then
			               found := true
			              else if (code[1] = '?') and (code[2] = '?') then
			              begin
			                depo.Objetos[i].codigo[1] := c1;
			                depo.Objetos[i].codigo[2] := c2;
			                found := true;
			              end;
			             end;
			             if found then
			             begin
			              inc(depo.Objetos[i].cantidad, cantidad);
writeln(depo.Objetos[i].codigo[1],depo.Objetos[i].codigo[2],',',depo.Objetos[i].cantidad);
			              seek(Dfile, Dpos);
			              write(Dfile,depo);
			             end else writeln(errfile, SOpos + ': Demasiados objetos diferentes en el depósito con esas características');
			            end else writeln(errfile, SOpos + ': No hay depósito con esas características');
			           end else writeln(errfile, SOpos + ': Cantidad inválida: ' + auxstr);
			          end else begin writeln(errfile, SOpos + ': Esperaba una cantidad después de' + c1 + c2);
			           readln(archivo);
			          end;
			         end else begin writeln(errfile, SOpos + ': No hay coma después de ' + c1 + c2);
			          readln(archivo);
			         end;
			        end else begin writeln(errfile, SOpos + ': No hay coma después de ' + c1 + c2);
			         readln(archivo);
			        end;
			       end else begin writeln(errfile, SOpos + ': Objeto no existente: ' + c1 + c2);
			        readln(archivo);
			       end;
			      end else begin writeln(errfile, SOpos + ': Código inválido: ' + c1 + c2);
			       readln(archivo);
			      end;
			     end else begin
			      writeln(errfile, SOpos + ': Código inválido: ' + c1);
			      readln(archivo);
			     end;
			    end;
			    actualizar := true;
			    close(Ofile);
			   end else writeln(NO_FILE, PROMPT, OBJECTFILE);
			   close(Dfile);
			  end else writeln(NO_FILE, PROMPT, DEPOTFILE);
			  close(errfile);
			 end else writeln(NO_FILE, PROMPT, errname);
			 close(archivo);
			end else writeln(NO_FILE, PROMPT, archname);
			pause;
		end;end.
