import materia.*
class Estudiante{
    var property carreras
    const property materiasAprobadas = []

    // Describe la cantidad de materias aprobadas.
    method cantidadDeAprobadas() = materiasAprobadas.size()

    // Describe el promedio de todas las materias aprobadas.
    method promedioNotas(){
        var sumaNotas = 0
        materiasAprobadas.forEach({aprobada => sumaNotas += aprobada.nota()})
        return sumaNotas / self.cantidadDeAprobadas()
    }

    // Describe las materias aprobadas.
    method listaDeAprobadas(){
        return materiasAprobadas.map({aprobada => aprobada.materia()})
    }

    method aprobarMateria(aprobado){
        self.validarQueNoEsteAprobada(aprobado.materia())
        materiasAprobadas.add(aprobado)
    }

    // Indica si la "materia" está aprobada.
    method tieneAprobadaA_(materia) = materiasAprobadas.any({aprobada => aprobada.esDeLa_(materia)})

    // Describe todas las materias de las carreras a las que está inscripto.
    method materiasDeCarreras(){
        const materiasDeCarreras = []
        carreras.forEach({carrera => materiasDeCarreras.add(carrera.materias())})
        return materiasDeCarreras.flatten()
    }

    /////  Inscripcion a materias /////

    // Inscribe a la "materia" dada.
    method inscribirA_(materia){
        self.validacionesParaInscripcionDe(materia)
        materia.inscribirA(self)
    }

    // Realiza las validaciones necesarias para la correcta 
    // inscripción a la "materia" dada.
    method validacionesParaInscripcionDe(materia){
        self.validarMateriaDeCarreras(materia)
        self.validarQueNoEsteAprobada(materia)
        self.validadQueNoEsteAnotadoEn(materia)
        self.validarRequisitosParaAnotarseA(materia)        
    }


    // Valida que la "materia" dada pertenezca a una de las carreras.
    method validarMateriaDeCarreras(materia){
        if(! self.materiasDeCarreras().contains(materia)){
            self.error("La materia no pertenece a las carreras que cursa el estudiante.")
        }
    }

    // Valida que la "materia" dada no esté aprobada por el "estudiante" dado.
    method validarQueNoEsteAprobada(materia){
        if (self.listaDeAprobadas().contains(materia)){
            self.error("La materia ya fue aprobada por el estudiante")
        }
    }

    // Valida que no esté inscripto a la "materia".
    method validadQueNoEsteAnotadoEn(materia){
        if (self.estaAnotadoA(materia)){
            self.error("El estudiante ya está anotado en la materia.")
        }
    }

    // Valida que tenga los requisitos para inscribirse en la "materia" dada.
    method validarRequisitosParaAnotarseA(materia){
        if (!self.tieneLosRequisitosAprobadosPara(materia)){
            self.error("El estudiante no tiene las correlativas necesarios para inscribirse a la materia.")
        }
    }

    // Describe si tiene todas las materias correlativas de la "materia" dada.
    method tieneLosRequisitosAprobadosPara(materia){
        return materia.apruebaRequisito(self)
    }

    // Da de baja de la inscripción de la "materia" dada. 
    method bajaDeInscripcionDe(materia){
        self.validarQueEsteAnotado(materia)
        materia.bajarInscripcionDe(self)
    }

    // Valida que esté anotado en la "materia" dada.
    method validarQueEsteAnotado(materia){
        if (!self.estaAnotadoA(materia)){
            self.error("El estudiante no está anotado en la materia.")
        }    
    }

    // Indica si está anotado a la materia dada.
    method estaAnotadoA(materia) = materia.tieneInscriptoA_(self)

    
    //Describe las materias en las que está inscripto.
    method materiasEnLasQueEstaInscripto(){
        const todasLasMaterias = self.materiasDeCarreras()
        return todasLasMaterias.filter({materia => materia.tieneInscriptoA_(self)})
    }

    //Describe las materias en las que está en lista de espera.
    method materiasEnLasQueEstaEnListaDeEspera(){
        const todasLasMaterias = self.materiasDeCarreras()
        return todasLasMaterias.filter({materia => materia.tieneEnEsperaA_(self)})
    }

    //Describe las materias a las que el "estudiante" puede anotarse.
    method materiasEnLasQueSePuedeAnotar(carrera){
        self.validarInscripcionACarrera(carrera)
        const todasLasMateriasDe = carrera.materias()
        return todasLasMateriasDe.filter({materia => !self.tieneAprobadaA_(materia) and materia.apruebaRequisito(self)})
    }

    //Valida que esté inscripto a la "carrera" dada.
    method validarInscripcionACarrera(carrera){
        if (! self.carreras().contains(carrera)){
            self.error("No está anotado a esta carrera.")
        }
    }

    // Describe las materias aprobadas de la "carrera" dada.
    method materiasAprobadasDe_(carrera){
        return materiasAprobadas.filter({materia => carrera.contieneALa_(materia)})
    }
}

class Aprobado{
    const materia
    const nota

    method materia() = materia
    method nota() = nota

    // Indica si la materia aprobada es la "materia" dada.
    method esDeLa_(_materia) = materia == _materia
}