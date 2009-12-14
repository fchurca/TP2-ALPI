unit objeto;

interface
	uses info;

	const
		LETTERS = 26;
		ODESCLEN = 20;

	type
		Ocodigo = array[1,2] of char;
		Tobjeto = record
			codigo : Ocodigo;
			color : byte;
			tamano : char;
			descripcion : string [ODESCLEN];
		end;

		TFobjeto = file of Tobjeto;
		TTobjeto = array ['A'..'Z','A'..'Z'] of record
			isactive : boolean;
			pos:integer;
		end;

// splitOcodigo : separa un string[2] en dos char para recorrer la tabla
	procedure splitOcodigo(str : Ocodigo; var a, b : char)

// validarCcolor: valida si el codigo de color ingresado existe en el arhcivo colores
	function validarCcolor(var archivo : TFcolor; reg.color : byte) : boolean;

// validarCtamano: valida si el codigo de tamano ingresado existe en el archivo tamano
	function validarCtamano (var archivo : TFtamano; tamano : char) : boolean;

// existe: valida si existe el codigo de objeto ingresado
	function existe(var tabla : TTobjeto; reg.codigo : Ocodigo) : boolean;

// addTTobjectentry: agrega un objeto traído de teclado
	procedure addTTobjectentry(var tabla : TTobjeto);

// removeTTobjectentry: marca como inactivo un objeto traido de teclado
	procedure removeTTobjectentry(var tabla : TTobjeto);

// editTTobjectentry : cambian el tamano, color y descripcion de un objeto
	procedure editTTobjectentry(var tabla : TTobjeto);

// informarTTobjeto : vuelca el contenido de la tabla a la pantalla (saltear inactivos)
	procedure informarTTobjeto(var tabla : TTobjeto);

// actualizarObjeto : guarda los cambios realizados en el indice, sobre el archivo
	procedure actualizarObjeto(var tabla : TTobjeto; var archivo : TFobjeto);

implementation

{Validar Codigo del Objeto a tratar}
	function validarCodigo(cod:string):boolean;
		begin
			validarCodigo:=false
			if length(cod) = 2 then
				if isalpha(cod[1]) and isalpha(cod[2]) then
					validarCodigo := true
			end;
		end;

{Cargamos la Tabla tipo TTobjeto donde guardamos: }
	procedure loadFTobjeto (var archivo: TFobjeto; var regT: TTobjeto)
		var
			reg : Tobjeto;
			a, b :char;
			pos : integer;
		begin
			pos := 0;
			reset(archivo);
		{Recorremos el archivo cargando isactive:=TRUE y pos:=posicion del registro en base a los objetos encontrados}
			while not eof(archivo) do
			begin
				read(archivo, reg);
				regT[reg.codigo[1], reg.codigo[2]].isactive := true;
				regT[reg.codigo[1], reg.codigo[2]].pos := pos;
				inc(pos);
			end;
		end;

	procedure initTabla(var tabla: TTobjeto);
		var
			i, j: char;
		begin
			for i:='A' to 'Z'  do for j:='A' to 'Z' do
				tabla[i][j].isactive := false;
		end;

	procedure addTTobjectentry(arhivo:TFobjeto; var tabla : TTobjeto)
		var
			reg: Tobjeto;
			str : string;
		begin
			repeat
				repeat
					writeln('Ingrese Codigo de Objeto:');
					readln(str);
				until validarCodigo(str));
				if tabla[str[1], str[2]].isactive then
					writeln('Ya existe');
			until not tabla[str[1], str[2]].isactive;
			reg.codigo[1] := toupper(str[1]);
			reg.codigo[2] := toupper(str[2]);

			repeat
				writeln('Ingrese Descricion del objeto');
				read(str);
			until (length(str)< ODESCLEN);
			reg.descripcion := str;

//			repeat
				writeln('Ingrese Codigo del color del objeto: ');
				read(reg.color);
//			until validarCColor();
//			repeat
				writeln('Ingrese Codigo del Tamano: ');
				read(reg.tamano);
//			until validarCTamano();

			seek(archivo, filesize(archivo));

			write(archivo,reg);
			tabla[str[1], str[2]].isactive := true;
			tabla[str[1], str[2]].pos := (filesize(archivo - 1));
		end;

	procedure removeTTobjectentry(var archivo:TFobjeto; var tabla : TTobjeto);
		var
			reg : Tobjeto;
			a, b : char;
		begin
			repeat
				writeln('Ingrese Codigo de Objeto:');
				readln(str);
			until validarCodigo(str));
			reg.codigo[1] := toupper(str[1]);
			reg.codigo[2] := toupper(str[2]);

			if tabla[reg.codigo[1],reg.codigo[2]].isactive then
				tabla[reg.codigo[1],reg.codigo[2]].isactive:=FALSE
			else
				writeln('El objeto que intenta borrar no existe!!');
		end;

	procedure editTTobjectentry(var tabla : TTobjeto; archivo: TFobjeto);
		var
			a,b:char;
			prop:integer;
			objeto:Tobjeto;
			codigo:string[2];
			desc:string[20];
			color:byte;
			tamano:char;
		begin
			repeat
			writeln('Ingrese el codigo del objeto a modiciar: (0 para salir)');
			read(codigo);
			until ((validarCodigo(codigo) and existe(TTablaObjeto,codigo)) or codigo='0');       {Hay que definir como GLOBAL la tabla de Objetos}
			if(objeto.codigo<>'0') then
			begin
			writeln('Ingrese la propiedad del objeto que desea modificar: ');
			writeln('1)Descripcion del Objeto');
			writeln('2)Codigo de Color');
			writeln('3)Codigo del Tamano');
			read(prop);
			case prop of
			1: repeat
			writeln('Ingrese Descripicion del objeto');
			read(desc);
			until (lenght(desc)< ODESCLEN);
			splitOcodigo(codigo,a,b);
			seek(archivo,(tabla[a,b].pos-1));
			read(archivo,objeto);
			objeto.descripcion:=desc;
			seek(archivo,(tabla[a,b].pos-1));
			write(archivo,objeto);

			;
			2:
			repeat
			writeln('Ingrese Codigo del color del objeto: ');
			read(color);
			until validarCColor(archivoColor.dat, color);
			splitOcodigo(codigo,a,b);
			seek(archivo,(tabla[a,b].pos-1));
			read(archivo,objeto);
			objeto.color:=color;
			seek(archivo,(tabla[a,b].pos-1));
			write(archivo,objeto);


			;
			3:
			repeat
			writeln('Ingrese Codigo del Tamano: ');
			read(tamano);
			until validarCTamano(archivoTamano.dat, tamano);
			splitOcodigo(codigo,a,b);
			seek(archivo,(tabla[a,b].pos-1));
			read(archivo,objeto);
			objeto.tamano:=tamano;
			seek(archivo,(tabla[a,b].pos-1));
			write(archivo,objeto);
			;
			end;
			else
			begin
			writeln('Saliendo de modificar Objeto...');
			end;
		end;

   procedure informarTTobjeto(var tabla : TTobjeto);

     Begin

      End;
  {Una vez terminado el procedimiento de ABM de objetos, se actualizan los cambios}
  {en un nuevo archivo temporal segun los cambios en la Tabla, se borra el original}
  {y se renombra el temporal}
   procedure actualizarObjeto(var tabla :TTobjeto; var archivo : TFobjeto);
        var
           reg: Tobjeto;
           a,b: char;
           temp: TFobjeto;
        begin

           assign(temp,'temp.dat');
           rewrite(temp);

           while not eof(archivo) do
                 Begin
                      read(archivo,reg);
                      splitOcodigo(reg.codigo,a,b);
                      if tabla[a,b].isactive=TRUE then write(temp,reg);
                 End;

                 close(archivo);
                 erase(archivo);

                 close(temp);
                 rename(temp,'objeto.dat');
                 close(temp);
end.

