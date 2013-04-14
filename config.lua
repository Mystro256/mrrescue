default_config = {
	scale = 3,
	vsync = true,
	sfx_volume = 1.0,
	music_volume = 0.5,
	joystick = 1,
	keys = {
			up = "up", down = "down", left = "left", right = "right", jump = "s", shoot = "d", action = "a"
	},
	joykeys = {
		jump = 3, shoot = 4, action = 2
	}
}

keynames = {"up","down","left","right","jump","shoot","action"}
joykeynames = {"jump","shoot","action"}

highscores = { {}, {}, {} }

stats = { 0, 0, 0, 0, 0, 0 }

stats_interval = {
	{ 200, 600, 1800 },
	{ 50000, 100000, 300000 },
	{ 3000, 7000, 20000 },
	{ 60, 120, 300 },
	{ 15000, 30500, 80000 },
	{ 50, 100, 400 }
}

stats_names = {
	"FIRES EXTINGUISHED", -- 1
	"WATER USED",         -- 2
	"DISTANCE MOVED",     -- 3
	"PEOPLE RESCUED",     -- 4
	"PROPERTY DAMAGE",    -- 5
	"FLOORS SCALED"       -- 6
}

stats_units = { nil, " LITERS", " METERS", nil, " $", nil }

keystate = {
	up = false, down = false, left = false, right = false,
	jump = false, shoot = false, action = false,
	oldaxis1 = 0, oldaxis2 = 0
}

function loadConfig()
	-- Read default settings first
	config = {}
	for i,v in pairs(default_config) do
		if type(v) == "table" then
			config[i] = {}
			for j,w in pairs(v) do
				config[i][j] = w
			end
		else
			config[i] = v
		end
	end
	if love.filesystem.exists("settings") then
		local data = love.filesystem.read("settings")
		local file = TSerial.unpack(data)
		for i,v in pairs(file) do
			config[i] = v
		end
	end

	-- Select first open joystick if current is not open
	if love.joystick.isOpen(config.joystick) == false then
		config.joystick = 1
		nextJoystick()
	end
end

function loadHighscores()
	if love.filesystem.exists("highscores") then
		local data = love.filesystem.read("highscores")
		local file = TSerial.unpack(data)
		for i=1,3 do
			if file[i] then
				highscores[i] = file[i]
			end
		end
	end
end

function loadStats()
	if love.filesystem.exists("stats") then
		local data = love.filesystem.read("stats")
		stats = TSerial.unpack(data)
	end
end

function saveConfig()
	local data = TSerial.pack(config)
	love.filesystem.write("settings", data)
end

function saveHighscores()
	local data = TSerial.pack(highscores)
	love.filesystem.write("highscores", data)
end

function saveStats()
	local data = TSerial.pack(stats)
	love.filesystem.write("stats", data)
end

function setMode()
	love.graphics.setMode(WIDTH*config.scale, HEIGHT*config.scale, false, config.vsync)
end

function toggleVSync()
	config.vsync = not config.vsync
	setMode()
end

function defaultKeys()
	for i,v in pairs(default_config.keys) do
		config.keys[i] = v
	end
end

function defaultJoyKeys()
	for i,v in pairs(default_config.joykeys) do
		config.joykeys[i] = v
	end
end

function nextJoystick()
	for i=0,14 do
		local pos = (config.joystick+i)%16+1
		if love.joystick.isOpen(pos) then
			config.joystick = pos
			break
		end
	end
end
