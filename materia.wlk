class Materia{
    var property _requisitos_     // Requisitos para anotarse en la materia.
    const cupo = 10                     // Cupo para la inscripción.
    const property inscriptos = #{}     // Estudiantes inscriptos a la materia.
    const property enListaDeEspera = [] // Estudiantes en lista de espera.
    const creditos
    const anio

    // Inscribe al "estudiante" dado en caso de que haya cupo para hacerlo
    // caso contrario lo ingresa en la lista de espera.
    method inscribirA(estudiante){
        if(self.hayCupo()){
            inscriptos.add(estudiante)
        } else {
            enListaDeEspera.add(estudiante)
        }
    }

    method apruebaRequisito(estudiante){
        return _requisitos_.apruebaRequisito(self, estudiante)
    }

    // Indica si hay cupo en la materia.
    method hayCupo() = self.cupo() > 0
    
    // Describe la cantidad de cupos disponibles.
    method cupo() = cupo-inscriptos.size()

    // Baja la inscripción del "estudiante" dado de la materia.
    // En caso de que hayan estudiantes en la lista de espera
    // inscribe al primero de la lista.
    method bajarInscripcionDe(estudiante){
        inscriptos.remove(estudiante)
        if (!enListaDeEspera.isEmpty()){
            const primeroEnLista = enListaDeEspera.first()
            self.inscribirA(primeroEnLista)
            enListaDeEspera.remove(primeroEnLista)
        }
    }

    method creditos() = creditos
    method anio() = anio
}

