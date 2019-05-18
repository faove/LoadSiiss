#!/usr/bin/perl
use DBI; # Bookmarks: 49,278 49,278 49,240 0,0 0,0 49,233 49,46 49,2199 49,2308 49,278 # Bookmarks: 75,284 75,284 75,246 0,0 0,0 75,236 75,46 75,2231 75,2340 75,284 # Bookmarks: 48,1380 48,77 0,0 0,0 0,0 0,0 0,0 0,0 0,0 48,1468
use Cwd;
use File::Copy;
use IO::File;

#------------------------------------------------------
#1 * * * * /home/falvarez/Perl/loadsiis.pl >> /home/falvarez/Perl/loadsiis.log

#Programa de lectura de los archivos de SEISAM
#1,11,21,31,41,51 * * * * /home/falvarez/Perl/loadsiis.pl >> /home/falvarez/Perl/loadsiis.log

#Fecha: 22/05/2006
#Modificaciones:
#Fecha: 18/09/2006
#Desarrollado por: FAOVE
#Modificacion cambio de RedHat a Ubuntu 10.10 Servidor HP y ruta local /home/seismo/seismo/REA/UDO__
#Fecha: 11/07/2011

#------------------------------------------------------

#-------------------------------------
#Inicialización de todas las variables
#-------------------------------------
$numstations=0;


#Declaración de Variables
$row_l = "1";
$row_2 = "2";
$row_3 = "3";
$row_4 = "4";
$row_5 = "5";
$row_6 = "6";
$row_7 = "7";
$row_E = "E";
$row_I = "I";
$row_H = "H";
$row_F = "F";
$flag1 = "0";
$flag2 = "0";
$flag3 = "0";

#Inicialización de todas las variables
$idevent='NULL';

#Variables de la tabla events
$nummagns=0;
$numstations=0;
$numphases=0;
$fechafile='-- ::';

#Variables de la tabla computed_values
$DIS=0;
$CAZ=0;
$AZIMU=0;
$D="NULL";

#Variables de la tabla readings
$STAT='NULL';
$P='NULL';
$IDyearsecond='NULL';
$locdatetime_estaciones="-- ::";
$DECISECON=0;
$TRES=0;
$AMPLIT=0;
$PERI=0;
$I='NULL';
$W='NULL';

#Variables de la tabla LOCATIONS
$idagency_pris='NULL';
$idagency_dirs='NULL';
$IDyearsecond='NULL';
$loctype='NULL';
$locdatetime='NULL';
$deciseg=0;
$timeerror=0;
$lat=0;
$laterror=0;
$lon=0;
$lonerror=0;
$depth=0;
$Deptherror=0;
$Gap=0;
$rms=0;
$text='';
$maga1='NULL';

#Variables de la tabla magnitudes
$tipo="NULL";
$idstation="NULL";
$mag1=0;


$idd = "";
#Variable que nos indica las diferentes lineas de un
$here = 0;

#comentario
$comment = 0;
$commenterror = 0;

#Variable que nos indica el estado del archivo
#si esta UDP,NEW etc
$actiond="";

#Estaciones (se utiliza para no introducir estaciones repetidas
#computes_values)
$sta_values="";

#Declaración de las variables que nos permiten
#el acceso con la base de datos sismologica
$db="siiss";
$host="localhost";
$port="3306";
$userid="root";
$passwd="xts74";
$ie=0;
$arch=0;
$ceros ="";


#CONEXION SIN ODBC:
$connectionInfo="DBI:mysql:database=$db;$host:$port";

# Realizamos la conexión a la base de datos
$dbh = DBI->connect($connectionInfo,$userid,$passwd);


#Número del evento hacer modificado
$idupdatevent = "";
#llamada a maxevent
#funcion que busca el ultimo evento
&maxevent;
#print "Max event: $idevent\n";
#--------------------------------------
#Directorio raiz, se inicia la busqueda
#de los archivos
#--------------------------------------
#$tree = "/home/seismo/seismo2";
$tree = "/home/seismo/seismo/REA/UDO__";
#print $tree;
$long_tree = length($tree);

#print $long_tree;

opendir(DIR,$tree);

@dirList = readdir(DIR);

closedir(DIR);
#print @dirList;

foreach (@dirList){

     if (($_ ne ".") && ($_ ne "..")){

           #La variable $_ contiene todos los años 2000,2001,etc...
           #print "\n";
           #print "$_";

           #---------------------------------------------
           #Estamos en /home/seismo/seismo/REA/UDO__/1999
           #Observamos todos los directorios
           #---------------------------------------------
           $tree = $tree ."/". $_;

           $ruta_ads = $tree ."/". $_;
           #Verificamos que sea mayor que el 2000
           #debido que vamos a actualizar la base de datos
           #desde la fecha: 01/04/2006 en adelante

           if ($_ >= 2008){
                 #print $tree;

                 #print "\n";
                 opendir(SUBDIR,$tree);

                 @subdirList = readdir(SUBDIR);

                 #print @subdirList;
                 #la variable @subdirList contiene los meses,
                 #es decir, las carpetas de los meses
                 $nelementos = @subdirList;

                 #print "$nelementos\n";

                 #print $subdirList[0];

                 for($c=0;$c<=$nelementos;$c++){


                      if (($subdirList[$c] ne ".") && ($subdirList[$c] ne "..")){
                            #print "$subdirList[$c], c: $c \n";
                            #----------------------------------------------
                            #Verificamos que sea mayor que el	    2000 10
                            #debido que vamos a actualizar la base de datos
                            #desde la fecha: 01/04/2006 en adelante
                            #----------------------------------------------
                            #if (($_ >= 2006) && ($subdirList[$c] >= 04)){
                            if ($_ >= 2008){
                                #print "$tree,$c\n";
                            #&& ($subdirList[$c] >= 11)){
                                #print "\n";

                                #print "$_ $subdirList[$c]\n";

                                $long_subtree = length($tree);

                                if ($_ == 2008){
                                    #Para el aÃ±o 2000 solo quiero los meses
                                    #Mayores que 11
                                    if ($subdirList[$c] >= 11){
                                        $tree = $tree ."/". $subdirList[$c];
                                        #print "Tree:$tree\n";

                                    }
                                    #print "aÃ±o 2000\n";
                                 }else{

                                        #--------------------------------------
                                        #Estamos en C:\UDO__\1999\01 , 02 , ...
                                        #Observamos todos los directorios
                                        #--------------------------------------
                                        $tree = $tree ."/". $subdirList[$c];

                                }
                                #print "Tree:$tree\n";

                                opendir(SUBDIR2,$tree);

                                @archList = readdir(SUBDIR2);

                                $narchivos = @archList;

                                #print "$narchivos\n";

                                for($a=0;$a<=$narchivos;$a++){

                                     $flag1 = "0";
                                     $flag2 = "0";
                                     $flag3 = "0";

                                     #--------------------------------------------
                                     #Estamos en C:\UDO__\1999\01\199901121136.out
                                     #tenemos los archivos que deseamos leer
                                     #--------------------------------------------
                                     if (($archList[$a] ne ".") && ($archList[$a] ne "..")){
                                           #print "$archList[$a]\n";
                                           if ($archList[$a]=~/.S/){

                                                #print "\n";
                                                #print "Archivo:$archList[$a]\n";
                                                #$filea=$archList[$a];

                                                #Valor anterior del tree
                                                $backtree = $tree;

                                                #Asignacion de la ruta adsoluta del archivo
                                                $tree = $tree."/".$archList[$a];

                                                #print "$tree\n";
                                                #-----------------------------------------
                                                #Tenemos que ver los atributos de cada
                                                #archivo para ver si han sidos modificados
                                                #-----------------------------------------
                                                $filea = $tree;

                                                #print "$archList[$a]\n";

                                                open(F,"$filea");

                                                #stat contiene un array de los elements
                                                @fileAttributes = stat(F);

                                                @modifyTime = localtime($fileAttributes[9]);
                                                #print "@modifyTime\n";

                                                $modimes = $modifyTime[4] + 1;

                                                $long_modifyTime = length($modifyTime[5]);

                                                #print "tamaño:  $long_modifyTime,$modifyTime[5]\n";
                                                if ($long_modifyTime>2){
                                                      $modify_anio = substr($modifyTime[5],1,2);
                                                }else{
                                                      $modify_anio = $modifyTime[5];
                                                }
                                                $modify_anio = normalizeYear($modify_anio);
                                                if ($modimes<10){
                                                        $modimes = sprintf("%02d",$modimes);
                                                }
                                                if ($modifyTime[3]<10){
                                                        $modifyTime[3] = sprintf("%02d",$modifyTime[3]);
                                                }
                                                if ($modifyTime[2]<10){
                                                        $modifyTime[2] = sprintf("%02d",$modifyTime[2]);
                                                }
                                                if ($modifyTime[1]<10){
                                                        $modifyTime[1] = sprintf("%02d",$modifyTime[1]);
                                                }
                                                if ($modifyTime[0]<10){
                                                        $modifyTime[0] = sprintf("%02d",$modifyTime[0]);
                                                }

                                                #Asignamos las fechas
                                                $fechafile ="$modify_anio-$modimes-$modifyTime[3] $modifyTime[2]:$modifyTime[1]:$modifyTime[0]";

                                                #print "$fechafile\n";
                                                #Variables que nos indica los atributos de los archivos
                                                #print "Modificado: $modifyTime[2]:$modifyTime[1]:$modifyTime[0],$modifyTime[3]/$modimes/$modify_anio\n";

                                                #--------------------------------------
                                                #Primero se verifica si esta el archivo
                                                #--------------------------------------
                                                $query_arch = "select namefile,modifyfile,idevent from events where namefile = '$archList[$a]'";

                                                #print "$query_arch\n";

                                                my $out3 = $dbh->prepare($query_arch) || die "Fallo al preparar la consulta: $DBI::errstr\n";

                                                $out3->execute() or print "No puedo ejecutar la consulta";

                                                $filas=$dbh->do($query_arch);

                                                #Verificamos si el archivo
                                                if ($filas==1){
                                                     #print "$filas";
                                                     #Este mientras se utiliza para update el evento
                                                     while(my(@name)=$out3->fetchrow_array) {
                                                           #----------------------------------------
                                                           #las fechas de modificacion del archivo
                                                           #para averiguar si se tiene que update en
                                                           #la BD, sino no se hace nada
                                                           #----------------------------------------
                                                           $idupdatevent = $name[2];
                                                           #Preguntamos si las fecha son las mismas
                                                           if ($fechafile ne $name[1]){
                                                             #print "no iguales\n";
                                                             #&verificaction;
                                                             #print "$actiond\n";
                                                             #if ($actiond eq "UPD"){
                                                             #Llamada a updatefile para modificar el archivo
                                                             #print "$fechafile / $name[1] /$name[2] Update\n";
                                                                     $text="";
                                                                &updatefile;
                                                             #}
                                                           }
                                                           # $namefile{$arch}=$name;
                                                           #print "Nombre del Archivo BD:$name[0]\n";
                                                           # print "\n";
#                                                            print "$modify_anio-$modimes-$modifyTime[3] $modifyTime[2]:$modifyTime[1]:$modifyTime[0]";
#                                                            print " $name[1]\n";
#                                                            print "$name[2]";
                                                           #$idev{$ie} = $id;
                                                           #print $name_file;
                                                           # print "$long_event\n";
                                                     #       print "$idevent";
                                                     #       print "\n";
                                                           #$ie++;
                                                     }
                                                }else{
                                                     #Verificamos si ACTION=UPD para insertar en
                                                     #archivo
                                                     #&verificaction;
                                                     #print "$actiond";
                                                     #print $actiond;
                                                     #if ($actiond eq "UPD"){
                                                        #-----------------------------------------
                                                        #Si el archivo que estoy leyendo no esta
                                                        #se inserta
                                                        #-----------------------------------------
                                                        #print "Insert\n";

                                                        #Llamada a insertfile para insertar el archivo
                                                        $text="";
                                                        &insertfile;
                                                        &maxevent;
                                                        #print "Max event: $idevent\n";
                                                     #}
                                                } #fin del if que nos indica si insertamos o modificamos

                                                #Reiniciamos la variable $ceros
                                                #para realizar la nueva concatenación
                                                $ceros ="";
                                                #print "Llamada a buscar el evento max\n";
                                               #llamada a maxevent para el siguiente evento


                                                #Cerramos el archivo
                                                close(F);

                                                #Regresar tree a su valor anterior
                                                $tree=$backtree;
                                           }
                                     }
                                }

                                if (length($tree) > 25) {
                                    $tree = "/home/seismo/seismo/REA/UDO__" . "/" . $_;
                                }
                            } #fin del 2006/04

                            #$tree = $ruta_ads;
                            #print "Nuevo tree: $tree\n";
                            #print "Ruta:$ruta_ads\n";
                       }
                 }#Fin del if mayor 2006
           }
           if (length($tree) > 20) {
               $tree = "/home/seismo/seismo/REA/UDO__";
           }
     }
#$dbh->disconnect
}

sub normalizeYear {
        local ($year)=@_;
        #print "@_\n";
        #print "$year\n";

        if ($year < 90){
                sprintf "20%.2d",$year;
        }
        elsif ($year < 100){
                sprintf "19%.2d",$year;
        }
        else {
                sprintf "%.4d",$year;
        }
}

# sub prueba{
# ($a,$b)=@_;
# print "$a\n";
# return $a+$b;
# }
#sub verificaction{
#print "Llamada a Verificacion\n";
#//////////////////////////////////////////////////////////////////
 #while ($linea=<F>){
        #print "dentro de mientras";
        #------------------------------------------------------
        #La variable $indica, nos dice en que parte del archivo
        #nos encontramos, posicionandonos al final del xxxx.out
        #------------------------------------------------------
        #$indica = substr($linea,79,80);
        #chop($indica);
        #if ($indica eq $row_I){

                #Last action done, so far defined SPL: Split
                #REG: Register
                #ARG: AUTO Register, AUTOREG
                #UPD: Update
                #UP : Update only from EEV
                #REE: Register from EEV
                #DUB: Duplicated event
                #NEW: New event
        #        $actiond = substr($linea,8,3);
                #print "$actiondone\n";

       # }
 #}

#}
sub maxevent{
$ceros="";
#Sentencia SQL
#Debemos buscar el ultimo evento
#$query = "select MAX(idevent) AS idev from locations where idagency_pris='csudo'";
$query = "select MAX(idevent) AS idev from events";
#print "$query";
my $out2 = $dbh->prepare($query);

$out2->execute;

while(my($id)=$out2->fetchrow_array) {
      $idev{$ie} = $id;
      $idevent = $idev{$ie};
      #print "Event: $idevent";
      #print "\n";
      $idevent = $idevent + 1;
      $long_event = length($idevent);
      #print "$long_event\n";
      #print "Max event: $idevent";
      #print "\n";
      #$ie++;
}
for ($bucle = 1; $bucle < 9-$long_event; $bucle++){
     $ceros = $ceros . "0";
}
#print "$ceros";
$idevent = $ceros.$idevent;
}


sub insertfile{

#$c = 0;

#-------------------------------------------
#Variable que permite insertar en las tablas
#locations, magnitudes y evento
#esta cambia para cada archivo
#-------------------------------------------

$flagelm = "1";
#unica entrada a linea numero 1
$flagrow_1="1";

 while ($linea=<F>){
    #$c++;

    #------------------------------------------------------
    #La variable $indica, nos dice en que parte del archivo
    #nos encontramos, posicionandonos al final del xxxx.out
    #------------------------------------------------------
    #print "Esta es la linea $linea\n";

    $indica = substr($linea,79,80);

    chop($indica);


         if ($indica eq $row_l){


              $latitude = substr($linea,23,7);

              if(length ($latitude) > 0 && $latitude ne ""){

               #unica entrada a la linea numero 1
               if ($flagrow_1 eq "1"){

                $flagrow_1="0";

                $flag3 = "1";

                #print "La latitud:";
                #print "$latitude\n";
                #$actiond = substr($linea,8,3);

                #Aqui reinicio $here = 0;
                #para que no entre en $row 7
                $here = 0;

                #Busca el año
                $anio = substr($linea,1,5);
                #chop($anio);
                $anio=~s/\s//g;
                if ($anio eq ""){
                     $anio="NULL";
                }
                #print "Año:$anio";

                #Nos indica el Mes
                $mes = substr($linea,6,2);
                $mes=~s/\s//g;
                #chop($mes);
                if ($mes eq ""){
                     $mes="NULL";
                }
                #print "Mes:$mes";

                #Busca el dia
                $dia = substr($linea,8,2);
                #chop($dia);
                $dia=~s/\s//g;
                if ($dia eq ""){
                     $dia="NULL";
                }
                #print "Dia:$dia";

                #Busca la Hora
                $hora = substr($linea,11,2);
                #chop($hora);
                $hora=~s/\s//g;
                if ($hora eq ""){
                     $hora="NULL";
                }
                #print "$hora";

                #Busca la Minuto
                $minuto = substr($linea,13,3);
                $minuto=~s/\s//g;
                if ($minuto eq ""){
                     $minuto="NULL";
                }
                #print "$minuto";

                #Busca la Segundos
                $seg = substr($linea,16,2);
                $seg=~s/\s//g;
                if ($seg eq ""){
                     $seg="NULL";
                }
                #print "$seg";

                #Busca la decimas de segundos
                $deciseg = substr($linea,18,3);
                $deciseg=~s/\s//g;
                $deciseg="0"."$deciseg";

                #print "$deciseg";

                #Busca la Location model indicator
                $lmi = substr($linea,20,1);
                $lmi=~s/\s//g;
                if ($lmi eq ""){
                     $lmi="NULL";
                }
                #print "$lmi";

                #Busca la Distance Indicator L = Local, R = Regional, etc.
                $di = substr($linea,21,1);
                $di=~s/\s//g;
                if ($di eq ""){
                     $di="NULL";
                }
                #print "$di";

                #Event ID E = Explosion, etc.
                $eid = substr($linea,22,1);
                $eid=~s/\s//g;
                if ($eid eq ""){
                     $eid="NULL";
                }
                #print "$eid";

                # Latitude
                $lat = substr($linea,23,7);
                $lat=~s/\s//g;
                if ($lat eq ""){
                     $lat="NULL";
                }
                #print "$lat";

                # Longitude
                $lon = substr($linea,30,8);
                $lon=~s/\s//g;
                if ($lon eq ""){
                     $lon="NULL";
                }
                #print "$lon";

                #Depth
                $depth = substr($linea,38,6);
                $depth=~s/\s//g;
                if ($depth eq ""){
                     $depth="NULL";
                }
                #print "$depth";

                #Depth Indicator F = Fixed, S = Starting value
                $depthi = substr($linea,43,1);
                $depthi=~s/\s//g;
                if ($depthi eq ""){
                     $depthi="NULL";
                }
                #print "$depthi";

                #Locating indicator
                $loci = substr($linea,44,1);
                $loci=~s/\s//g;
                if ($loci eq ""){
                     $loci="NULL";
                }
                #print "$loci";

                #Hypocenter Reporting Agency
                $hypora = substr($linea,45,3);
                $hypora=~s/\s//g;
                if ($hypora eq ""){
                     $hypora="NULL";
                }
                #print "$hypora";

                #Number of Stations Used
                $numstations = substr($linea,49,2);
                $numstations=~s/\s//g;
                if ($numstations eq ''){
                     $numstations="NULL";
                }
                #print $numstations;

                #print "$numstations";

                #RMS of Time Residuals
                $rms = substr($linea,51,4);
                $rms=~s/\s//g;
                if ($rms eq ""){
                     $rms="NULL";
                }

                #print "$rms";

                #Magnitude No. 1
                $mag1 = substr($linea,55,4);
                #$mag1
                #$cadena=lenght($mag1);
                $mag1=~s/\s//g;
                if ($mag1 eq ""){
                     $mag1="NULL";
                }
                #print "Magnitud: $mag1\n";

                #Type of Magnitude 1
                $type1 = substr($linea,59,1);
                $type1=~s/\s//g;
                if ($type1 eq ""){
                     $type1="NULL";
                }
                #print "$type1";

                #Magnitude Reporting Agency 1
                $maga1 = substr($linea,60,3);
                $maga1=~s/\s//g;
                if ($maga1 eq ''){
                     $maga1='NULL';
                }
                #print "$maga1";

                #Magnitude No. 2
                $mag2 = substr($linea,64,3);
                #mag2
                $mag2=~s/\s//g;
                if ($mag2 eq ""){
                     $mag2="NULL";
                }
                #print "Magnitud2: $mag2";

                #Type of Magnitude 2
                $type2 = substr($linea,67,1);
                $type2=~s/\s//g;
                if ($type2 eq ""){
                     $type2="NULL";
                }
                #print "$type2";

                #Magnitude Reporting Agency 2
                $maga2 = substr($linea,68,3);
                $maga2=~s/\s//g;
                if ($maga2 eq ""){
                     $maga2="NULL";
                }
                #print "$maga2";

                #Magnitude No. 3
                if ($STAT eq ""){
                     $STAT="NULL";
                }
                $mag3 = substr($linea,72,3);
                $cadena=length($mag3);
                $mag3=~s/\s//g;
                if ($mag3 eq ""){
                     $mag3="NULL";
                }
                #$cadena=length($mag3);
                #print "Magnitud3: $cadena";

                #Type of Magnitude 3
                $type3 = substr($linea,75,1);
                $type3=~s/\s//g;
                if ($type3 eq ""){
                     $type3="NULL";
                }
                #print "$type3";

                #Magnitude Reporting Agency 3
                $maga3 = substr($linea,76,3);
                $maga3=~s/\s//g;
                if ($maga3 eq ""){
                     $maga3="NULL";
                }
                #print "$maga3";
            } # fin de $flagrow_1="1";
          }else{ #fin del if latitudes
                $flag3="0";
          }



        }

        if ($indica eq $row_2){

                #print "$linea";

                #Any descriptive text
                $desctext = substr($linea,5,15);
                #print "$desctext";

                #Diastrophism code
                #F = Surface faulting
                #U = Uplift or subsidence
                #D = Faulting and Uplift/Subsidence
                $Diast = substr($linea,22,1);
                #print "$Diast";

                #Tsunami code (PDE type)
                #T = Tsunami generated
                #Q = Possible tsunami
                $Tsunami = substr($linea,23,1);
                #print "$Tsunami";

                #Seiche code
                #S = Seiche
                #Q = Possible seiche
                $Seiche = substr($linea,24,1);
                #print "$Seiche";

                #Cultural effects
                #C = Casualties reported
                #D = Damage reported
                #F = Earthquake was felt
                #H = Earthquake was heard
                $Cultural = substr($linea,25,1);
                #print "$Cultural";

                #Unusual events
                #L = Liquefaction
                #G = Geysir/fumerol
                #S = Landslides/Avalanches
                #B = Sand blows
                #C = Cracking in the ground (not normal faulting).
                #V = Visual phenomena
                #O = Olfactory  phenomena
                #M = More than one of the above observed.
                $Unusual = substr($linea,26,1);
                #print "$Unusual\n";

                #Max Intensity
                $Maxi = substr($linea,28,2);
                #print "$Maxi\n";

                #Max Intensity qualifier
                $Maxiq = substr($linea,30,1);
                #print "$Maxiq\n";

                #Intensity scale (ISC type defintions)
                #MM = Modified Mercalli
                #RF = Rossi Forel
                #CS = Mercalli - Cancani - Seberg
                #SK = Medevev - Sponheur - Karnik
                $intscale = substr($linea,31,2);
                #print "$intscale\n";

                # Macroseismic latitude (Decimal)
                $macrolat = substr($linea,34,6);
                #print "$macrolat\n";

                # Macroseismic longitude (Decimal)
                $macrolon = substr($linea,41,6);
                #print "$macrolon\n";

                #Macroseismic magnitude
                $macromag = substr($linea,49,3);
                #print "$macromag\n";

                #Type of magnitude
                #I = Magnitude based on maximum Intensity.
                #A = Magnitude based on felt area.
                #R = Magnitude based on radius of felt area.
                #* = Magnitude calculated by use of special formulas
                #developed by some person for a certain area.
                $Typemag = substr($linea,52,1);
                #print "$Typemag\n";

                #Logarithm (base 10) of radius of felt area
                $Logaradio = substr($linea,53,4);
                #print "$Logaradio\n";

                #Logarithm (base 10) of area (km**2) number 1 where
                #earthquake was felt exceeding a given intensity.
                $Logararea1 = substr($linea,57,5);
                #print "$Logararea\n";

                #Intensity boardering the area number 1
                $Intenboard1 = substr($linea,62,2);
                #print "$Intenboard1\n";

                #Logarithm (base 10) of area (km**2) number 2 where
                #earthquake was felt  exceeding a given intensity.
                $Logararea2 = substr($linea,64,5);
                #print "$Logararea2\n";

                #Intensity boardering the area number 2.
                $Intenboard2 = substr($linea,69,2);
                #print "$Intenboard2\n";

                #Quality rank of the report (A, B, C, D)
                $Qualityrank = substr($linea,72,1);
                #print "$Qualityrank\n";

                #Reporting  agency
                $Reportagency = substr($linea,73,3);
                #print "$Reportagency\n";

        }
        if ($indica eq $row_3){

                #print "$linea\n";
                if ($comments == 1){
                      #Comments Text concatenado
                      $text = $text . substr($linea,1,78);
                      #print "$text";

                }else{
                      #Comments Text
                      $text = substr($linea,1,78);
                      #print "$text";
                      $comments = 1;
                }
        } #fin $row_3

        if ($indica ne $row_3){
             $comment = 0;
        }
        if ($indica eq $row_4){
                #print "$linea\n";

                #Station Name
                $Station = substr($linea,1,5);
                #print "Station";

                #Instrument Type S = SP, I = IP, L = LP etc
                $Instype = substr($linea,7,1);
                #print "$Instype";

                #Component Z, N, E
                $Component = substr($linea,8,1);
                #print "$Component";

                #Quality Indicator I, E, etc
                $QualityIndi= substr($linea,10,1);
                #print "$QualityIndi";

                #Phase ID PN, PG, LG, P, S, etc. **
                $PhaseID = substr($linea,11,4);
                #print "$PhaseID";

                #Weighting Indicator (1-4) 0 = full weight (as in HYPO)
                $WeightIndi = substr($linea,15,1);
                #print "$WeightIndi";

                #Free or flag A to indicate automartic pick, removed when rpicking
                $flagA = substr($linea,16,1);
                #print "$flagA";

                #First Motion  C, D
                $FirstMotion = substr($linea,17,1);
                #print "$FirstMotion";

                #Hour
                $Hour = substr($linea,19,2);
                #print "$Hour";

                #Minutes
                $Minutes = substr($linea,21,2);
                #print "$Minutes";

                #Seconds
                $Seconds = substr($linea,23,6);
                #print "$Seconds";

                #Duration (to noise)  Seconds
                $Duration = substr($linea,30,3);
                #print "$Duration";

                # Amplitude (Zero-Peak) Nanometers
                $Amplitude = substr($linea,34,6);
                #print "$Amplitude";

                #Period
                $Period = substr($linea,42,4);
                #print "$Period";

                #Direction of Approach Degrees
                $Direction = substr($linea,47 ,5);
                #print "$Direction";

                #Phase Velocity Km/second
                $PhaseVelocity = substr($linea,53,3);
                #print "$PhaseVelocity";

                #Angle of incidence (was Signal to noise ratio before version 8.0)
                $Angleincid = substr($linea,57,4);
                #print "$Angleincid";

                #Azimuth residual
                $Azimuthresi = substr($linea,61,3);
                #print "$Azimuthresi";

                #Travel time residual
                $timeresid = substr($linea,64,4);
                #print "$timeresid";

                #Weight
                $Weight = substr($linea,69,2);
                #print "$Weight";

                #Epicentral distance(km
                $Epicentral = substr($linea,71,5);
                #print "$Epicentral";

                #Azimuth at source
                $Azimuthsource = substr($linea,77,3);
                #print "$Azimuthsource";


        }
        if ($indica eq $row_5){

                #print "$linea\n";
                if ($commentserror == 1){
                      #Comments Error
                      $errortext = $errortext . substr($linea,1,78);
                      #print "$errortext\n";

                }else{
                      #Comments Text
                      $errortext = substr($linea,1,78);
                      #print "$errortext\n";
                      $commentserror = 1;
                }

        }

        if ($indica ne $row_5){
             $commenterror = 0;
        }

        if ($indica eq $row_6){

                #Name(s) of tracedata file
                $tracedata = substr($linea,1,78);
                #print "$tracedata";

        }
        if ($indica eq $row_F){

                #Strike, dip and rake, Aki convention
                $Strike = substr($linea,1,30);
                #print "$Strike";

                #Number of bad polarities
                $badpolarit = substr($linea,31,6);
                #print "$badpolarit";

                #Method or source of solution, seisan mames INVRAD or FOCMEC
                $source = substr($linea,71,6);
                #print "$source";

                #Quality of solution, A (best), B C or D (worst), added manually
                $Qualitysol = substr($linea,78,1);
                #print "$Qualitysol";

                #Remain in file and can be plotted
                $Remain = substr($linea,79,1);
                #print "$Remain";


        }

        if ($indica eq $row_E){

                #Gap
                $Gap = substr($linea,5,4);
                $Gap=~s/\s//g;
                if ($Gap eq ""){
                     $Gap="NULL";
                }
                #print "$Gap";

                #Origin time error
                $timeerror = substr($linea,15,6);
                #chop($timeerror);
                $timeerror=~s/\s//g;
                if ($timeerror eq ""){
                     $timeerror="NULL";
                }
                #print "Error time:$timeerror";

                #Latitude (y) error
                $laterror = substr($linea,24,6);
                $laterror=~s/\s//g;
                if ($laterror eq ""){
                     $laterror="NULL";
                }
                #print "$laterror";

                #Longitude (x) error (km)
                $lonerror = substr($linea,32,6);
                $lonerror=~s/\s//g;
                if ($lonerror eq ""){
                     $lonerror="NULL";
                }
                #print "$lonerror";

                #Depth (z) error (km)
                $Deptherror = substr($linea,38,6);
                $Deptherror=~s/\s//g;
                if ($Deptherror eq ""){
                     $Deptherror="NULL";
                }
                #print "$Deptherror";

                #Covariance (x,y) km*km
                $Covariancexy = substr($linea,43,12);
                $Gap=~s/\s//g;
                if ($Gap eq ""){
                     $Gap="NULL";
                }
                #print "$Covariancexy";

                #Covarience (x,z) km*km
                $Covariancexz = substr($linea,55,12);
                $Covariancexz=~s/\s//g;
                if ($Covariancexz eq ""){
                     $Covariancexz="NULL";
                }
                #print "$Covariancexz";

                #Covariance (y,z) km*km
                $Covarianceyz = substr($linea,67,12);
                $Covarianceyz=~s/\s//g;
                if ($Covarianceyz eq ""){
                     $Covarianceyz="NULL";
                }
                #print "$Covarianceyz";


        }



          if ($indica eq $row_I){

                $actiond = substr($linea,8,3);


                    if (($actiond eq "UPD") || ($actiond eq "UP ")){
                         #La primera bandera indica que el archivo
                        #a sido updateado por lo tanto solo falta verificar las
                        #otras banderas para poder insertar un evento nuevo
                        $flag1="1";

                        #Verificar si existe un Operater code
                             $Operador = substr($linea,30,4);

                             if (length ($Operador) > 0){
                         #Segunda bandera verificada
                         $flag2=1;
                         #print "$Operador\n";
                         #Last action done, so far defined SPL: Split
                         #REG: Register
                         #ARG: AUTO Register, AUTOREG
                         #UPD: Update
                         #UP : Update only from EEV
                         #REE: Register from EEV
                         #DUB: Duplicated event
                         #NEW: New event
                         $actiondone = substr($linea,8,3);
                         #print "$actiondone";

                         #Date and time of last action
                         $Dateaction = substr($linea,12,14);
                         #print "$Dateaction";

                         #Operater code
                         $Operatercode = substr($linea,30,4);
                         #print "$Operatercode";

                         #Status flags, not yet defined
                         $Statusflags = substr($linea,42,14);
                         #print "$Statusflags";

                         #ID, year to second
                         $IDyearsecond = substr($linea,60,14);
                         #print "$IDyearsecond";

                         #If d, this indicate that a new file id had to be created which was
                         #one or more seconds different from an existing ID to avoid overwrite.
                         $idd = substr($linea,74,1);
                         #print "Identificador: $idd";

                         #Indicate if ID is locked. Blank means not locked, L means locked.
                         $locked = substr($linea,75,1);
                         #print "$locked";

                         }else{ #fin del if que verifica que el operador existe
                                $flag2="0";
                         }
                        }else{ #fin del if que verifica que ha sido actualizado
                                $flag1="0";
                        }

          }

        if ($indica eq $row_H){

                # High accuracy hypoenter line

                #Seconds, f6.3
                $Secondsh = substr($linea,16,1);
                #print "$Secondsh";

                #Latitude, f9.5
                $Latitudeh = substr($linea,23,9);
                #print "$Latitudeh";

                #Longitude, f10.5
                $Longitudeh = substr($linea,33,11);
                #print "$Longitudeh";

                #Depth, f8.3
                $Depthh = substr($linea,44,8);
                #print "$Depthh";

                #RMS, f6.3
                $RMSh = substr($linea,53,9);
                #print "$RMSh";

        }
        #----------------------------------
        #Debido a que realizo comparaciones
        #con la agency antes de insert read
        #he asignado sus valores antes
        #----------------------------------
        #Magnitudes
        #El evento, $idevent por ejemplo: 00010775

        #La agencia $idagency_pris si el UDO contenida el la variable
        #$maga1 asignar CSUDO
        #Seleccionando el tipo de Estación
        if ($maga1 eq "UDO"){

                $idagency_pris = "CSUDO";
                $idstation = "00000";
                $idagency_dirs= "CSUDO";

        }else{

                $idagency_dirs= $maga1;
                $idagency_pris = $maga1;
                $idstation = $maga1;

        }

        #Buscando el tipo de Magnitud
        if ($type1 eq "L"){

                  $tipo= "ML";

        }elsif ($type1 eq "C"){

                  $tipo= "MD";

        }elsif ($type1 eq "B"){

                  $tipo= "mb";

        }elsif ($type1 eq "S"){

                  $tipo= "Ms";

        }

        #Insertar los valores en la tabla locations

        # Si el evento tiene latitud, longitud, profundidad y tiempo origen,
        # dicho evento tiene loctype= 4 (de completo)sino loctype=t (incompleto)
        if (($lat ne "") && ($lon ne "") && ($depth ne "") && ($hora ne "")) {
                      $loctype= "4";
        }else{
                      $loctype= "t";
        }

        #locdatetime almacenará el tiempo origen
        $locdatetime= "$anio" . "-" . "$mes" . "-" . "$dia" . " " . "$hora" . ":" . "$minuto" . ":" . "$seg";

        #Funcion que nos indica la cantidad de magnitudes reportadas
        if (length($mag1)>0) {
             $nummagns=1;
        }elsif (length($mag2)>0) {
             $nummagns=2;
        }elsif (length($mag3)>0) {
             $nummagns=3;
        }else{
             $nummagns=0;
        }
        #Funcion que se encarga de colocar null al comentario
        #si no existe en el archivo seisan
        if (!($text=~ /[A-Za-z0-9]/)) {
             $text=~s/\s//g;
             if ($text eq ""){
              $text="NULL";
             }
        }


        #----------------------------
        #Numero de fases de un evento
        #----------------------------
        $numphases=0;
        if ($indica eq $row_7){
              $here = 1;

        }else{
              if ($here == 1){
                   #print "$indica";

                $numphases++;
                #STAT
                $STAT = substr($linea,1,5);
                $STAT=~s/\s//g;
                if ($STAT eq ""){
                     $STAT="NULL";
                }
                #print "$STAT";

                #SP
                $SP = substr($linea,6,2);
                $SP=~s/\s//g;
                if ($SP eq ""){
                     $SP="NULL";
                }
                #print "$SP";

                #I
                $I = substr($linea,9,1);
                $I=~s/\s//g;
                if ($I eq ""){
                     $I="NULL";
                }
                #print "$I";

                #P
                $P = substr($linea,10,1);
                $P=~s/\s//g;
                if ($P eq ""){
                     $P="NULL";
                }
                #print "$P";

                #H
                $H = substr($linea,11,1);
                $H=~s/\s//g;
                if ($H eq ""){
                     $H="NULL";
                }
                #print "$H";

                #A
                $A = substr($linea,12,1);
                $A=~s/\s//g;
                if ($A eq ""){
                     $A="NULL";
                }
                #print "$A";
                #S
                $S = substr($linea,13,1);
                $S=~s/\s//g;
                if ($S eq ""){
                     $S="NULL";
                }
                #print "$S";

                #W
                $W = substr($linea,14,1);
                $W=~s/\s//g;
                if ($W eq ""){
                     $W="NULL";
                }
                #print "$W";

                #D
                $D = substr($linea,16,1);
                $D=~s/\s//g;
                if ($D eq ""){
                     $D="NULL";
                }
                #print "$D";

                #HR
                $HR = substr($linea,18,2);
                $HR=~s/\s//g;
                if ($HR eq ""){
                     $HR="";
                }
                #print "$HR";

                #MM
                $MM = substr($linea,20,2);
                $MM=~s/\s//g;
                if ($MM eq ""){
                     $MM="";
                }
                #print "$MM"
                #SECON
                $SECON = substr($linea,23,2);
                $SECON=~s/\s//g;
                if ($SECON eq ""){
                     $SECON="";
                }
                #print "$SECON";

                #DECISECON
                $DECISECON = substr($linea,25,3);
                $DECISECON=~s/\s//g;
                if ($DECISECON eq ""){
                     $DECISECON=0;
                }else{
                      $DECISECON="0".$DECISECON;
                }
                #print "$DECISECON";

                #locdatetime almacenará el tiempo origen
                $locdatetime_estaciones= "$anio" . "-" . "$mes" . "-" . "$dia" . " " . "$HR" . ":" . "$MM" . ":" . "$SECON";
                #CODA
                $CODA = substr($linea,29,4);
                $CODA=~s/\s//g;
                if ($CODA eq ""){
                     $CODA="NULL";
                }
                #print "$CODA";

                #AMPLIT
                $AMPLIT = substr($linea,34,6);
                $AMPLIT=~s/\s//g;
                if ($AMPLIT eq ""){
                     $AMPLIT="NULL";
                }
                #print "$AMPLIT";

                #PERI
                $PERI = substr($linea,41,4);
                $PERI=~s/\s//g;
                if ($PERI eq ""){
                     $PERI="NULL";
                }
                #print "PERIODO $PERI";

                #AZIMU
                $AZIMU = substr($linea,46,5);
                $AZIMU=~s/\s//g;
                if ($AZIMU eq ""){
                     $AZIMU="NULL";
                }
                #print "$AZIMU";

                #VELO
                $VELO = substr($linea,52,4);
                $VELO=~s/\s//g;
                if ($VELO eq ""){
                     $VELO="NULL";
                }
                #print "$VELO";

                #SNR
                $SNR = substr($linea,57,3);
                $SNR=~s/\s//g;
                if ($SNR eq ""){
                     $SNR="NULL";
                }
                #print "$SNR";

                #AR  : Azimuth residual when using azimuth information in locations
                $AR = substr($linea,61,2);
                $AR=~s/\s//g;
                if ($AR eq ""){
                     $AR="NULL";
                }
                #print "$AR";

                #TRES: Travel time residual
                $TRES = substr($linea,63,5);
                $TRES=~s/\s//g;
                if ($TRES eq ""){
                     $TRES="NULL";
                }
                #print " $TRES";

                #W   : Actual weight used for location ( inc. e.g. distance weight)
                $W = substr($linea,68,2);
                $W=~s/\s//g;
                if ($W eq ""){
                     $W="NULL";
                }
                #print "$W";

                #DIS : Epicentral distance in kms
                $DIS = substr($linea,72,3);
                $DIS=~s/\s//g;
                if ($DIS eq ""){
                     $DIS="NULL";
                }
                #print "$DIS";

                #CAZ : Azimuth from event to station
                $CAZ = substr($linea,76,3);
                $CAZ=~s/\s//g;
                if ($CAZ eq ""){
                     $CAZ="NULL";
                }
                #print "$CAZ";

                #----------------------------------
                #Insertando los valores en readings
                #----------------------------------
#        print "El tipo: $tipo agency es: $idagency_pris\n";
        if ($flag1 eq "1"){
                if ($flag2 eq "1"){
                  if ($flag3 eq "1"){
                        if ($idagency_pris ne "NULL"){
                          if ($STAT ne "NULL"){
                                     if ($P ne "NULL"){


                                    #print "La primera bandera $flag1\n";
                                    #print "La segunda bandera $flag2\n";
                                    #print "La tercera bandera $flag3\n";
                             #print "\n";
                        #print "INSERT INTO readings VALUES('$idevent','$STAT','$P','$I','$SP','$IDyearsecond','$locdatetime_estaciones',$DECISECON,2,$TRES,$AMPLIT,$PERI,'$W', NULL, NULL, NULL);\n";

                        #--------------------------------------
                        #Primero si ya fue guardado en readings
                        #--------------------------------------
                        $query_read = "select idevent,idstation,idphase,quality,component from readings where (idevent = '$idevent' and idstation = '$STAT' and idphase = '$P' and quality = '$I' and component ='$SP')";

                        #print "$query_read\n";

                        my $out_read = $dbh->prepare($query_read) || die "Fallo al preparar la consulta: $DBI::errstr\n";

                        $out_read->execute() or print "No puedo ejecutar la consulta";

                        $filas_read=$dbh->do($query_read);

                        #Verificamos si el archivo
                        if ($filas_read!=1){

                        $query_readings = "INSERT INTO readings VALUES('$idevent','$STAT','$P','$I','$SP','$IDyearsecond','$locdatetime_estaciones',$DECISECON,2,$TRES,$AMPLIT,$PERI,'$W', NULL, NULL, NULL);";

                        my $out_readings = $dbh->prepare($query_readings) || die "Fallo al preparar la consulta: $DBI::errstr\n";

                        $out_readings->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

                            }
                }
                #-----------------------------------------
                #Insertando los valores en computed_values
                #-----------------------------------------

                  #print "\n";
                  if ($sta_values ne $STAT){


                        #--------------------------------------
                        #Primero si ya fue guardado
                        #--------------------------------------
                        $query_compu = "select idevent,idstation from computed_values where idevent = '$idevent' and idstation = '$STAT' ";

                        #print "$query_compu\n";

                        my $out_compu = $dbh->prepare($query_compu) || die "Fallo al preparar la consulta: $DBI::errstr\n";

                        $out_compu->execute() or print "No puedo ejecutar la consulta";

                        $filas_compu=$dbh->do($query_compu);

                        #Verificamos si el archivo
                        if ($filas_compu!=1){

 #                    print "INSERT INTO computed_values VALUES('$idevent','$STAT','$IDyearsecond',$DIS,$CAZ,$AZIMU,'$D',NULL,NULL,NULL);\n";

                      $query_computed_values = "INSERT INTO computed_values VALUES('$idevent','$STAT','$IDyearsecond',$DIS,$CAZ,$AZIMU,'$D',NULL,NULL,NULL);";

                      my $out_computed_values = $dbh->prepare($query_computed_values) || die "Fallo al preparar la consulta: $DBI::errstr\n";

                      $out_computed_values->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
                        }
                           }
                    $sta_values = $STAT;
                   }
                  }
                 }
                }
               }
              }
             }

        #------------------------------------------------------
        #A continuación se elaboran las sentencia SQL, las cua-
        #les nos permiten insertar en la bd siiss.
        #------------------------------------------------------

        #print "El tipo: $tipo agency es: $idagency_pris\n";
        if ($flag1 eq "1"){
          if ($flag2 eq "1"){
            if ($flag3 eq "1"){
              if ($idagency_pris ne "NULL"){
                if ($tipo ne "NULL"){
                  if ($flagelm eq "1"){
                        #--------------------------------------------------------
                        #A continuacion bandera que me indica que se ha insertado
                        #en las siguientes tablas
                        #--------------------------------------------------------
                        $flagelm = "0";
#                            print "La primera bandera $flag1\n";
#                            print "La segunda bandera $flag2\n";
#                            print "La tercera bandera $flag3\n";


                  #--------------------------
                  #Insertar valores en events
                  #--------------------------
#                  print "\n";
#                  print "Tabla eventos\n";
                  print "INSERT INTO events VALUES('$idevent','$IDyearsecond',1,$nummagns,$numstations,0,$numphases,0,NULL,'$archList[$a]','$fechafile',NULL,NULL,NULL);\n";
                  $query_events ="INSERT INTO events VALUES('$idevent','$IDyearsecond',1,$nummagns,$numstations,0,$numphases,0,NULL,'$archList[$a]','$fechafile',NULL,NULL,NULL);";

                  #print $query_events;

                  my $out_events = $dbh->prepare($query_events) || die "Fallo al preparar la consulta: $DBI::errstr\n";

                  $out_events->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
                 # print "\n";

#                  print "INSERT INTO magnitudes VALUES('$idevent','$idagency_pris','$tipo','$idstation','$idagency_dirs','$IDyearsecond',$mag1,0,$numstations,NULL,NULL,NULL);\n";
                #        print "\n";
                 # print "Tabla Magnitud\n";
                  #------------------------------
                  #Insertar valores en magnitudes
                  #------------------------------

                  $query_magnitudes = "INSERT INTO magnitudes VALUES('$idevent','$idagency_pris','$tipo','$idstation','$idagency_dirs','$IDyearsecond',$mag1,NULL,$numstations,NULL,NULL,NULL,0);";

                  my $out_magnitudes = $dbh->prepare($query_magnitudes) || die "Fallo al preparar la consulta: $DBI::errstr\n";

                  $out_magnitudes->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";
                  #print "deciseg";
                   #print $deciseg;
                  #-----------------------------
                  #Insertar valores en locations
                  #-----------------------------
                #print "\n";
                #print "Tabla locations\n";
#                print "INSERT INTO locations VALUES('$idevent','$idagency_pris','$idagency_dirs','$IDyearsecond','I','$loctype','$locdatetime',$deciseg,1,$timeerror,NULL,$lat,4,$laterror,$lon,4,$lonerror,NULL,$depth,1,$Deptherror,NULL,$Gap,NULL,NULL,NULL,$rms,'SEISAN','$text',NULL,NULL);\n";
                 $text = substr($text,4);
                  $query_locations = "INSERT INTO locations VALUES('$idevent','$idagency_pris','$idagency_dirs','$IDyearsecond','I','$loctype','$locdatetime',$deciseg,1,$timeerror,NULL,$lat,4,$laterror,$lon,4,$lonerror,NULL,$depth,1,$Deptherror,NULL,$Gap,NULL,NULL,NULL,$rms,'SEISAN','$text',NULL,NULL);";
                  $text="";
                          #print "\n";

                  #print $query_locations;
                  my $out_locations = $dbh->prepare($query_locations) || die "Fallo al preparar la consulta: $DBI::errstr\n";

                  $out_locations->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";



                  #//////////////////////////////////////////////////////////////////
                     } #fin del if $flagelm
                    }
                   }
                  } #fin de la flag3 representa la latitud
                } #fin de la flag2 representada el operador
              } #fin de la bandera1 q representa if que pregunta si ha sido update


   } #Fin de Mientras
                              $flag3="0";
                        $flag3="0";
                              $flag3="0";
                        $flagelm = "1";
                        $flagrow_1="1";
} #Fin de la Función insert


#Función que se encarga de actualizar datos
sub updatefile{

#-------------------------------------------
#Variable que permite insertar en las tablas
#locations, magnitudes y evento
#esta cambia para cada archivo
#-------------------------------------------

$flagelm = "1";
#unica entrada a linea numero 1
$flagrow_1="1";

 while ($linea=<F>){
    #$c++;

    #------------------------------------------------------
    #La variable $indica, nos dice en que parte del archivo
    #nos encontramos, posicionandonos al final del xxxx.out
    #------------------------------------------------------
    #print "Esta es la linea $linea\n";

    $indica = substr($linea,79,80);

    chop($indica);


         if ($indica eq $row_l){


              $latitude = substr($linea,23,7);

              if(length ($latitude) > 0 && $latitude ne ""){

               #unica entrada a la linea numero 1
               if ($flagrow_1 eq "1"){

                $flagrow_1="0";

                $flag3 = "1";

                #print "La latitud:";
                #print "$latitude\n";
                #$actiond = substr($linea,8,3);

                #Aqui reinicio $here = 0;
                #para que no entre en $row 7
                $here = 0;

                #Busca el año
                $anio = substr($linea,1,5);
                #chop($anio);
                $anio=~s/\s//g;
                if ($anio eq ""){
                     $anio="NULL";
                }
                #print "Año:$anio";

                #Nos indica el Mes
                $mes = substr($linea,6,2);
                $mes=~s/\s//g;
                #chop($mes);
                if ($mes eq ""){
                     $mes="NULL";
                }
                #print "Mes:$mes";

                #Busca el dia
                $dia = substr($linea,8,2);
                #chop($dia);
                $dia=~s/\s//g;
                if ($dia eq ""){
                     $dia="NULL";
                }
                #print "Dia:$dia";

                #Busca la Hora
                $hora = substr($linea,11,2);
                #chop($hora);
                $hora=~s/\s//g;
                if ($hora eq ""){
                     $hora="NULL";
                }
                #print "$hora";

                #Busca la Minuto
                $minuto = substr($linea,13,3);
                $minuto=~s/\s//g;
                if ($minuto eq ""){
                     $minuto="NULL";
                }
                #print "$minuto";

                #Busca la Segundos
                $seg = substr($linea,16,2);
                $seg=~s/\s//g;
                if ($seg eq ""){
                     $seg="NULL";
                }
                #print "$seg";

                #Busca la decimas de segundos
                $deciseg = substr($linea,18,3);
                $deciseg=~s/\s//g;
                $deciseg="0"."$deciseg";

                #print "$deciseg";

                #Busca la Location model indicator
                $lmi = substr($linea,20,1);
                $lmi=~s/\s//g;
                if ($lmi eq ""){
                     $lmi="NULL";
                }
                #print "$lmi";

                #Busca la Distance Indicator L = Local, R = Regional, etc.
                $di = substr($linea,21,1);
                $di=~s/\s//g;
                if ($di eq ""){
                     $di="NULL";
                }
                #print "$di";

                #Event ID E = Explosion, etc.
                $eid = substr($linea,22,1);
                $eid=~s/\s//g;
                if ($eid eq ""){
                     $eid="NULL";
                }
                #print "$eid";

                # Latitude
                $lat = substr($linea,23,7);
                $lat=~s/\s//g;
                if ($lat eq ""){
                     $lat="NULL";
                }
                #print "$lat";

                # Longitude
                $lon = substr($linea,30,8);
                $lon=~s/\s//g;
                if ($lon eq ""){
                     $lon="NULL";
                }
                #print "$lon";

                #Depth
                $depth = substr($linea,38,6);
                $depth=~s/\s//g;
                if ($depth eq ""){
                     $depth="NULL";
                }
                #print "$depth";

                #Depth Indicator F = Fixed, S = Starting value
                $depthi = substr($linea,43,1);
                $depthi=~s/\s//g;
                if ($depthi eq ""){
                     $depthi="NULL";
                }
                #print "$depthi";

                #Locating indicator
                $loci = substr($linea,44,1);
                $loci=~s/\s//g;
                if ($loci eq ""){
                     $loci="NULL";
                }
                #print "$loci";

                #Hypocenter Reporting Agency
                $hypora = substr($linea,45,3);
                $hypora=~s/\s//g;
                if ($hypora eq ""){
                     $hypora="NULL";
                }
                #print "$hypora";

                #Number of Stations Used
                $numstations = substr($linea,49,2);
                $numstations=~s/\s//g;
                if ($numstations eq ''){
                     $numstations="NULL";
                }
                #print $numstations;

                #print "$numstations";

                #RMS of Time Residuals
                $rms = substr($linea,51,4);
                $rms=~s/\s//g;
                if ($rms eq ""){
                     $rms="NULL";
                }

                #print "$rms";

                #Magnitude No. 1
                $mag1 = substr($linea,55,4);
                #$mag1
                #$cadena=lenght($mag1);
                $mag1=~s/\s//g;
                if ($mag1 eq ""){
                     $mag1="NULL";
                }
                #print "Magnitud: $mag1\n";

                #Type of Magnitude 1
                $type1 = substr($linea,59,1);
                $type1=~s/\s//g;
                if ($type1 eq ""){
                     $type1="NULL";
                }
                #print "$type1";

                #Magnitude Reporting Agency 1
                $maga1 = substr($linea,60,3);
                $maga1=~s/\s//g;
                if ($maga1 eq ''){
                     $maga1='NULL';
                }
                #print "$maga1";

                #Magnitude No. 2
                $mag2 = substr($linea,64,3);
                #mag2
                $mag2=~s/\s//g;
                if ($mag2 eq ""){
                     $mag2="NULL";
                }
                #print "Magnitud2: $mag2";

                #Type of Magnitude 2
                $type2 = substr($linea,67,1);
                $type2=~s/\s//g;
                if ($type2 eq ""){
                     $type2="NULL";
                }
                #print "$type2";

                #Magnitude Reporting Agency 2
                $maga2 = substr($linea,68,3);
                $maga2=~s/\s//g;
                if ($maga2 eq ""){
                     $maga2="NULL";
                }
                #print "$maga2";

                #Magnitude No. 3
                if ($STAT eq ""){
                     $STAT="NULL";
                }
                $mag3 = substr($linea,72,3);
                $cadena=length($mag3);
                $mag3=~s/\s//g;
                if ($mag3 eq ""){
                     $mag3="NULL";
                }
                #$cadena=length($mag3);
                #print "Magnitud3: $cadena";

                #Type of Magnitude 3
                $type3 = substr($linea,75,1);
                $type3=~s/\s//g;
                if ($type3 eq ""){
                     $type3="NULL";
                }
                #print "$type3";

                #Magnitude Reporting Agency 3
                $maga3 = substr($linea,76,3);
                $maga3=~s/\s//g;
                if ($maga3 eq ""){
                     $maga3="NULL";
                }
                #print "$maga3";
            } # fin de $flagrow_1="1";
          }else{ #fin del if latitudes
                $flag3="0";
          }



        }

        if ($indica eq $row_2){

                #print "$linea";

                #Any descriptive text
                $desctext = substr($linea,5,15);
                #print "$desctext";

                #Diastrophism code
                #F = Surface faulting
                #U = Uplift or subsidence
                #D = Faulting and Uplift/Subsidence
                $Diast = substr($linea,22,1);
                #print "$Diast";

                #Tsunami code (PDE type)
                #T = Tsunami generated
                #Q = Possible tsunami
                $Tsunami = substr($linea,23,1);
                #print "$Tsunami";

                #Seiche code
                #S = Seiche
                #Q = Possible seiche
                $Seiche = substr($linea,24,1);
                #print "$Seiche";

                #Cultural effects
                #C = Casualties reported
                #D = Damage reported
                #F = Earthquake was felt
                #H = Earthquake was heard
                $Cultural = substr($linea,25,1);
                #print "$Cultural";

                #Unusual events
                #L = Liquefaction
                #G = Geysir/fumerol
                #S = Landslides/Avalanches
                #B = Sand blows
                #C = Cracking in the ground (not normal faulting).
                #V = Visual phenomena
                #O = Olfactory  phenomena
                #M = More than one of the above observed.
                $Unusual = substr($linea,26,1);
                #print "$Unusual\n";

                #Max Intensity
                $Maxi = substr($linea,28,2);
                #print "$Maxi\n";

                #Max Intensity qualifier
                $Maxiq = substr($linea,30,1);
                #print "$Maxiq\n";

                #Intensity scale (ISC type defintions)
                #MM = Modified Mercalli
                #RF = Rossi Forel
                #CS = Mercalli - Cancani - Seberg
                #SK = Medevev - Sponheur - Karnik
                $intscale = substr($linea,31,2);
                #print "$intscale\n";

                # Macroseismic latitude (Decimal)
                $macrolat = substr($linea,34,6);
                #print "$macrolat\n";

                # Macroseismic longitude (Decimal)
                $macrolon = substr($linea,41,6);
                #print "$macrolon\n";

                #Macroseismic magnitude
                $macromag = substr($linea,49,3);
                #print "$macromag\n";

                #Type of magnitude
                #I = Magnitude based on maximum Intensity.
                #A = Magnitude based on felt area.
                #R = Magnitude based on radius of felt area.
                #* = Magnitude calculated by use of special formulas
                #developed by some person for a certain area.
                $Typemag = substr($linea,52,1);
                #print "$Typemag\n";

                #Logarithm (base 10) of radius of felt area
                $Logaradio = substr($linea,53,4);
                #print "$Logaradio\n";

                #Logarithm (base 10) of area (km**2) number 1 where
                #earthquake was felt exceeding a given intensity.
                $Logararea1 = substr($linea,57,5);
                #print "$Logararea\n";

                #Intensity boardering the area number 1
                $Intenboard1 = substr($linea,62,2);
                #print "$Intenboard1\n";

                #Logarithm (base 10) of area (km**2) number 2 where
                #earthquake was felt  exceeding a given intensity.
                $Logararea2 = substr($linea,64,5);
                #print "$Logararea2\n";

                #Intensity boardering the area number 2.
                $Intenboard2 = substr($linea,69,2);
                #print "$Intenboard2\n";

                #Quality rank of the report (A, B, C, D)
                $Qualityrank = substr($linea,72,1);
                #print "$Qualityrank\n";

                #Reporting  agency
                $Reportagency = substr($linea,73,3);
                #print "$Reportagency\n";

        }
        if ($indica eq $row_3){

                #print "$linea\n";
                if ($comments == 1){
                      #Comments Text concatenado
                      $text = $text . substr($linea,1,78);
                      #print "$text";

                }else{
                      #Comments Text
                      $text = substr($linea,1,78);
                      #print "$text";
                      $comments = 1;
                }
        } #fin $row_3

        if ($indica ne $row_3){
             $comment = 0;
        }
        if ($indica eq $row_4){
                #print "$linea\n";

                #Station Name
                $Station = substr($linea,1,5);
                #print "Station";

                #Instrument Type S = SP, I = IP, L = LP etc
                $Instype = substr($linea,7,1);
                #print "$Instype";

                #Component Z, N, E
                $Component = substr($linea,8,1);
                #print "$Component";

                #Quality Indicator I, E, etc
                $QualityIndi= substr($linea,10,1);
                #print "$QualityIndi";

                #Phase ID PN, PG, LG, P, S, etc. **
                $PhaseID = substr($linea,11,4);
                #print "$PhaseID";

                #Weighting Indicator (1-4) 0 = full weight (as in HYPO)
                $WeightIndi = substr($linea,15,1);
                #print "$WeightIndi";

                #Free or flag A to indicate automartic pick, removed when rpicking
                $flagA = substr($linea,16,1);
                #print "$flagA";

                #First Motion  C, D
                $FirstMotion = substr($linea,17,1);
                #print "$FirstMotion";

                #Hour
                $Hour = substr($linea,19,2);
                #print "$Hour";

                #Minutes
                $Minutes = substr($linea,21,2);
                #print "$Minutes";

                #Seconds
                $Seconds = substr($linea,23,6);
                #print "$Seconds";

                #Duration (to noise)  Seconds
                $Duration = substr($linea,30,3);
                #print "$Duration";

                # Amplitude (Zero-Peak) Nanometers
                $Amplitude = substr($linea,34,6);
                #print "$Amplitude";

                #Period
                $Period = substr($linea,42,4);
                #print "$Period";

                #Direction of Approach Degrees
                $Direction = substr($linea,47 ,5);
                #print "$Direction";

                #Phase Velocity Km/second
                $PhaseVelocity = substr($linea,53,3);
                #print "$PhaseVelocity";

                #Angle of incidence (was Signal to noise ratio before version 8.0)
                $Angleincid = substr($linea,57,4);
                #print "$Angleincid";

                #Azimuth residual
                $Azimuthresi = substr($linea,61,3);
                #print "$Azimuthresi";

                #Travel time residual
                $timeresid = substr($linea,64,4);
                #print "$timeresid";

                #Weight
                $Weight = substr($linea,69,2);
                #print "$Weight";

                #Epicentral distance(km
                $Epicentral = substr($linea,71,5);
                #print "$Epicentral";

                #Azimuth at source
                $Azimuthsource = substr($linea,77,3);
                #print "$Azimuthsource";


        }
        if ($indica eq $row_5){

                #print "$linea\n";
                if ($commentserror == 1){
                      #Comments Error
                      $errortext = $errortext . substr($linea,1,78);
                      #print "$errortext\n";

                }else{
                      #Comments Text
                      $errortext = substr($linea,1,78);
                      #print "$errortext\n";
                      $commentserror = 1;
                }

        }

        if ($indica ne $row_5){
             $commenterror = 0;
        }

        if ($indica eq $row_6){

                #Name(s) of tracedata file
                $tracedata = substr($linea,1,78);
                #print "$tracedata";

        }
        if ($indica eq $row_F){

                #Strike, dip and rake, Aki convention
                $Strike = substr($linea,1,30);
                #print "$Strike";

                #Number of bad polarities
                $badpolarit = substr($linea,31,6);
                #print "$badpolarit";

                #Method or source of solution, seisan mames INVRAD or FOCMEC
                $source = substr($linea,71,6);
                #print "$source";

                #Quality of solution, A (best), B C or D (worst), added manually
                $Qualitysol = substr($linea,78,1);
                #print "$Qualitysol";

                #Remain in file and can be plotted
                $Remain = substr($linea,79,1);
                #print "$Remain";


        }

        if ($indica eq $row_E){

                #Gap
                $Gap = substr($linea,5,4);
                $Gap=~s/\s//g;
                if ($Gap eq ""){
                     $Gap="NULL";
                }
                #print "$Gap";

                #Origin time error
                $timeerror = substr($linea,15,6);
                #chop($timeerror);
                $timeerror=~s/\s//g;
                if ($timeerror eq ""){
                     $timeerror="NULL";
                }
                #print "Error time:$timeerror";

                #Latitude (y) error
                $laterror = substr($linea,24,6);
                $laterror=~s/\s//g;
                if ($laterror eq ""){
                     $laterror="NULL";
                }
                #print "$laterror";

                #Longitude (x) error (km)
                $lonerror = substr($linea,32,6);
                $lonerror=~s/\s//g;
                if ($lonerror eq ""){
                     $lonerror="NULL";
                }
                #print "$lonerror";

                #Depth (z) error (km)
                $Deptherror = substr($linea,38,6);
                $Deptherror=~s/\s//g;
                if ($Deptherror eq ""){
                     $Deptherror="NULL";
                }
                #print "$Deptherror";

                #Covariance (x,y) km*km
                $Covariancexy = substr($linea,43,12);
                $Gap=~s/\s//g;
                if ($Gap eq ""){
                     $Gap="NULL";
                }
                #print "$Covariancexy";

                #Covarience (x,z) km*km
                $Covariancexz = substr($linea,55,12);
                $Covariancexz=~s/\s//g;
                if ($Covariancexz eq ""){
                     $Covariancexz="NULL";
                }
                #print "$Covariancexz";

                #Covariance (y,z) km*km
                $Covarianceyz = substr($linea,67,12);
                $Covarianceyz=~s/\s//g;
                if ($Covarianceyz eq ""){
                     $Covarianceyz="NULL";
                }
                #print "$Covarianceyz";


        }



          if ($indica eq $row_I){

                $actiond = substr($linea,8,3);


                    if (($actiond eq "UPD") || ($actiond eq "UP ")){
                         #La primera bandera indica que el archivo
                        #a sido updateado por lo tanto solo falta verificar las
                        #otras banderas para poder insertar un evento nuevo
                        $flag1="1";

                        #Verificar si existe un Operater code
                             $Operador = substr($linea,30,4);

                             if (length ($Operador) > 0){
                         #Segunda bandera verificada
                         $flag2=1;
                         #print "$Operador\n";
                         #Last action done, so far defined SPL: Split
                         #REG: Register
                         #ARG: AUTO Register, AUTOREG
                         #UPD: Update
                         #UP : Update only from EEV
                         #REE: Register from EEV
                         #DUB: Duplicated event
                         #NEW: New event
                         $actiondone = substr($linea,8,3);
                         #print "$actiondone";

                         #Date and time of last action
                         $Dateaction = substr($linea,12,14);
                         #print "$Dateaction";

                         #Operater code
                         $Operatercode = substr($linea,30,4);
                         #print "$Operatercode";

                         #Status flags, not yet defined
                         $Statusflags = substr($linea,42,14);
                         #print "$Statusflags";

                         #ID, year to second
                         $IDyearsecond = substr($linea,60,14);
                         #print "$IDyearsecond";

                         #If d, this indicate that a new file id had to be created which was
                         #one or more seconds different from an existing ID to avoid overwrite.
                         $idd = substr($linea,74,1);
                         #print "Identificador: $idd";

                         #Indicate if ID is locked. Blank means not locked, L means locked.
                         $locked = substr($linea,75,1);
                         #print "$locked";

                         }else{ #fin del if que verifica que el operador existe
                                $flag2="0";
                         }
                        }else{ #fin del if que verifica que ha sido actualizado
                                $flag1="0";
                        }

          }

        if ($indica eq $row_H){

                # High accuracy hypoenter line

                #Seconds, f6.3
                $Secondsh = substr($linea,16,1);
                #print "$Secondsh";

                #Latitude, f9.5
                $Latitudeh = substr($linea,23,9);
                #print "$Latitudeh";

                #Longitude, f10.5
                $Longitudeh = substr($linea,33,11);
                #print "$Longitudeh";

                #Depth, f8.3
                $Depthh = substr($linea,44,8);
                #print "$Depthh";

                #RMS, f6.3
                $RMSh = substr($linea,53,9);
                #print "$RMSh";

        }
        #----------------------------------
        #Debido a que realizo comparaciones
        #con la agency antes de insert read
        #he asignado sus valores antes
        #----------------------------------
        #Magnitudes
        #El evento, $idevent por ejemplo: 00010775

        #La agencia $idagency_pris si el UDO contenida el la variable
        #$maga1 asignar CSUDO
        #Seleccionando el tipo de Estación
        if ($maga1 eq "UDO"){

                $idagency_pris = "CSUDO";
                $idstation = "00000";
                $idagency_dirs= "CSUDO";

        }else{

                $idagency_dirs= $maga1;
                $idagency_pris = $maga1;
                $idstation = $maga1;

        }

        #Buscando el tipo de Magnitud
        if ($type1 eq "L"){

                  $tipo= "ML";

        }elsif ($type1 eq "C"){

                  $tipo= "MD";

        }elsif ($type1 eq "B"){

                  $tipo= "mb";

        }elsif ($type1 eq "S"){

                  $tipo= "Ms";

        }

        #Insertar los valores en la tabla locations

        # Si el evento tiene latitud, longitud, profundidad y tiempo origen,
        # dicho evento tiene loctype= 4 (de completo)sino loctype=t (incompleto)
        if (($lat ne "") && ($lon ne "") && ($depth ne "") && ($hora ne "")) {
                      $loctype= "4";
        }else{
                      $loctype= "t";
        }

        #locdatetime almacenará el tiempo origen
        $locdatetime= "$anio" . "-" . "$mes" . "-" . "$dia" . " " . "$hora" . ":" . "$minuto" . ":" . "$seg";

        #Funcion que nos indica la cantidad de magnitudes reportadas
        if (length($mag1)>0) {
             $nummagns=1;
        }elsif (length($mag2)>0) {
             $nummagns=2;
        }elsif (length($mag3)>0) {
             $nummagns=3;
        }else{
             $nummagns=0;
        }
        #Funcion que se encarga de colocar null al comentario
        #si no existe en el archivo seisan
        if (!($text=~ /[A-Za-z0-9]/)) {
             $text=~s/\s//g;
             if ($text eq ""){
              $text="NULL";
             }
        }


        #----------------------------
        #Numero de fases de un evento
        #----------------------------
        $numphases=0;
        if ($indica eq $row_7){
              $here = 1;

        }else{
              if ($here == 1){
                   #print "$indica";

                $numphases++;
                #STAT
                $STAT = substr($linea,1,5);
                $STAT=~s/\s//g;
                if ($STAT eq ""){
                     $STAT="NULL";
                }
                #print "$STAT";

                #SP
                $SP = substr($linea,6,2);
                $SP=~s/\s//g;
                if ($SP eq ""){
                     $SP="NULL";
                }
                #print "$SP";

                #I
                $I = substr($linea,9,1);
                $I=~s/\s//g;
                if ($I eq ""){
                     $I="NULL";
                }
                #print "$I";

                #P
                $P = substr($linea,10,1);
                $P=~s/\s//g;
                if ($P eq ""){
                     $P="NULL";
                }
                #print "$P";

                #H
                $H = substr($linea,11,1);
                $H=~s/\s//g;
                if ($H eq ""){
                     $H="NULL";
                }
                #print "$H";

                #A
                $A = substr($linea,12,1);
                $A=~s/\s//g;
                if ($A eq ""){
                     $A="NULL";
                }
                #print "$A";
                #S
                $S = substr($linea,13,1);
                $S=~s/\s//g;
                if ($S eq ""){
                     $S="NULL";
                }
                #print "$S";

                #W
                $W = substr($linea,14,1);
                $W=~s/\s//g;
                if ($W eq ""){
                     $W="NULL";
                }
                #print "$W";

                #D
                $D = substr($linea,16,1);
                $D=~s/\s//g;
                if ($D eq ""){
                     $D="NULL";
                }
                #print "$D";

                #HR
                $HR = substr($linea,18,2);
                $HR=~s/\s//g;
                if ($HR eq ""){
                     $HR="";
                }
                #print "$HR";

                #MM
                $MM = substr($linea,20,2);
                $MM=~s/\s//g;
                if ($MM eq ""){
                     $MM="";
                }
                #print "$MM"
                #SECON
                $SECON = substr($linea,23,2);
                $SECON=~s/\s//g;
                if ($SECON eq ""){
                     $SECON="";
                }
                #print "$SECON";

                #DECISECON
                $DECISECON = substr($linea,25,3);
                $DECISECON=~s/\s//g;
                if ($DECISECON eq ""){
                     $DECISECON=0;
                }else{
                      $DECISECON="0".$DECISECON;
                }
                #print "$DECISECON";

                #locdatetime almacenará el tiempo origen
                $locdatetime_estaciones= "$anio" . "-" . "$mes" . "-" . "$dia" . " " . "$HR" . ":" . "$MM" . ":" . "$SECON";
                #CODA
                $CODA = substr($linea,29,4);
                $CODA=~s/\s//g;
                if ($CODA eq ""){
                     $CODA="NULL";
                }
                #print "$CODA";

                #AMPLIT
                $AMPLIT = substr($linea,34,6);
                $AMPLIT=~s/\s//g;
                if ($AMPLIT eq ""){
                     $AMPLIT="NULL";
                }
                #print "$AMPLIT";

                #PERI
                $PERI = substr($linea,41,4);
                $PERI=~s/\s//g;
                if ($PERI eq ""){
                     $PERI="NULL";
                }
                #print "PERIODO $PERI";

                #AZIMU
                $AZIMU = substr($linea,46,5);
                $AZIMU=~s/\s//g;
                if ($AZIMU eq ""){
                     $AZIMU="NULL";
                }
                #print "$AZIMU";

                #VELO
                $VELO = substr($linea,52,4);
                $VELO=~s/\s//g;
                if ($VELO eq ""){
                     $VELO="NULL";
                }
                #print "$VELO";

                #SNR
                $SNR = substr($linea,57,3);
                $SNR=~s/\s//g;
                if ($SNR eq ""){
                     $SNR="NULL";
                }
                #print "$SNR";

                #AR  : Azimuth residual when using azimuth information in locations
                $AR = substr($linea,61,2);
                $AR=~s/\s//g;
                if ($AR eq ""){
                     $AR="NULL";
                }
                #print "$AR";

                #TRES: Travel time residual
                $TRES = substr($linea,63,5);
                $TRES=~s/\s//g;
                if ($TRES eq ""){
                     $TRES="NULL";
                }
                #print " $TRES";

                #W   : Actual weight used for location ( inc. e.g. distance weight)
                $W = substr($linea,68,2);
                $W=~s/\s//g;
                if ($W eq ""){
                     $W="NULL";
                }
                #print "$W";

                #DIS : Epicentral distance in kms
                $DIS = substr($linea,72,3);
                $DIS=~s/\s//g;
                if ($DIS eq ""){
                     $DIS="NULL";
                }
                #print "$DIS";

                #CAZ : Azimuth from event to station
                $CAZ = substr($linea,76,3);
                $CAZ=~s/\s//g;
                if ($CAZ eq ""){
                     $CAZ="NULL";
                }
                #print "$CAZ";

                #----------------------------------
                #Insertando los valores en readings
                #----------------------------------
#        print "El tipo: $tipo agency es: $idagency_pris\n";
        if ($flag1 eq "1"){
                if ($flag2 eq "1"){
                  if ($flag3 eq "1"){
                        if ($idagency_pris ne "NULL"){
                          if ($STAT ne "NULL"){
                                     if ($P ne "NULL"){

                                #----------------------------------
                                #Modificar los valores en readings
                                #----------------------------------
                                #print "\n";print "UPDATE readings SET idstation='$STAT',idphase='$P',quality='$I',component='$SP', alterid='$IDyearsecond',arrivdatetime='$locdatetime_estaciones',secondsfract=$DECISECON,timepreciss=2,tresidual=$TRES,amplitude=$AMPLIT,period=$PERI,weight='$W' WHERE (idevent='$idupdatevent' AND idstation='$STAT' AND idphase='$P' AND quality='$I' AND component='$SP');";

                                $update_readings = "UPDATE readings SET idstation='$STAT',idphase='$P',quality='$I',component='$SP', alterid='$IDyearsecond',arrivdatetime='$locdatetime_estaciones',secondsfract=$DECISECON,timepreciss=2,tresidual=$TRES,amplitude=$AMPLIT,period=$PERI,weight='$W' WHERE (idevent='$idupdatevent' AND idstation='$STAT' AND idphase='$P' AND quality='$I' AND component='$SP');";

                                my $out_upd_readings = $dbh->prepare($update_readings) || die "Fallo al preparar la consulta: $DBI::errstr\n";

                                $out_upd_readings->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";


                }

                  if ($sta_values ne $STAT){

                        #print "UPDATE computed_values SET idstation='$STAT',alterid='$IDyearsecond',epicdist=$DIS,azimuth=$CAZ,ain=$AZIMU,polarity='$D' WHERE (idevent='$idupdatevent' AND idstation='$STAT');\n";

                      $update_computed_values = "UPDATE computed_values SET idstation='$STAT',alterid='$IDyearsecond',epicdist=$DIS,azimuth=$CAZ,ain=$AZIMU,polarity='$D' WHERE (idevent='$idupdatevent' AND idstation='$STAT');";

                      my $out_upd_computed_values = $dbh->prepare($update_computed_values) || die "Fallo al preparar la consulta: $DBI::errstr\n";

                      $out_upd_computed_values->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";


                           }
                    $sta_values = $STAT;
                   }
                  }
                 }
                }
               }
              }
             }

        #------------------------------------------------------
        #A continuación se elaboran las sentencia SQL, las cua-
        #les nos permiten insertar en la bd siiss.
        #------------------------------------------------------

        #print "El tipo: $tipo agency es: $idagency_pris\n";
        if ($flag1 eq "1"){
          if ($flag2 eq "1"){
            if ($flag3 eq "1"){
              if ($idagency_pris ne "NULL"){
                if ($tipo ne "NULL"){
                  if ($flagelm eq "1"){
                        #--------------------------------------------------------
                        #A continuacion bandera que me indica que se ha insertado
                        #en las siguientes tablas
                        #--------------------------------------------------------
                        $flagelm = "0";
#                            print "La primera bandera $flag1\n";
#                            print "La segunda bandera $flag2\n";
#                            print "La tercera bandera $flag3\n";

                        #---------------------------
                        #Modificar valores en events
                        #---------------------------
                         print "\n";
                         print "UPDATE events SET idevent='$idupdatevent',alterid='$IDyearsecond',numlocations=1,nummagns=$nummagns,numstations=$numstations,numsignals=0,numphases=$numphases,nummechs=0,namefile='$archList[$a]',modifyfile='$fechafile' WHERE idevent='$idupdatevent';\n";

                         $update_events ="UPDATE events SET alterid='$IDyearsecond',numlocations=1,nummagns=$nummagns,numstations=$numstations,numsignals=0,numphases=$numphases,nummechs=0,namefile='$archList[$a]',modifyfile='$fechafile' WHERE idevent='$idupdatevent';";

                         my $out_upd_events = $dbh->prepare($update_events) || die "Fallo al preparar la consulta: $DBI::errstr\n";

                         $out_upd_events->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

                         #print "$locdatetime\n";


                        #print "UPDATE magnitudes SET idevent='$idupdatevent',idagency_pris='$idagency_pris',magnitype='$tipo',idstation='$idstation',idagency_dirs='$idagency_dirs',alterid='$IDyearsecond',magnivalue=$mag1,stdmagerr=0,numstations=$numstations WHERE (idevent='$idupdatevent' AND idagency_pris='$idagency_pris' AND magnitype='$tipo' AND idstation='$idstation');\n";

                        #-------------------------------
                        #Modificar valores en magnitudes
                        #-------------------------------

                        $update_magnitudes = "UPDATE magnitudes SET idagency_pris='$idagency_pris',magnitype='$tipo',idstation='$idstation',idagency_dirs='$idagency_dirs',alterid='$IDyearsecond',magnivalue=$mag1,stdmagerr=0,numstations=$numstations WHERE (idevent='$idupdatevent' AND idagency_pris='$idagency_pris' AND magnitype='$tipo' AND idstation='$idstation');";

                        my $out_upd_magnitudes = $dbh->prepare($update_magnitudes) || die "Fallo al preparar la consulta: $DBI::errstr\n";

                        $out_upd_magnitudes->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

                        #print "\n";

                        #print "UPDATE locations SET idevent='$idupdatevent',idagency_pris='$idagency_pris',idagency_dirs='$idagency_dirs',alterid=$IDyearsecond,infotype=I,loctype=$loctype,locdatetime=$locdatetime,secondsfract=$deciseg,timepreciss=1,errtime=$timeerror,lat=$lat,latpreciss=4,errlat=$laterror,lon=$lon,lonpreciss=4,errlon=$lonerror,depth=$depth,depthpreciss=1,errdepth=$Deptherror,gap=$Gap,rms=$rms,software='SEISAN',comments='$text' WHERE (idevent='$idupdatevent' AND idagency_pris='$idagency_pris');\n";

                        $text = substr($text,4);
                        $update_locations = "UPDATE locations SET idagency_pris='$idagency_pris',idagency_dirs='$idagency_dirs',alterid='$IDyearsecond',infotype='I',loctype='$loctype',locdatetime='$locdatetime',secondsfract=$deciseg,timepreciss=1,errtime=$timeerror,lat=$lat,latpreciss=4,errlat=$laterror,lon=$lon,lonpreciss=4,errlon=$lonerror,depth=$depth,depthpreciss=1,errdepth=$Deptherror,gap=$Gap,rms=$rms,software='SEISAN',comments='$text' WHERE (idevent='$idupdatevent' AND idagency_pris='$idagency_pris');";

                        my $out_upd_locations = $dbh->prepare($update_locations) || die "Fallo al preparar la consulta: $DBI::errstr\n";

                        $out_upd_locations->execute || die "No puedo ejecutar la consulta: $DBI::errstr\n";

                     } #fin del if $flagelm
                    }
                   }
                  } #fin de la flag3 representa la latitud
                } #fin de la flag2 representada el operador
              } #fin de la bandera1 q representa if que pregunta si ha sido update


   } #Fin de Mientras
                              $flag3="0";
                        $flag3="0";
                              $flag3="0";
                        $flagelm = "1";
                        $flagrow_1="1";


} #Fin de la funcion update
