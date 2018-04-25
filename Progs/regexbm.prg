
*:****************************************************************************************************************
*:  	EVALUACION DE EXPRESIONES REGEX EN STRING
*:****************************************************************************************************************
*: (C) Baldo Martorell Pérez -> b.martorell@gmail.com
*:****************************************************************************************************************
*:
*:    USO: REGEXBM(Propiedades , Literal, Patron 	[,Salida] [,regex_matrix])
*:      	           (1)             (2)     (3)     (4)			(5)
*:	       	    		|			 	|		|		|
*:			busqueda global:   "G"		|		|		|
*:			ignorar mays/mins: "I"   	|		|		|
*:			multilinea:        "M"		|		|		|
*:										|		|		|
*:										|		|		|
*:			 	string a comprobar -----+		|		|
*:												|		|
*:				  	(patrón) expresion Regex ---+		|
*:														|
*:										0 = comprueba si hay éxito en la comprobacion (retorna .T. o .F.)
*:										1 = retorna número de coincidencias y array de resultados(5)
*:                                      
*:									    (5) Si salida=1 debe EXISTIR PREVIAMENTE el array 'regex_matrix' 
*:											con este nombre y dos columnas -> DIMENSION regex_matrix(1,2)
*:                                          El proceso (si Salida=1):
*:													1) devuelve el NUMERO de coincidencias (-1 si error en patrón)
*:                                                  2) rellena regex_matrix con una fila por coincidencia y..
*:														-columna 1: posicion de inicio de coincidencia			
*:														-columna 2: caracteres coincidentes
*:													3) retorna -1 en caso de ERROR
*:
*:		-------------------------------------------------------------------------------------------------------
*:		Expresiones Regex (patrones) predefinidos
*:		-------------------------------------------------------------------------------------------------------
*:		  "es_url"			-> Comprobar si URL
*:		  "es_ip"			-> Comprobar si posible IP (xxx.yyy.zzz.kkk con valores entre 0 y 255)
*:		  "es_mail"			-> direccion de correo (RFC 5322 Official Standard)
*:
*:****************************************************************************************************************

function REGEXBM(xpropie,xlite,xpatron,xaccion,regex_matrix)


set exclusive	off
set talk 		off
set echo 		off
set status 		off
set century 	on
set deleted 	on
set safety 		off
set status 		off
set status bar 	off
set help 		off
set escape 		off
set date BRITI

if parameters()<3
	=messagebox("    Faltan parámetros. ")
	return .f.
endif	

if parameters()=3
	xaccion=0
endif

xglobal	= iif("g"$lower(xpropie),.t.,.f.)
xignore = iif("i"$lower(xpropie),.t.,.f.)
xmlin   = iif("m"$lower(xpropie),.t.,.f.)
xlite	= xlite
xpatron = alltrim(xpatron)

*: Evitando errores basicos de construccion de patrón (devuelve -1 o .f. segun modo)
local xfallo
xfallo=.f.

if right(xpatron,1)=="\" or len(xpatron)=0
	xfallo=.t.
endif	 

if occurs("(",xpatron)<>occurs(")",xpatron)
	xfallo=.t.
endif

if occurs("[",xpatron)<>occurs("]",xpatron)
	xfallo=.t.
endif

*if occurs("\]",xpatron)>0
*	xfallo=.t.
*endif	

if (xfallo)
	return iif(xaccion=1,-1,.f.)
endif	

*:************************************************************************************************************
*:	BREVE ESQUEMA
*:  Lectura recomendada: MSDN Microsoft, https://msdn.microsoft.com/es-es/library/az24scfc(v=vs.110).aspx
*:************************************************************************************************************
*:	Expresion	Descripcion					Meta	Ejemplo
*:	---------	----------------------		----	------------------------------------------
*:	^			al principio de string				^\d{3} 			-> comienza 3 dígitos
*:	[^nmp..]	niega n,m,p...						[^abc]			-> cualquiera menos a,b y c
*:	$			al final de string					\d$				-> tres digitos al final
*:	.           cualquier caracter					ma.a			-> .T. para "mala" y "mapa"
*:	|			"o" (entre items)					element(o|a)
*:	[mnp]		incluye m, n ó p
*:	[a-z]		rango de caracteres a-z
*:	[^a-z]		exclusion del rango a-z
*:	(pattern)	coincidencia plena					industr(i|ial)	-> .T. para industria/industrial
*:				caracter ascii hex.'H'		\xH		\x2D			-> '-'
*:				caracter nueva linea		\n
*:				caracter retorno de carro	\r
*:				caracter tabulador			\t
*:				caracter 'null'				\0
*:				cualquier dígito			\d
*:				cualquier no dígito			\D
*:				letras y numeros (y '_')	\w
*: -----------------------------------------------------------------------------------------------------
*: Cuantificadores
*: -----------------------------------------------------------------------------------------------------
*:	{0,}		cero o más hallazgos		*
*:	{1,}		una o más veces				+		\d+				-> .T. para '1234'
*:	{n}			encontrado "n" veces
*:	{0,1}		una como mucho				?
*:	{n,m}		de n a m veces						[0-9]{2,5}		-> de 2 a 5 dígitos
*: -----------------------------------------------------------------------------------------------------
*: Delimitadores
*: -----------------------------------------------------------------------------------------------------
*:	^			debe coincidir al principio			^\d{3}			-> "901"  en "901-333"
*:	$			debe coincidir al final				-\d{3}$			-> "-333" en "901-333"
*:	----------------------------------------------------------------------------------------------------
*: Ej: Palabras de 4 letras: \b\w{4}\b


*: Predefinidas (puedes redefinir mas valores aumentando sentencias "case")

do case
case lower(xpatron) = "es_mail"

	*:*****************************************************************************************************************************
	*:Email Regex (RFC 5322 Official Standard)
	*:*****************************************************************************************************************************
	xpatron =            "^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"+chr(34)
	xpatron = xpatron +"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*"+chr(34)
	xpatron = xpatron +")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\"
	xpatron = xpatron +"[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:"
	xpatron = xpatron +"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])$"

case lower(xpatron) = "es_ip"

	*:*****************************************************************************************************************************
	*:   Ip. Comprobación básica de aspecto: Cuatro grupos de números (0 a 255) separados por puntos...
	*:*****************************************************************************************************************************
	xpatron = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"

other
endcase

local oRGX
oRGX = createobject("VBScript.RegExp")
oRGX.pattern 	= xpatron
oRGX.global  	= xglobal
oRGX.ignorecase = xignore
oRGX.multiline  = xmlin
if xaccion==0
	try
		llresult = oRGX.test(xlite)
	catch
		llresult=.f.
	endtry
	return llresult
else
	try
		*:Limpiamos posible 'basura' (de anteriores llamadas)
		external array regex_matrix		&& Viene del programa llamador
		for f=1 to alen(regex_matrix,1)	&& Tenga la dimensión que tenga...
			regex_matrix(f,1)=0			&& Columna1: posición de coincidencia
			regex_matrix(f,2)=""		&& Columna2: texto coincidente
		next
		
		oCoin  = oRGX.Execute(xlite)				&& -> Objeto 'coincidencias'
		lncoin = oCoin.Count
	catch
		lncoin = -1									&& -> Algún error ...
	endtry
	if lnCoin>0
		dimension regex_matrix(lncoin,2)		&& -> La dejamos en su tamaño necesario
		for f=1 to lnCoin
			regex_matrix(f,1)=(oCoin.item(f-1).firstindex)+1
			regex_matrix(f,2)=oCoin.item(f-1).value	
		next f
	else

	endif
	return lnCoin
endif

*:(eof)
