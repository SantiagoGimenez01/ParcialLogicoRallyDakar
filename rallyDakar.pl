% Nos entregan la siguiente base de conocimiento para poder trabajar, con los siguientes functores:
% ● auto(modelo)
% ● moto(anioDeFabricacion, suspensionesExtras)
% ● camion(items)
% ● cuatri(marca)

ganador(1997,peterhansel,moto(1995, 1)).
ganador(1998,peterhansel,moto(1998, 1)).
ganador(2010,sainz,auto(touareg)).
ganador(2010,depress,moto(2009, 2)).
ganador(2010,karibov,camion([vodka, mate])).
ganador(2010,patronelli,cuatri(yamaha)).
ganador(2011,principeCatar,auto(touareg)).
ganador(2011,coma,moto(2011, 2)).
ganador(2011,chagin,camion([repuestos, mate])).
ganador(2011,patronelli,cuatri(yamaha)).
ganador(2012,peterhansel,auto(countryman)).
ganador(2012,depress,moto(2011, 2)).
ganador(2012,deRooy,camion([vodka, bebidas])).
ganador(2012,patronelli,cuatri(yamaha)).
ganador(2013,peterhansel,auto(countryman)).
ganador(2013,depress,moto(2011, 2)).
ganador(2013,nikolaev,camion([vodka, bebidas])).
ganador(2013,patronelli,cuatri(yamaha)).
ganador(2014,coma,auto(countryman)).
ganador(2014,coma,moto(2013, 3)).
ganador(2014,karibov,camion([tanqueExtra])).
ganador(2014,casale,cuatri(yamaha)).
ganador(2015,principeCatar,auto(countryman)).
ganador(2015,coma,moto(2013, 2)).
ganador(2015,mardeev,camion([])).
ganador(2015,sonic,cuatri(yamaha)).
ganador(2016,peterhansel,auto(2008)).
ganador(2016,prince,moto(2016, 2)).
ganador(2016,deRooy,camion([vodka, mascota])).
ganador(2016,patronelli,cuatri(yamaha)).
ganador(2017,peterhansel,auto(3008)).
ganador(2017,sunderland,moto(2016, 4)).
ganador(2017,nikolaev,camion([ruedaExtra])).
ganador(2017,karyakin,cuatri(yamaha)).
ganador(2018,sainz,auto(3008)).
ganador(2018,walkner,moto(2018, 3)).
ganador(2018,nicolaev,camion([vodka, cama])).
ganador(2018,casale,cuatri(yamaha)).
ganador(2019,principeCatar,auto(hilux)).
ganador(2019,prince,moto(2018, 2)).
ganador(2019,nikolaev,camion([cama, mascota])).
ganador(2019,cavigliasso,cuatri(yamaha)).

pais(peterhansel,francia).
pais(sainz,espania).
pais(depress,francia).
pais(karibov,rusia).
pais(patronelli,argentina).
pais(principeCatar,catar).
pais(coma,espania).
pais(chagin,rusia).
pais(deRooy,holanda).
pais(nikolaev,rusia).
pais(casale,chile).
pais(mardeev,rusia).
pais(sonic,polonia).
pais(prince,australia).
pais(sunderland,reinoUnido).
pais(karyakin,rusia).
pais(walkner,austria).
pais(cavigliasso,argentina).

% Punto 1
% Agregar la siguiente información a la base de conocimientos:
% La marca peugeot tiene los modelos 2008 y 3008 de autos. 
% El countryman es modelo de auto marca mini, touareg es marca volkswagen, y hilux es de marca toyota.
% Teórico : ¿Qué debo agregar si quiero decir que el modelo buggy es marca mini pero el modelo dkr no lo es? Justificar conceptualmente.

esDe(auto(Modelo), peugeot):-
    Modelo = 2008.
esDe(auto(Modelo), peugeot):-
    Modelo = 3008.
esDe(auto(Modelo), mini):-
    Modelo = countryman.
esDe(auto(Modelo), volkswagen):-
    Modelo = touareg.
esDe(auto(Modelo), toyota):-
    Modelo = hilux.

% Si quiero decir que el modelo buggy es marca mini, deberia agregar un hecho donde diga que si el modelo de un auto es buggy, entonces relacione a 
% ese auto con la marca mini utilizando el predicado esDe/2, en cambio para decir que el modelo dkr no lo es, basta con no escribirlo en la base de
% conocimientos ya que como prolog trabaja con el concepto de universo cerrado, si algo no esta puesto en la base de conocimientos, entonces ya de por
% si es falso.

% Punto 2
% ganadorReincidente/1. Se cumple para aquel competidor que ganó en más de un año.
ganadorReincidente(Competidor):-
    ganador(UnAnio, Competidor, _),
    ganador(OtroAnio, Competidor, _),
    UnAnio \= OtroAnio.

% Punto 3
% inspiraA/2. Un conductor resulta inspirador para otro cuando ganó y el otro no, y también resulta inspirador cuando ganó algún año anterior al otro. 
% En cualquier caso, el inspirador debe ser del mismo país que el inspirado.
inspiraA(Conductor, Otro):-
    ganador(_, Conductor, _),
    not(ganador(_, Otro, _)),
    sonDelMismoPais(Conductor, Otro).
inspiraA(Conductor, Otro):-
    ganador(UnAnio, Conductor, _),
    ganador(OtroAnio, Conductor, _),
    UnAnio < OtroAnio,
    sonDelMismoPais(Conductor, Otro),
    Conductor \= Otro.

sonDelMismoPais(Uno, Otro):-
    pais(Uno, UnPais),
    pais(Otro, OtroPais),
    UnPais = OtroPais.

% Punto 4
% marcaDeLaFortuna/2. Relaciona un conductor con una marca si sólo ganó con vehículos de esa marca. 
% Si un conductor nunca ganó, no debe tener marca de la fortuna.
% ● La marca de un auto se obtiene a partir del modelo del auto.
% ● La marca de las motos dependen del año de fabricación: las fabricadas a partir del 2000 inclusive son ktm, las anteriores yamaha.
% ● La marca de los camiones es kamaz si lleva vodka, sino la marca es iveco.
% ● La marca del cuatri se indica en cada uno.
marcaDeLaFortuna(Conductor, Marca):-
    usoMarca(Conductor, Marca),
    forall(ganador(_, Conductor, Vehiculo), esDe(Vehiculo, Marca)).

usoMarca(Conductor, Marca):-
    ganador(_, Conductor, Vehiculo),
    esDe(Vehiculo, Marca).

esDe(moto(AnioFabricacion, _), ktm):-
    AnioFabricacion >= 2000.
esDe(moto(AnioFabricacion, _), yamaha):-
    AnioFabricacion < 2000.
esDe(camion(Items), kamaz):-
    member(vodka, Items).
esDe(camion(Items), iveco):-
    not(member(vodka, Items)).
esDe(cuatri(Marca), Marca).
    
% Punto 5
% heroePopular/1. Decimos que un corredor es un héroe popular cuando sirvió de inspiración a alguien, y además el año que salió ganador fue 
% el único de los conductores ganadores que no usó un vehículo caro.
% Un vehículo es caro cuando es de una marca cara (por ahora las caras son mini, toyota e iveco), o tiene al menos tres suspensiones extras.
% La cantidad de suspensiones extras que trae una moto se indica en cada una, los cuatri llevan siempre 4, y los otros vehículos ninguna.

% Punto 6
% Para terminar (En este punto no hace falta que todos los predicados sean inversibles, forma parte del análisis el determinar cuáles deberían serlo 
% y para qué parámetros, de forma de poder solucionar el problema planteado)
% Los corredores se enteraron del sistema que estamos desarrollando y quieren que los ayudemos a planificar su recorrido. Para armar sus estrategias, 
% nos pidieron un programa les permita separar el recorrido en tramos para decidir en qué ciudades frenar a hacer mantenimiento. 
% Para eso:
% a. Necesitamos un predicado que permita saber cuántos kilómetros existen entre dos locaciones distintas. 
% ¡Atención! Debe poder calcularse también entre locaciones que no pertenezcan a la misma etapa.
% Por ejemplo, entre sanRafael y copiapo hay 208+326+177+274 = 985 km

% b. Saber si un vehículo puede recorrer cierta distancia sin parar. Por ahora (posiblemente cambie) diremos que un vehículo caro puede recorrer 2000 km, 
% mientras que el resto solamente 1800 km. Además, los camiones pueden también recorrer una distancia máxima igual a la cantidad de cosas que lleva * 1000.
% Por ejemplo, una moto(1999,1) como no es cara, puede recorrer 1800 km pero no 1900 km.

% c. Los corredores quieren saber, dado un vehículo y un origen, cuál es el destino más lejano al que pueden llegar sin parar.
% Para la moto del punto anterior el destino más lejano desde marDelPlata es copiapo. Ya suman 1335 km, pero el con el próximo destino (antofagasta) se va
% a 1812 km, que es una distancia que no puede recorrer

etapa(marDelPlata,santaRosa,60).
etapa(santaRosa,sanRafael,290).
etapa(sanRafael,sanJuan,208).
etapa(sanJuan,chilecito,326).
etapa(chilecito,fiambala,177).
etapa(fiambala,copiapo,274).
etapa(copiapo,antofagasta,477).
etapa(antofagasta,iquique,557).
etapa(iquique,arica,377).
etapa(arica,arequipa,478).
etapa(arequipa,nazca,246).
etapa(nazca,pisco,276).
etapa(pisco,lima,29).

