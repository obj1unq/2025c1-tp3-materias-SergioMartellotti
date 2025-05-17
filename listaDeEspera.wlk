import sistema.*

class ListaDeEspera{
    const lista = []

    method size() = lista.size()
    method isEmpty() = lista.isEmpty()
    method contains(estudiante) = lista.contains(estudiante)

    method agregarALista(estudiante) {
        lista.add(estudiante)
    }
    
    method primeroDeLaLista()
    
    method eleminarEstudiante(estudiante){
        lista.remove(estudiante)
    }
}

class PorOrdenDeLlegada inherits ListaDeEspera{
 
    override method primeroDeLaLista(){
        return lista.first()
    }
}

class Elitista inherits ListaDeEspera{

    override method primeroDeLaLista(){
        return lista.maxIfEmpty({estudiante => sistema.promedioNotasDe(estudiante)}, {[]})
    }
}

class PorAvance inherits ListaDeEspera{
    
    override method primeroDeLaLista(){
        return lista.maxIfEmpty({estudiante => sistema.cantidadDeAprobadasPor(estudiante)}, {[]})
    }   
}