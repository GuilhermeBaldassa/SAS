/* ----------------------------------------
Code exported from SAS Enterprise Guide
DATE: sábado, 26 de setembro de 2020     TIME: 13:06:57
PROJECT: Capitulo 02
PROJECT PATH: C:\Users\Aulas\Documents\Curso SAS EG\Aulas\Capitulo 02\Capitulo 02.egp
---------------------------------------- */

/* Library assignment for SASApp.PESSOAL */
Libname PESSOAL V9 '/home/u49566441/sasuser.v94/Arquivos' ;

/* ---------------------------------- */
/* MACRO: enterpriseguide             */
/* PURPOSE: define a macro variable   */
/*   that contains the file system    */
/*   path of the WORK library on the  */
/*   server.  Note that different     */
/*   logic is needed depending on the */
/*   server type.                     */
/* ---------------------------------- */
%macro enterpriseguide;
%global sasworklocation;
%local tempdsn unique_dsn path;

%if &sysscp=OS %then %do; /* MVS Server */
	%if %sysfunc(getoption(filesystem))=MVS %then %do;
        /* By default, physical file name will be considered a classic MVS data set. */
	    /* Construct dsn that will be unique for each concurrent session under a particular account: */
		filename egtemp '&egtemp' disp=(new,delete); /* create a temporary data set */
 		%let tempdsn=%sysfunc(pathname(egtemp)); /* get dsn */
		filename egtemp clear; /* get rid of data set - we only wanted its name */
		%let unique_dsn=".EGTEMP.%substr(&tempdsn, 1, 16).PDSE"; 
		filename egtmpdir &unique_dsn
			disp=(new,delete,delete) space=(cyl,(5,5,50))
			dsorg=po dsntype=library recfm=vb
			lrecl=8000 blksize=8004 ;
		options fileext=ignore ;
	%end; 
 	%else %do; 
        /* 
		By default, physical file name will be considered an HFS 
		(hierarchical file system) file. 
		*/
		%if "%sysfunc(getoption(filetempdir))"="" %then %do;
			filename egtmpdir '/tmp';
		%end;
		%else %do;
			filename egtmpdir "%sysfunc(getoption(filetempdir))";
		%end;
	%end; 
	%let path=%sysfunc(pathname(egtmpdir));
    %let sasworklocation=%sysfunc(quote(&path));  
%end; /* MVS Server */
%else %do;
	%let sasworklocation = "%sysfunc(getoption(work))/";
%end;
%if &sysscp=VMS_AXP %then %do; /* Alpha VMS server */
	%let sasworklocation = "%sysfunc(getoption(work))";                         
%end;
%if &sysscp=CMS %then %do; 
	%let path = %sysfunc(getoption(work));                         
	%let sasworklocation = "%substr(&path, %index(&path,%str( )))";
%end;
%mend enterpriseguide;

%enterpriseguide


/* Conditionally delete set of tables or views, if they exists          */
/* If the member does not exist, then no action is performed   */
%macro _eg_conditional_dropds /parmbuff;
	
   	%local num;
   	%local stepneeded;
   	%local stepstarted;
   	%local dsname;
	%local name;

   	%let num=1;
	/* flags to determine whether a PROC SQL step is needed */
	/* or even started yet                                  */
	%let stepneeded=0;
	%let stepstarted=0;
   	%let dsname= %qscan(&syspbuff,&num,',()');
	%do %while(&dsname ne);	
		%let name = %sysfunc(left(&dsname));
		%if %qsysfunc(exist(&name)) %then %do;
			%let stepneeded=1;
			%if (&stepstarted eq 0) %then %do;
				proc sql;
				%let stepstarted=1;

			%end;
				drop table &name;
		%end;

		%if %sysfunc(exist(&name,view)) %then %do;
			%let stepneeded=1;
			%if (&stepstarted eq 0) %then %do;
				proc sql;
				%let stepstarted=1;
			%end;
				drop view &name;
		%end;
		%let num=%eval(&num+1);
      	%let dsname=%qscan(&syspbuff,&num,',()');
	%end;
	%if &stepstarted %then %do;
		quit;
	%end;
%mend _eg_conditional_dropds;


/* save the current settings of XPIXELS and YPIXELS */
/* so that they can be restored later               */
%macro _sas_pushchartsize(new_xsize, new_ysize);
	%global _savedxpixels _savedypixels;
	options nonotes;
	proc sql noprint;
	select setting into :_savedxpixels
	from sashelp.vgopt
	where optname eq "XPIXELS";
	select setting into :_savedypixels
	from sashelp.vgopt
	where optname eq "YPIXELS";
	quit;
	options notes;
	GOPTIONS XPIXELS=&new_xsize YPIXELS=&new_ysize;
%mend _sas_pushchartsize;

/* restore the previous values for XPIXELS and YPIXELS */
%macro _sas_popchartsize;
	%if %symexist(_savedxpixels) %then %do;
		GOPTIONS XPIXELS=&_savedxpixels YPIXELS=&_savedypixels;
		%symdel _savedxpixels / nowarn;
		%symdel _savedypixels / nowarn;
	%end;
%mend _sas_popchartsize;


ODS PROCTITLE;
OPTIONS DEV=PNG;
GOPTIONS XPIXELS=0 YPIXELS=0;
FILENAME EGSRX TEMP;
ODS tagsets.sasreport13(ID=EGSRX) FILE=EGSRX
    STYLE=HTMLBlue
    STYLESHEET=(URL="file:///C:/Program%20Files/SASHome/SASEnterpriseGuide/7.1/Styles/HTMLBlue.css")
    NOGTITLE
    NOGFOOTNOTE
    GPATH=&sasworklocation
    ENCODING=UTF8
    options(rolap="on")
;

/*   START OF NODE: Mapeamento de Bibliotecas   */
%LET _CLIENTTASKLABEL='Mapeamento de Bibliotecas';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='C:\Users\Aulas\Documents\Curso SAS EG\Aulas\Capitulo 02\Capitulo 02.egp';
%LET _CLIENTPROJECTPATHHOST='AULAS-PC';
%LET _CLIENTPROJECTNAME='Capitulo 02.egp';
%LET _SASPROGRAMFILE='C:\Users\Aulas\Documents\Curso SAS EG\Aulas\Capitulo 02\Mapeamento de Bibliotecas.sas';
%LET _SASPROGRAMFILEHOST='AULAS-PC';

GOPTIONS ACCESSIBLE;

LIBNAME PESSOAL  "/home/u49566441/sasuser.v94/Arquivos" ;
LIBNAME CURSO  "~/my_shared_file_links/u44555663" ;



GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: Import Data (Dados de Clientes.csv)   */
%LET _CLIENTTASKLABEL='Import Data (Dados de Clientes.csv)';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='C:\Users\Aulas\Documents\Curso SAS EG\Aulas\Capitulo 02\Capitulo 02.egp';
%LET _CLIENTPROJECTPATHHOST='AULAS-PC';
%LET _CLIENTPROJECTNAME='Capitulo 02.egp';

GOPTIONS ACCESSIBLE;
/* --------------------------------------------------------------------
   Code generated by a SAS task
   
   Generated on sábado, 26 de setembro de 2020 at 12:48:29
   By task:     Import Data Wizard
   
   Source file: C:\Users\Aulas\Documents\Curso SAS EG\Open Data\Dados
   de Clientes.csv
   Server:      Local File System
   
   Output data: PESSOAL.Dados_de_Clientes
   Server:      SASApp
   
   Note: In preparation for running the following code, the Import
   Data wizard has used internal routines to transfer the source data
   file from the local file system to SASApp. There is no SAS code
   available to represent this action.
   -------------------------------------------------------------------- */

DATA PESSOAL.Dados_de_Clientes;
    LENGTH
        Nome             $ 18
        CPF                8
        Genero           $ 1
        Telefone         $ 14
        Endereco         $ 32
        Cidade           $ 24
        Estado           $ 2
        'Data de Nascimento'n   8
        Email            $ 46
        Renda              8
        Empresa          $ 36
        'Cod do Cliente'n   8
        'Cartões'n         8
        'Vencimento do Cartão'n $ 7 ;
    LABEL
        Nome             = "Nome do Cliente no Cadastro" ;
    FORMAT
        Nome             $CHAR18.
        CPF              BEST11.
        Genero           $CHAR1.
        Telefone         $CHAR14.
        Endereco         $CHAR32.
        Cidade           $CHAR24.
        Estado           $CHAR2.
        'Data de Nascimento'n DDMMYY10.
        Email            $CHAR46.
        Renda            NLMNLBRL16.2
        Empresa          $CHAR36.
        'Cod do Cliente'n BEST3.
        'Cartões'n       BEST19.
        'Vencimento do Cartão'n $CHAR7. ;
    INFORMAT
        Nome             $CHAR18.
        CPF              BEST11.
        Genero           $CHAR1.
        Telefone         $CHAR14.
        Endereco         $CHAR32.
        Cidade           $CHAR24.
        Estado           $CHAR2.
        'Data de Nascimento'n DDMMYY10.
        Email            $CHAR46.
        Renda            DOLLAR16.
        Empresa          $CHAR36.
        'Cod do Cliente'n BEST3.
        'Cartões'n       BEST19.
        'Vencimento do Cartão'n $CHAR7. ;
    INFILE '/saswork/SAS_work37AC000052E1_odaws01-usw2.oda.sas.com/#LN00012'
        LRECL=211
        ENCODING="UTF-8"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        Nome             : $CHAR18.
        CPF              : ?? BEST11.
        Genero           : $CHAR1.
        Telefone         : $CHAR14.
        Endereco         : $CHAR32.
        Cidade           : $CHAR24.
        Estado           : $CHAR2.
        'Data de Nascimento'n : ?? DDMMYY10.
        Email            : $CHAR46.
        Renda            : ?? NLMNLBRL8.2
        Empresa          : $CHAR36.
        'Cod do Cliente'n : ?? BEST3.
        'Cartões'n       : ?? COMMA19.
        'Vencimento do Cartão'n : $CHAR7. ;
RUN;


GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;

;*';*";*/;quit;run;
ODS _ALL_ CLOSE;
