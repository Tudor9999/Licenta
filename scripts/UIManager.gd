extends CanvasLayer
@onready var diamond_label = $DiamondLabel

func _ready():
	GameManager.diamonds_gained.connect(update_diamond_display)

func update_diamond_display(gained_diamonds):
	diamond_label.text = str(GameManager.diamonds)
