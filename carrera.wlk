class Carrera{
    const materias

    method materias() = materias

    // Indica si la "materia" dada pertenece la carrera.
    method contieneALa_(materia){
        return materias.contains(materia)
    }

    // Describe las materias del año dado.
    method materiasDe_Anio(anio){
        return self.materias().filter({materia => materia.anio()==anio})
    }
}