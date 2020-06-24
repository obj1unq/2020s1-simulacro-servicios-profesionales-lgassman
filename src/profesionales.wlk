object entreRios {
	
}
object santaFe{
	
}
object corrientes {
	
}

object asociacionLitoral {
	
	var recaudacion = 0
	
	method recaudar(importe) {
		recaudacion += recaudacion
	}
	
}

class Profesional {
	const property universidad
	method honorarios()
	method provincias()
	
	method acotado() {
		return self.provincias().size() <= 3
	}
	
	method puedeTrabajar(provincia) {
		return self.provincias().contains(provincia)
	}
	
	method cobrar(importe)
	
	method cobrarServicio() {
		self.cobrar(self.honorarios())
	}
	
	method esMasBaratoEn(provincia, honorarios) {
		return self.puedeTrabajar(provincia) 
    		   and self.honorarios() < honorarios
	}
}

class ProfesionalUniversitario inherits Profesional {
	
	override method provincias() {
		return #{universidad.provincia()}
	}
	
	override method honorarios() {
		return universidad.honorarios()
	}
	
	override method cobrar(importe) {
		universidad.recibir(importe/2)
	}
}

class ProfersionalAsociadoDelLitoral inherits Profesional {
	const property provincias = #{entreRios, santaFe, corrientes}
	
	override method  honorarios() {
		return 3000
	}
	override method cobrar(importe) {
		asociacionLitoral.recaudar(importe)
	}
}

class ProfersionalLibre inherits Profesional {
	var property provincias = #{}
	var property honorarios = 500
	
	var property dinero = 0
	
	override method cobrar(importe) {
		dinero += importe
	}
	
	method validarMonto(monto) {
		if(monto > dinero ) {
			self.error("El profesional " + self + "no tiene " + monto + "para transferir")
		}
		
	}
	method tranferir(monto, profesional) {
		profesional.cobrar(monto)
		dinero -= monto
	}
}


class Universidad {
	const property provincia
	var property honorarios = 500
	var donaciones = 0
	
	method recibir(donacion) {
		donaciones += donacion
	}
}

class Empresa {
	var property profesionales = #{}	
    var property honorarioReferencia = 400	
   
   	var property clientes = #{}
    
    method cantProfesionales(universidad) {
    	return profesionales.count({ profesional => profesional.universidad() == universidad })	
    }   
    
    method profesionalesCaros() {
    	return profesionales.filter({ profesional => profesional.honorarios() > honorarioReferencia })
    } 

    method formadoras() {
 		return profesionales.map( { profesional => profesional.universidad() } )   	
    }    
    
    method profesionalMasBarato() {
    	return profesionales.min( { profesional => profesional.honorarios() })	
    }
    
    method genteAcotada() {
    	return profesionales.all( { profesional => profesional.acotado() } )	
    }
    
    method puedeSatisfacer(solicitante) {
    	profesionales.any({profesional => solicitante.puedeSerAtendido(profesional)})
    }
    
    method validarServicio(cliente) {
    	if( ! self.puedeSatisfacer(cliente)) {
    		self.error("la empresa " + self + "No se puede satisfacer al cliente " + cliente)
    	}
    }
    //todo necesito el objeto servicio? parecería que no!
    method solicitarSercicio(cliente) {
    	self.validarServicio(cliente)
    	const profesional = profesionales.find({profesional => cliente.puedeSerAtendido(profesional)})	
    	profesional.cobrarServicio()
    	clientes.add(cliente)	
    }
    
    method cantidadClientes() {
    	return clientes.size()
    }
    
    method pocoAtractivo(profesional) {
    	profesional.provincias().all({provincia => self.cubiertaPorMenosDe(provincia, profesional.honorarios())})
    }
    
    method cubiertaPorMenosDe(provincia, honorarios) {
    	return self.profesionales().any( 
    		{ profesional => profesional.esMasBaratoEn(provincia, honorarios)}
    	)
    }
    
}

class Persona {
   var property provincia
   
   method puedeSerAtendido(profesional) {
   	 return profesional.puedeTrabajar(provincia)
   }	
}

class Institucion {
   var property universidadesReconocidas
   
	method puedeSerAtendido(profesional) {
		return universidadesReconocidas.any({universidad => profesional.universidad() == universidad})
	}   	
}
