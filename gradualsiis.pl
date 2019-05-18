#!/usr/bin/perl
use DBI; # Bookmarks: 49,278 49,278 49,240 0,0 0,0 49,233 49,46 49,2199 49,2308 49,278 # Bookmarks: 75,284 75,284 75,246 0,0 0,0 75,236 75,46 75,2231 75,2340 75,284 # Bookmarks: 48,1380 48,77 0,0 0,0 0,0 0,0 0,0 0,0 0,0 48,1468
use Cwd;

#------------------------------------------------------
#1 * * * * /home/falvarez/Perl/gradualsiis.pl >> /home/falvarez/Perl/gradualsiis.log

#Programa de asignacion del gradual para cada sismo
#esto depende de un conjunto de condiciones
#1,11,21,31,41,51 * * * * /home/falvarez/Perl/gradualsiis.pl >> /home/falvarez/Perl/gradualsiis.log

#Fecha: 20/02/2008
#Modificaciones:
#Fecha: 
#Desarrollado por: faove@hotmail.com
#------------------------------------------------------

#-------------------------------------
#Inicialización de todas las variables
#-------------------------------------


#Declaración de las variables que nos permiten
#el acceso con la base de datos sismologica
$db="siiss";
$host="localhost";
$port="3306";
$userid="root";
$passwd="";
$ie=0;
$arch=0;
$ceros ="";


#CONEXION SIN ODBC:
$connectionInfo="DBI:mysql:database=$db;$host:$port";

# Realizamos la conexión a la base de datos
$dbh = DBI->connect($connectionInfo,$userid,$passwd);

#SELECT locations.depth, magnitudes.magnivalue, magnitudes.gradual
#FROM magnitudes INNER JOIN locations ON magnitudes.idevent = locations.idevent;

$query = "SELECT locations.idevent,depth,magnivalue,gradual FROM magnitudes INNER JOIN locations ON magnitudes.idevent = locations.idevent  where gradual=0";

print "$query\n";

my $out = $dbh->prepare($query) || die "Fallo al preparar la consulta: $DBI::errstr\n";

$out->execute() or print "No puedo ejecutar la consulta";

#$filas=$dbh->do($query);


# assign fields to variables
$out->bind_columns(\$idevent,\$depth, \$magnivalue,\$gradual);

# output name list to the browser
#print "Names in the people database:<p>\n";
#print "<table>\n";

while($out->fetch()) {
#-------------------------------------------------------------------------------
	if  (($depth>=0 && $depth <=32.99) && ($magnivalue>=0 && $magnivalue<=0.9)){
	   	#print "Prof:\n";
		#print "$idevent\n";
		#print "$depth\n";
		#print "$magnivalue\n";
	   	print "UPDATE magnitudes SET gradual=1 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=1 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

		#print "\n";
	}
	if  (($depth>=0 && $depth <=32.99) && ($magnivalue>=1 && $magnivalue<=1.9)){
	  
	   	print "UPDATE magnitudes SET gradual=2 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=2 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

	}
	if  (($depth>=0 && $depth <=32.99) && ($magnivalue>=2 && $magnivalue<=2.9)){
	   #print "3\n";
	   #print "\n";

	   	print "UPDATE magnitudes SET gradual=3 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=3 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

	}	
	if  (($depth>=0 && $depth <=32.99) && ($magnivalue>=3 && $magnivalue<=3.9)){
	   #print "4\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=4 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=4 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

	}
	if  (($depth>=0 && $depth <=32.99) && ($magnivalue>=4 && $magnivalue<=4.9)){
	   #print "5\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=5  WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=5 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}	
	if  (($depth>=0 && $depth <=32.99) && ($magnivalue>=5 && $magnivalue<=5.9)){
	   #print "6\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=6 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=6 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}	
	if  (($depth>=0 && $depth <=32.99) && ($magnivalue>=6 && $magnivalue<=8.0)){
	   #print "7\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=7 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=7 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}	
#-------------------------------------------------------------------------------
	if  (($depth>=33 && $depth <=69.99) && ($magnivalue>=0 && $magnivalue<=0.9)){
	   #print "8\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=8 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=8 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}
	if  (($depth>=33 && $depth <=69.99) && ($magnivalue>=1 && $magnivalue<=1.9)){
	   #print "9\n";
	   #print "$magnivalue\n";
	   	print "UPDATE magnitudes SET gradual=9 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=9 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}
	if  (($depth>=33 && $depth <=69.99) && ($magnivalue>=2 && $magnivalue<=2.9)){
	   #print "10\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=10 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=10 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}	
	if  (($depth>=33 && $depth <=69.99) && ($magnivalue>=3 && $magnivalue<=3.9)){
	   #print "11\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=11 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=11 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}
	if  (($depth>=33 && $depth <=69.99) && ($magnivalue>=4 && $magnivalue<=4.9)){
	   #print "12\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=12 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=12 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}	
	if  (($depth>=33 && $depth <=69.99) && ($magnivalue>=5 && $magnivalue<=5.9)){
	   #print "13\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=13 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=13 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}	
	if  (($depth>=33 && $depth <=69.99) && ($magnivalue>=6 && $magnivalue<=8.0)){
	   #print "14\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=14 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=14 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}	
#--------------------------------------------------------------------------------	
	if  (($depth>=70 && $depth <=149.99) && ($magnivalue>=0 && $magnivalue<=0.9)){
	   #print "15\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=15 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=15 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

	}
	if  (($depth>=70 && $depth <=149.99) && ($magnivalue>=1 && $magnivalue<=1.9)){
	   #print "16\n";
	   #print "$magnivalue\n";
	   	print "UPDATE magnitudes SET gradual=16 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=16 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

	}
	if  (($depth>=70 && $depth <=149.99) && ($magnivalue>=2 && $magnivalue<=2.9)){
	   #print "17\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=17 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=17 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

	}	
	if  (($depth>=70 && $depth <=149.99) && ($magnivalue>=3 && $magnivalue<=3.9)){
	   #print "18\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=18 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=18 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

	}
	if  (($depth>=70 && $depth <=149.99) && ($magnivalue>=4 && $magnivalue<=4.9)){
	   #print "19\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=19 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=19 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

	}	
	if  (($depth>=70 && $depth <=149.99) && ($magnivalue>=5 && $magnivalue<=5.9)){
	   #print "20\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=20 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=20 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

	}	
	if  (($depth>=70 && $depth <=149.99) && ($magnivalue>=6 && $magnivalue<=8.0)){
	   #print "21\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=21 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=21 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

	}	
#--------------------------------------------------------------------------------	
	if  (($depth>=150 && $depth <=999.99) && ($magnivalue>=0 && $magnivalue<=0.9)){
	   #print "22\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=22 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=22 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

	}
	if  (($depth>=150 && $depth <=999.99) && ($magnivalue>=1 && $magnivalue<=1.9)){
	   #print "23\n";
	   #print "$magnivalue\n";
	   	print "UPDATE magnitudes SET gradual=23 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=23 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

	}
	if  (($depth>=150 && $depth <=999.99) && ($magnivalue>=2 && $magnivalue<=2.9)){
	   #print "24\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=24 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=24 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

	}	
	if  (($depth>=150 && $depth <=999.99) && ($magnivalue>=3 && $magnivalue<=3.9)){
	   #print "25\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=25 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=25 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}
	if  (($depth>=150 && $depth <=999.99) && ($magnivalue>=4 && $magnivalue<=4.9)){
	   #print "26\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=26 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=26 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}	
	if  (($depth>=150 && $depth <=999.99) && ($magnivalue>=5 && $magnivalue<=5.9)){
	   #print "27\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=27 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=27 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}	
	if  (($depth>=150 && $depth <=999.99) && ($magnivalue>=6 && $magnivalue<=8.0)){
	   #print "28\n";
	   #print "\n";
	   	print "UPDATE magnitudes SET gradual=28 WHERE (idevent='$idevent');\n";

		$update_gradual = "UPDATE magnitudes SET gradual=28 WHERE (idevent='$idevent');";

		my $out_upd_gradual = $dbh->prepare($update_gradual) || die "Fallo al preparar la consulta: $DBI::errstr\n";

		$out_upd_gradual->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
	}	
#--------------------------------------------------------------------------------		
}



   
