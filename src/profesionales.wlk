
object entreRios {
	
}

object santaFe{
	
}

object corrientes {
	
}

object asociacionLitoral {

	var property recaudacion
	
	method recaudar(monto) {
		recaudacion += monto	
	}	
}

class Profesional {
	const property universidad
	method honorarios()
	method provincias()
	method cobrar(monto)
	
	method esAcotado() {
		return self.provincias().size() <= 3 
	}
	
	method puedeTrabajar(_provincia) {
		return self.provincias().contains(_provincia)
	} 
	
	method estudio(_universidad) {
		return self.universidad() == _universidad
	}
	
	method cobrarServicio() {
		self.cobrar(self.honorarios())
	}
	
	method esMejor(provincia, candidato) {
		return self.puedeTrabajar(provincia) and self.honorarios() < candidato.honorarios()
	}
}

class Universidad {
	var property honorarios
	const property provincia
	
	var property donaciones
	
	method recibir(donacion) {
		donaciones += donacion
	}
}

class ProfesionalUniversitario inherits Profesional {
	
	override method provincias() {
		return #{self.universidad().provincia()}
	}
	
	override method honorarios() {
		return self.universidad().honorarios()
	}
	
	override method cobrar(monto) {
		universidad.recibir(monto / 2)
	}
	
}

class ProfesionalAsociadoLitoral inherits Profesional {
	const property provincias = #{entreRios, santaFe, corrientes}
		
	override method honorarios() {
		return 3000
	}
	
	override method cobrar(monto) {
		asociacionLitoral.recaudar(monto)		
	}	
}

class ProfesionalLibre inherits Profesional {
	var property provincias
	var property honorarios	
	var property dinero
   
    override method cobrar(monto) {
    	dinero += monto
    }	
    
    method validarMonto(monto) {
    	if(monto > dinero) {
    		self.error("El profesional " + self + "no tiene " + monto + " para transferir")
    	}	
    }
    
    method transferir(monto, profesional) {
    	self.validarMonto(monto)
    	profesional.cobrar(monto)
    	dinero -= monto	
    }
}

class Empresa {
    const property profesionales = #{}	
	var property honorarios
	const property clientes = #{}
	
	method cuantosEstudiaronEn(universidad) {
		return profesionales.count({profesional => profesional.universidad() == universidad})
	}
	
	method profesionalesCaros() {
		return profesionales.filter( { profesional => profesional.honorarios() > honorarios})
	}
	
	method universidadesFormadoras() {
		return profesionales.map({profesional => profesional.universidad()})
	}
	
	method profesionalMasBarato() {
		return profesionales.min({profesional => profesional.honorarios()})
	}
	
	method esAcotado() {
		return profesionales.all( {profesional => profesional.esAcotado()} )
	}
	
	method puedeSatisfacer(solicitante) {		
		return profesionales.any({profesional => solicitante.puedeSerAtendidoPor(profesional)})
	}	
	
	method validarServicio(solicitante) {
		if(not self.puedeSatisfacer(solicitante)) {
			self.error("La empresa " + self + " no puede brindar el servicio a " + solicitante )
		}		
	}
	
	method buscarProfesional(solicitante) {
		return profesionales.find({profesional => solicitante.puedeSerAtendidoPor(profesional)})
	}
	
 	method brindarServicio(solicitante) {
		self.validarServicio(solicitante)
		self.buscarProfesional(solicitante).cobrarServicio()
		clientes.add(solicitante)
	}
	
	method esPocoAtractivo(profesional) {
		return profesional.provincias().all({ provincia => self.hayProfesionalMejor(provincia, profesional) })
	}
	
	method hayProfesionalMejor(provincia, candidato) {
		return self.profesionales().any({profesionalContratado =>
									profesionalContratado.esMejor(provincia, candidato)  

		})
	}
	
	
}




class Persona {
	var provincia
	
	method puedeSerAtendidoPor(profesional) {
		return profesional.puedeTrabajar(provincia)
	}
}


class Institucion {
	const universidades 
	
	method puedeSerAtendidoPor(profesional) {
		return universidades.any({universidad => profesional.estudio(universidad)})
	}
	
}




























