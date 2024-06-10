extends CanvasLayer
@onready var diamond_label = $DiamondLabel

func _ready():
	GameManager.pause_menu = $PauseMenu
	GameManager.diamonds_gained.connect(update_diamond_display)

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		GameManager.pause_game()
		get_tree().paused = GameManager.paused

func update_diamond_display(gained_diamonds):
	diamond_label.text = str(GameManager.diamonds)

func _on_resume_pressed():
	GameManager.resume()

func _on_restart_pressed():
	GameManager.restart()

func _on_levels_pressed():
	GameManager.levels()

func _on_quit_pressed():
	GameManager.quit()
