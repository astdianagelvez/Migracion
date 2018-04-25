
USE "F:/ORBIS/INMO/DATA/INM_DESC.DBF" IN 0 SHARED 

CREATE CURSOR ESTADO_INMUEBLE(;
COD_ESTADO C(3),;
NOM_ESTADO C(60);
)

INSERT INTO ESTADO_INMUEBLE VALUES("1","CONSIGNADO")
INSERT INTO ESTADO_INMUEBLE VALUES("2","OCUPADO")
INSERT INTO ESTADO_INMUEBLE VALUES("3","DESOCUPADO")
INSERT INTO ESTADO_INMUEBLE VALUES("4","PENDIENTE")
INSERT INTO ESTADO_INMUEBLE VALUES("5","RETIRADO")
INSERT INTO ESTADO_INMUEBLE VALUES("6","INMUEBLE EN CONTRATO - ARRENDATARIO")

CREATE CURSOR TIPO_COCINA(;
COD_TIPO_COCINA C(3),;
NOM_TIPO_COCINA C(60);
)

INSERT INTO TIPO_COCINA VALUES("1","COCINA TRADICIONAL")
INSERT INTO TIPO_COCINA VALUES("2","COCINA SEMI-INTEGRAL")
INSERT INTO TIPO_COCINA VALUES("3","COCINA INTEGRAL")

CREATE CURSOR TIPO_PISO(;
COD_TIPO_COCINA C(3),;
NOM_TIPO_COCINA C(60);
)

INSERT INTO TIPO_PISO VALUES("1","PISO EN CERAMICA")
INSERT INTO TIPO_PISO VALUES("2","PISO EN MARMOL")
INSERT INTO TIPO_PISO VALUES("3","PISO EN GRANITO")
INSERT INTO TIPO_PISO VALUES("4","PISO ENTAPETADO")
INSERT INTO TIPO_PISO VALUES("5","PISO EN CEMENTO")
INSERT INTO TIPO_PISO VALUES("6","PISO EN PLASTICO")
INSERT INTO TIPO_PISO VALUES("7","PISO EN PORCELANATO")
INSERT INTO TIPO_PISO VALUES("8","PISO EN TABLETA")
INSERT INTO TIPO_PISO VALUES("9","PISO EN MADERA")
INSERT INTO TIPO_PISO VALUES("10","PISO EN BALDOSIN")

SELECT INMUEBLES 
GO TOP 
SCAN 
	lcCodInmueble = ALLTRIM(STR(INMUEBLES.IDINMUEBLE))
	lcTel_inmueble = thisform.telefonos(ALLTRIM(INMUEBLES.TELEFONO), "")
	lccod_inmobiliaria = ""
	lctipo_cod_consig = ALLTRIM(STR(INMUEBLES.TCONSIGNACION))
	lccod_sucursal = ALLTRIM(STR(INMUEBLES.IDCIUDAD_CONT))
	lcod_barrio =  ALLTRIM(STR(INMUEBLES.IDBARRIO))
	lccod_tipo_inmueble = ALLTRIM(STR(INMUEBLES.idtinmueble))
	lccod_sub_tipo_inm = ""
	lccod_pot = "" &&HAY TABLA PARAMETRICA DE POT??
	lcCod_destino = ALLTRIM(STR(INMUEBLES.DESTINO))
	lcCod_estrato = ALLTRIM(STR(INMUEBLES.ESTRATO))
	lccod_estado = ALLTRIM(STR(INMUEBLES.ESTADO))
	lccod_estado_fis = ""
	lcinm_nuevo = ""
	ldFecha_cons = INMUEBLES.FCONSIGNACION
	*lnValor_avaluo = INMUEBLES.VAVALUO
	lnvalor_canon = INMUEBLES.CANON_NEG
	lnprecio_venta = 0
	lnPorc_comision = INMUEBLES.PORC_COMISION
	lnPorc_comision_ant = IIF(INMUEBLES.COM_ANTICIPADA,2,0)
	lnVlr_fianza = 0 &&??
	lnCant_cuota_fianza = 0 &&??
	*lcNro_matricula = INMUEBLES.NMATRICULA
	lnVlr_admon = INMUEBLES.VADMON
	lnVlr_publicidad = 0 &&??
	lnVlr_hipoteca = 0&&??
	*lcNro_escritura = INMUEBLES.NESCRITURA 
	ldFecha_escritura = {} &&??
	lcNotaria_Escritura = "" 
	lcCod_ubicacion = "" &&??
	lcLiquida_comision_g = "" &&??
	lcLiquida_comision_e = "" &&??
	lnVlr_com_esp = 0
	lnEdad_inm = 0
	lcDestacado_web = "" &&??
	lcMuestrafoto_web = "" &&??
	lcCod_tipo_coc = ""
	lcCod_tipo_parq = ""
	lcCod_tipo_piso = ""
	lcObs_inm = ALLTRIM(INMUEBLES.OBSERVACIONES)
	lcDir_inmueble = ""
	lnSec_unidad = 0 &&??esto es la administracion 
	lcCot_tipo_cman = ""
	lcPub1 = ""
	lcPub2 = ""
	ldfecha_recons = INMUEBLES.FRECONSIGNACION
	lcPub3 = ""
	lcObs_dist = "" &&??
	lcObs_servp = "" &&??
	lcObs_servcom = "" &&?? 
	ldFecha_retiro = INMUEBLES.FRETIRO
	lcCod_cliente_prom = "" &&-->>
	lnArea_lote = INMUEBLES.AREA_TOTAL 
	lnArea_const = INMUEBLES.AREA_CONST 
	lcNro_parqueadero = ""
	lcCod_cliente_pad = ""
	lcDir_video = ""
	lnVlr_cuota_Aseo = 0
	lcAdmon_por_def = "" &&??
	lcCod_seg = "" &&??
	lcNo_cob_int = "" &&??
	lcCod_arch = "" &&??
	lcCod_fr = "" &&??
	lcCod_mc = ""&&??
	lcBloq_pag = "" &&??
	lnPorc_comad = INMUEBLES.COMADMON
	lnPorc_seg_adm = INMUEBLES.SEG_ADMON 
	lnLatitud = 0 &&-->>
	lnLongitud = 0 &&-->>
	lcCod_ruta_pago = ""
	
	SET EXACT ON 
	 IF  SEEK(INMUEBLES.IDINMUEBLE, "INM_DESC", "IDINMUEBLE")
	 	lnValor_avaluo = INMUEBLES.VAVALUO	
	 	lcNro_matricula = INMUEBLES.NMATRICULA
	 	lcNro_escritura = INMUEBLES.NESCRITURA 
	 ENDIF 
	SET EXACT OFF 
ENDSCAN 