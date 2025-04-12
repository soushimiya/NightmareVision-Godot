local bg = Sprite2D:new()
bg.position = Vector2(-600, -200)
bg.texture = Paths:image("stageback")
self:add_child(bg)

local stageFront = Sprite2D:new()
stageFront.position = Vector2(-600, 600)
stageFront.texture = Paths:image("stageFront")
self:add_child(stageFront)

local stageCurtains = Sprite2D:new()
stageCurtains.position = Vector2(-600, -300)
stageCurtains.texture = Paths:image("stagecurtains")
foreground:add_child(stageCurtains)