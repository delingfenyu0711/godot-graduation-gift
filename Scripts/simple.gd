# 这是一个注释，单行注释用#开头

# 继承自Node2D节点（Godot中所有脚本都需要继承一个节点类型）
extends Node2D

# 导出变量（可在编辑器中可视化编辑）
@export var speed: float = 200.0  # 移动速度
@export var max_health: int = 100  # 最大生命值

# 成员变量
var current_health: int = max_health
var is_alive: bool = true
var position_history: Array = []  # 数组类型

# 常量定义
const GRAVITY: float = 980.0
const DEFAULT_NAME: String = "Player"

# _ready()：节点就绪时调用（类似初始化）
func _ready():
	print("节点准备就绪！")
	print("初始位置: ", position)  # 内置变量，节点位置

	# 调用自定义函数
	greet_player(DEFAULT_NAME)

	# 连接信号（事件系统）
	$Timer.timeout.connect(_on_timer_timeout)  # 假设场景中有个Timer节点


# _process(delta)：每帧调用（处理逻辑）
func _process(delta: float):
	if not is_alive:
		return  # 提前退出函数

	# 处理输入
	handle_input(delta)

	# 记录位置历史
	position_history.append(position)
	if position_history.size() > 10:
		position_history.pop_front()  # 保持数组长度不超过10


# 处理输入的函数
func handle_input(delta: float):
	var direction: Vector2 = Vector2.ZERO  # 向量类型

	# 检测按键
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	# 标准化向量（避免斜向移动更快）
	if direction.length() > 0:
		direction = direction.normalized()

	# 移动节点
	position += direction * speed * delta


# 信号回调函数（定时器超时）
func _on_timer_timeout():
	print("定时器触发！当前位置历史: ", position_history)


# 自定义函数（带参数和返回值）
func take_damage(amount: int) -> bool:
	if not is_alive:
		return false

	current_health -= amount
	print("受到伤害: ", amount, " 剩余生命值: ", current_health)

	if current_health <= 0:
		current_health = 0
		is_alive = false
		print("角色已死亡")
		return false
	return true


# 带默认参数的函数
func greet_player(name: String = "Guest"):
	print("欢迎，", name, "！")


# 重写父类函数（_draw用于自定义绘制）
func _draw():
	# 绘制一个红色矩形表示生命值
	var health_bar_length: float = 100
	var health_ratio: float = current_health / max_health
	draw_rect(Rect2(-50, -60, health_bar_length * health_ratio, 10), Color.RED)