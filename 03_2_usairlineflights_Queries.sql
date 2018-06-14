/*
   Data:	13/06/2018
   Autor:	JRVG

Dels 2000 registres de l'arxiu 2000X2000.csv n'accepta 1777 en 348 segons fent l'import des de Workbench. 
És un procés lent.
Per importar els 5683049 de l'arxiu 2000.csv necessitaria de l'ordre de: 11,44 dies.
5683049 * (348 / 2000) = 988850 segons. 274,68 Hores.

CANVIS EN EL MODEL DE DADES
He revisat el model de dades per aconseguir que la importació de "carriers" i "usairports" no descarti cap registre.
He fet tres canvis.

Taula: carriers
Camp: Description
Changed VARCHAR(32) --> 83\ncarriers.csv_Description has 26 registers with more than 32 char. Max length 83

Taula: usairports
Camp: Airport
Changed VARCHAR(32) --> 41\nVARCHAR(32) | airports.csv_airport has 52 registers with more than 32 char. Max length 41\n	

Camp: City
Changed VARCHAR(32) -->33\nVARCHAR(32) | airports.csv_city has  1 registers with more than 32 char. Max length 33

Els arxius CSV tenen camps ,NA, per indicar "Not Available".
En el camp d'un integer no pot rebre aquest valor. Hauria de ser NULL.
Durant la importació de l'arxiu CSV, aquests registres es descarten i no s'insereixen a la taula.
He intentat transformar el CSV canviant ,NA, per ,NULL, o per ,\N, i la importació de dades mitjançant
el procés "Table Data Import Wizard" des del fitxer CSV no els traga.

Per poder fer la transformació del CSV en el moment de fer la inserció cal que es pugui executar un script
amb la comanda "LOAD DATA infile". Però la configuració de MySQL del meu equip impedeix l'execució d'aquests
scripts.
He fet les proves assegurant-me que l'arxiu CSV a importar fos a la carpeta de la variable 
SHOW VARIABLES LIKE 'secure_file_priv'.
Però, sospito que les variables d'entorn que s'haurien d'haver fixat durant la instal·lació, no estan bé.
Per tant, es tracta d'un problema de configuració de MySQL Workbench del meu equip.

Si pugués executar aquests scripts podria fer la inserció del NULL amb un codi semblant al de sota:

LOAD DATA infile '/tmp/testdata.txt'
INTO TABLE moo
fields terminated BY ","
lines terminated BY "\n"
(one, two, three, @vfour, five)
SET four = nullif(@vfour,'')
;

*/

SHOW VARIABLES LIKE "secure_file_priv"; # 'secure_file_priv', 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\'
show variables like 'sql_mode';         # 'sql_mode', 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION'

USE `usairlineflights`;

/* Consulta 1 ● Quantitat de registres de la taula de vols: 
=======================================================================================*/
SELECT COUNT(*) FROM usairlineflights.flights; # 1777


/* Consulta 2 ● Retard promig (Mitjana del retard) de sortida i arribada segons l’aeroport origen.
 =======================================================================================
 Table: flights
 Fields:
 15 	ArrDelay 	arrival delay, in minutes
 16 	DepDelay 	departure delay, in minutes
 17 	Origin 		origin IATA airport code
#SELECT  ArrDelay, DepDelay, Origin FROM usairlineflights.flights; # 3376
#SELECT  COUNT(*) FROM usairlineflights.flights; # 3376
#SELECT  COUNT(ArrDelay), COUNT(DepDelay), COUNT(Origin) FROM usairlineflights.flights; # 3376
#SELECT  ArrDelay, DepDelay, Origin FROM usairlineflights.flights GROUP BY Origin; # 3376

RESULT
Export: Query02_MitjanaDeRetards_Arr_Dep_By_Origin.csv
AVG(ArrDelay),AVG(DepDelay),Origin
7.8800,9.6800,AMA
19.5778,18.2378,ATL
7.7542,7.8292,AUS
6.9450,9.4954,BDL
14.7317,12.7317,BHM
11.4595,8.6343,BNA
12.7692,15.5128,BOS
=======================================================================================*/
# Interpretació 1: L'aeroport d'origen queda qualificat pel seu codi IATA.
USE `usairlineflights`;
SELECT 
    f.Origin,
    AVG(f.DepDelay) AS 'Departure average delay',
    AVG(f.ArrDelay) AS 'Arrival average delay'
FROM
    flights As f
GROUP BY f.Origin;


# Interpretació 2: L'aeroport d'origen s'explicita amb el seu nom, no amb el seu codi IATA.
SELECT 
    ua.Airport AS 'Airport',
    AVG(f.DepDelay) AS 'Departure average delay',
    AVG(f.ArrDelay) AS 'Arrival average delay'
FROM
    flights As f
		INNER JOIN  
    usairports AS ua ON f.Origin = ua.IATA
GROUP BY f.Origin
ORDER BY ua.Airport ASC;


/* Consulta  3 ● Mitjana del retard d’arribada dels vols, per mesos i segons l’aeroport origen.
=======================================================================================
A més, volen que els resultat es mostrin de la següent forma:
LAX, 2000, 01, retard
LAX, 2000, 02, retard
…
LAX, 2000, 12, retard
LAX, 2001, 01, retard
…
ONT, 2000, 01, retard
ONT, 2000, 02, retard
etc.

 Table: flights
 Fields:
 1 		colYear 	1987-2008
 2 		colMonth 	1-12
 15 	ArrDelay 	arrival delay, in minutes
 17 	Origin 		origin IATA airport code
======================================================================================= */
SELECT 
    Origin,
    colYear AS 'Year',
    colMonth AS 'Month',
    AVG(ArrDelay) AS 'Average delay'
FROM
    flights
GROUP BY Origin, colYear , colMonth 
ORDER BY colYear ASC, colMonth DESC;


/* Consulta 4 ● Mitjana del retard d’arribada dels vols, per mesos i segons l’aeroport origen. 
========================================================================================
(mateixa consulta que abans i amb el mateix ordre). Però a més, ara volen que en comptes del codi de l’aeroport es mostri el nom de la ciutat.
		Los Angeles, 2000, 01, retard
Los Angeles, 2000, 02, retard

 Table: flights
 Fields:
 1 		colYear 	1987-2008
 2 		colMonth 	1-12
 15 	ArrDelay 	arrival delay, in minutes
 17 	Origin 	origin IATA airport code
 
 Table: usairports
 Fields:
  1 	Origin 	origin IATA airport code
  2		Airport
  3 	City
======================================================================================== */
USE `usairlineflights`;
SELECT 
    ua.City AS 'City',
    f.colYear AS 'Year',
    f.colMonth AS 'Month',
    AVG(f.ArrDelay) AS 'Arrival delay'
FROM
    usairports AS ua
        INNER JOIN
    flights AS f ON ua.IATA = f.Origin
GROUP BY ua.City
ORDER BY ua.City;


#La consulta feta a la inversa
SELECT 
    ua.City AS 'City',
    f.colYear AS 'Year',
    f.colMonth AS 'Month',
    AVG(f.ArrDelay) AS 'Arrival delay'
FROM
    flights AS f
        INNER JOIN
    usairports AS ua ON f.Origin = ua.IATA
GROUP BY ua.City
ORDER BY ua.City;


/* Consulta 5 ● Les companyies amb més vols cancel·lats. 
   A més, han d’estar ordenades de forma que les companyies amb més cancel·lacions apareguin les primeres.
========================================================================================
 Table: flights
 Fields:
  9 	UniqueCarrier unique carrier code
 22 	Cancelled 	was the flight cancelled?
 23 	CancellationCode 	reason for cancellation (A = carrier, B = weather, C = NAS, D = security)

 Table: carriers
  1: CarrierCode
  2: Description

SELECT UniqueCarrier, Cancelled FROM usairlineflights.flights WHERE Cancelled='1';
======================================================================================== */
USE `usairlineflights`;
SELECT 
    c.CarrierCode AS 'Carrier code',
    c.Description AS 'Carrier description',
    COUNT(f.Cancelled) AS 'Cancellations' # Correcció Usar COUNT(camp) en lloc de SUM(camp).
FROM
    carriers AS c
        INNER JOIN
    flights AS f ON c.CarrierCode = f.UniqueCarrier
WHERE
    f.Cancelled = '1'
GROUP BY f.UniqueCarrier
ORDER BY SUM(f.Cancelled) DESC; 


/* Consulta 6 ●	Companyies amb la seva mitjana només d’aquelles les quals els seus vols arriben al seu destí amb un retràs major de 10 minuts.
========================================================================================
 Table: flights
 Fields:
 9 		UniqueCarrier 	unique carrier code
 15 	ArrDelay 		arrival delay, in minutes

CAS DEMANAT:
1) Vols amb retard superior a 10'
2) Extreure la mitjana de retard de cada companyia i mostrar-lo amb un Group By

SELECT AVG(f.ArrDelay) AS 'Arrival delay', f.UniqueCarrier As 'Carrier' FROM flights AS f WHERE f.ArrDelay > 10 GROUP BY f.UniqueCarrier;

Incloc una consulta addicional que no es demana en què es té en compte només una part de l'espai mostral.
====================================================== */
USE `usairlineflights`;
# Considerar tots els retards i mostrar només les companyies amb una mitjana de retard que superi els 10 minuts.
USE `usairlineflights`;
SELECT 
	c.Description AS 'Carrier description', 
	AVG(f.ArrDelay) AS 'Arrival delay'
FROM flights AS f INNER JOIN carriers as c ON f.UniqueCarrier = c.CarrierCode
GROUP BY f.UniqueCarrier HAVING AVG(f.ArrDelay) > 10
ORDER BY c.Description ASC;

# Interpretació diferent. Només la incloc com a ampliació de l'exercici.
# Interpreto que només cal considerar els retards que superen els 10 minuts i mostrar la mitjana per cada companyia.
SELECT 
	c.Description AS 'Carrier description', 
	AVG(f.ArrDelay) AS 'Arrival delay'
FROM flights AS f INNER JOIN carriers as c ON f.UniqueCarrier = c.CarrierCode
WHERE f.ArrDelay > 10 
GROUP BY f.UniqueCarrier
ORDER BY c.Description ASC;


/* Consulta 7 ● L’identificador dels 10 avions que més kilòmetres han recorregut fent vols comercials:
 ========================================================================================
 Table: flights
 Fields:
 10 	FlightNum 	flight number
 11 	TailNum 	plane tail number
 
 Source: https://dev.mysql.com/doc/refman/8.0/en/problems-with-alias.html

B.5.4.4 Problems with Column Aliases
An alias can be used in a query select list to give a column a different name.
You can use the alias in GROUP BY, ORDER BY, or HAVING clauses to refer to the column: 

Standard SQL disallows references to column aliases in a WHERE clause.
This restriction is imposed because when the WHERE clause is evaluated, the column value may not yet have been determined.
For example, the following query is illegal: 
	SELECT id, COUNT(*) AS cnt FROM tbl_name WHERE cnt > 0 GROUP BY id;

The WHERE clause determines which rows should be included in the GROUP BY clause, 
but it refers to the alias of a column value that is not known until after the rows have been selected, and grouped by the GROUP BY.

In the select list of a query, a quoted column alias can be specified using identifier or string quoting characters:
	identifier quoting:			`one`
	string quoting characters:	'two'

	SELECT 1 AS `one`, 2 AS 'two';
    
Elsewhere in the statement, quoted references to the alias must use identifier quoting 
or the reference is treated as a string literal. 
For example, this statement groups by the values in column id, referenced using the alias `a`:

	SELECT id AS 'a', COUNT(*) AS cnt FROM tbl_name GROUP BY `a`;

 But this statement groups by the literal string 'a' and will not work as expected:

	SELECT id AS 'a', COUNT(*) AS cnt FROM tbl_name   GROUP BY 'a';
 ======================================================================================== */
USE `usairlineflights`;
SELECT 
	TailNum AS `Tail identifier`, 
	SUM(Distance) AS `Total Distance [Miles]` 
FROM usairlineflights.flights 
GROUP BY TailNum 
ORDER BY `Total Distance [Miles]` DESC # Es pot usar l'àlias 
LIMIT 10;
