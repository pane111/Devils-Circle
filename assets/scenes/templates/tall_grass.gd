extends StaticBody2D

func on_slash():
	$Sprite2D.hide()
	$HitSound.play()
	$CollisionShape2D.set_deferred("disabled",true)
	$CPUParticles2D.emitting=true
	EffectManager.spawn_local_effect("hit",global_position,self)
	remove_from_group("slashable")
