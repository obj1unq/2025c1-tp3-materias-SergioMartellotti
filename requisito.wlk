import estudiante.*
import carrera.*

class Requisito{
    var requisitos

    method apruebaRequisito(materia,estudiante)
}

class Correlativa inherits Requisito{
    
    // Indica si el "estudiante" dado tiene las materias como requisito
    // aprobadas.
    override method apruebaRequisito(materia, estudiante){
        return requisitos.all({requisito => estudiante.tieneAprobadaA_(requisito)})
    }
}

class Credito inherits Requisito{

    // Indica si el "estudiante" dado tiene los creditos necesarios.
    override method apruebaRequisito(materia, estudiante){
        const carrerasDelEstudiante = estudiante.carreras().asList()
        const carreraDeLaMateria = carrerasDelEstudiante.filter({carrera => carrera.contieneALa_(materia)}).first()
        return requisitos <= self.sumaDeCreditos(carreraDeLaMateria, estudiante)
    }

    method sumaDeCreditos(carrera,estudiante){
        var suma = 0
        estudiante.materiasAprobadasDe_(carrera).forEach({materia => suma += materia.creditos()})
        return suma
    }
}

class Anio inherits Requisito{
    method requisitos(_requisitos){
        requisitos = _requisitos
    }
    override method apruebaRequisito(materia, estudiante){
        const materiasAprobadas = estudiante.listaDeAprobadas()
        return requisitos.all({materia => materiasAprobadas.contains(materia)})
    }
}

class Nada inherits Requisito{
    
    override method apruebaRequisito(materia, estudiante){
        return true
    }
}