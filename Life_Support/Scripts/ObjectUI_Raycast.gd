extends RayCast3D

@onready var text = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	text.set_text("")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding():
		print(get_collider().object.get_name())
		text.set_text(get_collider().get("name"))
