extends Manager

# WARNING this implementation works only if a field never changes components while an object is inside it
# FIXME need to switch to a continuous check + timeout

signal repel_cargo
func _on_sth_entered(sth, other):
	var sth_entity = ECM.E(sth)
	var other_entity = ECM.E(other)
	
	if not sth_entity or not other_entity:
		return
		
	if sth_entity.has('Fluid') and other_entity.has('Thrusters'):
		var do_it = false
		if other_entity.has('Conqueror') and not(sth_entity.has('Conquerable') and sth_entity.get('Conquerable').get_species().species == other_entity.get('Conqueror').get_species().species):
			do_it = true
		elif other_entity.has('Owned') and not(sth_entity.has('Conquerable') and sth_entity.get('Conquerable').get_species().species == other_entity.get('Owned').get_owned_by().species):
			do_it = true
		if do_it:
			other_entity.get_node('Thrusters').add_hindrance()
			if sth is Cell:
				sth.flash()
		
	if sth_entity.has('Flow') and other_entity.could_have('Flowing'):
		other_entity.get_node('Flowing').set_flow(sth_entity.get_node('Flow'))
		other_entity.get_node('Flowing').enable()
		
	if sth_entity.has('CrownDropper') and other_entity.has('Cargo') and other_entity.get('Cargo').what is Crown:
		emit_signal('repel_cargo', other_entity.get_host())

	if sth_entity.has('Hill') and other_entity.could_have('Royal'):
		other_entity.get_node('Royal').enable()
		
func _on_sth_exited(sth, other):
	var sth_entity = ECM.E(sth)
	var other_entity = ECM.E(other)
	
	if not sth_entity or not other_entity:
		return
		
	if sth_entity.has('Fluid') and other_entity.could_have('Thrusters'):
		var do_it = false
		if other_entity.has('Conqueror') and not(sth_entity.has('Conquerable') and sth_entity.get('Conquerable').get_species().species == other_entity.get('Conqueror').get_species().species):
			do_it = true
		elif other_entity.has('Owned') and not(sth_entity.has('Conquerable') and sth_entity.get('Conquerable').get_species().species == other_entity.get('Owned').get_owned_by().species):
			do_it = true
		if do_it:
			other_entity.get_node('Thrusters').remove_hindrance()
		
	if sth_entity.has('Flow') and other_entity.has('Flowing'):
		other_entity.get_node('Flowing').disable()
		
	if sth_entity.has('Hill') and other_entity.has('Royal'):
		other_entity.get_node('Royal').disable()
		