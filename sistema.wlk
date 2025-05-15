import baseDeDatos.*
import estudiante.*
import carrera.*

object sistema {
    const datos = baseDeDatos

    // Describe la cantidad de materias aprobadas.
    method cantidadDeAprobadasPor(estudiante) = datos.aprobadasPor_(estudiante).size()
    
    // Describe el promedio de todas las materias aprobadas.
    method promedioNotasDe(estudiante){
        var sumaNotas = 0
        const materiasAprobadas = datos.aprobadasPor_(estudiante)
        materiasAprobadas.forEach({aprobada => sumaNotas += aprobada.getBasic("nota")})
        return sumaNotas / materiasAprobadas.size()
    }

    // Describe las materias aprobadas por el estudiante "estudiante".
    method listaDeAprobadasPor(estudiante){
        return datos.listaDeAprobadasPor_(estudiante)
    }

    // Indica si el "estudiante" tiene la "materia" aprobada.
    method tieneAprobadaA_(estudiante,materia){
        return self.listaDeAprobadasPor(estudiante).contains(materia)
    }

    // Describe todas las materias de las carreras a las que 
    // está inscripto el "estudiante".
    method materiasDeCarrerasDe_(estudiante){
        const materiasDeCarreras = []
        estudiante.carreras().forEach({carrera => materiasDeCarreras.add(carrera.materias())})
        return materiasDeCarreras.flatten()
    }



    /////  Inscripcion a materias /////

    // Inscribe al "estudiante" dado a la "materia" dada.
    method inscribirA_Al_(materia,estudiante){
        self.validacionesParaInscripcionDe(materia,estudiante)
        materia.inscribirA(estudiante)
    }

    // Realiza las validaciones necesarias para la correcta 
    // inscripción del "estudiante" dado a la "materia" dada.
    method validacionesParaInscripcionDe(materia,estudiante){
        self.validarMateriaDeCarrerasDe(materia, estudiante)
        self.validarQueNoEsteAprobadaPor(materia,estudiante)
        self.validadQueNoEsteAnotadoEn(materia,estudiante)
        self.validarCorrelativasParaAnotarseA(materia,estudiante)        
    }

    // Valida que la "materia" dada pertenezca a una de las carreras
    // que está cursando el "estudiante" dado.
    method validarMateriaDeCarrerasDe(materia,estudiante){
        if(! self.materiasDeCarrerasDe_(estudiante).contains(materia)){
            self.error("La materia no pertenece a las carreras que cursa el estudiante.")
        }
    }

    // Valida que la "materia" dada no esté aprobada por el "estudiante" dado.
    method validarQueNoEsteAprobadaPor(materia, estudiante){
        if (self.listaDeAprobadasPor(estudiante).contains(materia)){
            self.error("La materia ya fue aprobada por el estudiante")
        }
    }

    // Valida que el "estudiante" dado no esté inscripto a la "materia".
    method validadQueNoEsteAnotadoEn(materia, estudiante){
        if (materia.inscriptos().contains(estudiante)){
            self.error("El estudiante ya está anotado en la materia.")
        }    
    }

    // Valida que el "estudiante" dado tenga aprobadas todas las materias
    // correlativas para inscribirse en la "materia" dada.
    method validarCorrelativasParaAnotarseA(materia, estudiante){
        if (!self.tieneLosRequisitosAprobadosPara(materia,estudiante)){
            self.error("El estudiante no tiene las correlativas necesarios para inscribirse a la materia.")
        }
    }

    // Describe si el "estudiante" dado tiene todas las materias
    // correlativas de la "materia" dada.
    method tieneLosRequisitosAprobadosPara(materia, estudiante){
        return materia._requisitos_().all({requisito => self.tieneAprobadaA_(estudiante, requisito)})
    }

    // Da de baja al "estudiante" dado de la inscripción de la "materia" dada. 
    method bajaDeInscripcionDe(materia, estudiante){
        self.validarQueEsteAnotado(materia, estudiante)
        materia.bajarInscripcionDe(estudiante)
    }

    // Valida que el "estudiante" esté anotado en la "materia" dada.
    method validarQueEsteAnotado(materia, estudiante){
        if (!materia.inscriptos().contains(estudiante)){
            self.error("El estudiante no está anotado en la materia.")
        }    
    }


    ///// Resultados de Inscripciones /////

    //Describe los estudiantes inscriptos en la "materia" dada.
    method estudiantesInscriptosEn(materia){
        return materia.inscriptos()
    }

    //Describe los estudiantes en lista de espera en la "materia" dada.
    method estudiantesEnListaDeEsperaDe(materia){
        return materia.enListaDeEspera()
    }

    //Describe las materias en las que el "estudiante" está inscripto.
    method materiasEnLasQueEstaInscripto(estudiante){
        const todasLasMaterias = self.materiasDeCarrerasDe_(estudiante)
        return todasLasMaterias.filter({materia => materia.inscriptos().contains(estudiante)})
    }

    //Describe las materias en las que el "estudiante" está en lista de espera.
    method materiasEnLasQueEstaEnListaDeEspera(estudiante){
        const todasLasMaterias = self.materiasDeCarrerasDe_(estudiante)
        return todasLasMaterias.filter({materia => materia.enListaDeEspera().contains(estudiante)})
    }

    //Describe las materias a las que el "estudiante" puede anotarse.
    method materiasEnLasQueSePuedeAnotar(carrera, estudiante){
        self.validarInscripcionACarrera(carrera, estudiante)
        const todasLasMateriasDe = carrera.materias()
        return todasLasMateriasDe.filter({materia => self.validarCorrelativasParaAnotarseA(materia, estudiante)})
    }

    //Valida que el "estudiante" dado esté inscripto a la "carrera" dada.
    method validarInscripcionACarrera(carrera, estudiante){
        return estudiante.carreras().contains(carrera)
    }
}