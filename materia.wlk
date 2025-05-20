class Materia{
    var property _requisitos_     // Requisitos para anotarse en la materia.
    const cupo = 10                     // Cupo para la inscripción.
    const inscriptos = #{}     // Estudiantes inscriptos a la materia.
    const enListaDeEspera = []
    var property metodoDeOrdenamiento //property para test
    const creditos
    const anio


    method creditos() = creditos
    method anio() = anio
    // Indica si hay cupo en la materia.
    method hayCupo() = self.cupo() > 0
    
    // Describe la cantidad de cupos disponibles.
    method cupo() = cupo-inscriptos.size()

    // Inscribe al "estudiante" dado en caso de que haya cupo para hacerlo
    // caso contrario lo ingresa en la lista de espera.
    method inscribirA(estudiante){
        if(self.hayCupo()){
            inscriptos.add(estudiante)
        } else {
            enListaDeEspera.add(estudiante)
        }
    }

    // Indica si está inscripto el "estudiante" dado.
    method tieneInscriptoA_(estudiante) = inscriptos.contains(estudiante)

    //Describe los estudiantes inscriptos.
    method estudiantesInscriptos(){
        return inscriptos
    }

    // Indica si el "estudiante" dado aprueba los requisitos.
    method apruebaRequisito(estudiante){
        return _requisitos_.apruebaRequisito(self, estudiante) //ver
    }


    // Baja la inscripción del "estudiante" dado de la materia.
    // En caso de que hayan estudiantes en la lista de espera
    // inscribe al primero de la lista.
    method bajarInscripcionDe(estudiante){
        inscriptos.remove(estudiante)
        if (!enListaDeEspera.isEmpty()){
            const primeroDeLista = metodoDeOrdenamiento.primeroDeLaLista(enListaDeEspera)
            self.inscribirA(primeroDeLista)
            enListaDeEspera.remove(primeroDeLista)
        }
    }

    /////Lista de Espera /////

    //Describe los estudiantes en lista de espera en la "materia" dada.
    method estudiantesEnListaDeEsperaDe(){
        return enListaDeEspera
    }

    method agregarAListaDeEspera(estudiante) {
        enListaDeEspera.add(estudiante)
    }
       
    method eleminarEstudiante(estudiante){
        enListaDeEspera.remove(estudiante)
    }

    // Indica si está en lista de espera el "estudiante" dado.
    method tieneEnEsperaA_(estudiante) = enListaDeEspera.contains(estudiante)

}


// Objetos que modifican el orden de la Lista de Espera de la Materia.
object porOrdenDeLlegada{
 
    method primeroDeLaLista(lista){
        return lista.first()
    }
}

object elitista{

    method primeroDeLaLista(lista){
        return lista.maxIfEmpty({estudiante => estudiante.promedioNotas()}, {[]})
    }
}

object porAvance{
    
    method primeroDeLaLista(lista){
        return lista.maxIfEmpty({estudiante => estudiante.cantidadDeAprobadas()}, {[]})
    }
}

// 