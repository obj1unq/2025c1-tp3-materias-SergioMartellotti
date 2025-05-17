import aprobado.*
object baseDeDatos{
    const aprobados=#{}

    // Retorna el Set de aprobados.
    method aprobados() = aprobados

    // Agrega, en caso de que no lo esté aún, aprobado.
    method registrarAprobado(aprobado){
        self.validarQueNoEsteAprobado(aprobado)
        aprobados.add(aprobado)
    }


    ////// Validaciones de que no esté ya aprobado //////

    // Valida que no hay un aprobado con la misma "materia" y 
    // mismo "estudiante" ya agregado al Set "aprobados".
    method validarQueNoEsteAprobado(aprobado){
        if (self.estaAprobado(aprobado)){
            self.error("El estudiante " + aprobado.estudiante() + " ya aprobó " + aprobado.materia() )
        }
    }

    // Indica si el "estudiante" figura con la "materia" aprobada en "aprobados".
    method estaAprobado(aprobado){
        return aprobados.filter({_aprobado => self.mismaMateriaYEstudiante(_aprobado, aprobado.materia(),aprobado.estudiante())}).size() == 1
    }

    // Indica si "aprobado" tiene la misma "materia" dada
    // y el mismo "estudiante" dado.
    method mismaMateriaYEstudiante(aprobado, materia,estudiante){
        return self.mismaMateria(aprobado, materia) and self.mismoEstudiante(aprobado, estudiante)
    }

    // Indica si "aprobado" tiene la misma "materia" dada.
    method mismaMateria(aprobado, materia){
        return aprobado.materia() == materia
    }

    // Indica si "aprobado" tiene el mismo "estudiante" dado.
    method mismoEstudiante(aprobado, estudiante){
        return aprobado.estudiante() == estudiante
    }


    /// Filtros para Estudiantes ///

    // Describe cuales son las materias aprobadas por el "estudiante" dado.
    method aprobadasPor_(estudiante){
        return aprobados.filter({aprobado => self.mismoEstudiante(aprobado, estudiante)})
    }

    // Describe las materias aprobadas por el "estudiante" dado.
    method listaDeAprobadasPor_(estudiante){
        const listaDeMaterias = []
        self.aprobadasPor_(estudiante).forEach({aprobado => listaDeMaterias.add(aprobado.materia())})
        return listaDeMaterias
    }
}