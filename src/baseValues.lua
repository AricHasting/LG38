--Offset baseValues outside of main logic files for clarity
baseValues = {}
local lg = love.graphics

-- THESE FUNCTIONS ARE MEANT FOR RE-CALLING
-- DO NOT LOAD DRAWABLES! ONLY BASE VALUES
function baseValues:loadGame(args)
  debug = true
  gamestate = "game" -- state switcher
end

function baseValues:loadPlanets(args)
  -- planets table
  planet = {
    sun = {
      name = "Sun",
      quad = lg.newQuad(0, 0, 1024, 1024, planetsheet:getDimensions()), -- drawable crop
      scale = 0.7,
      r = 0,
      x = gameWidth+220,
      y = gameHeight-50,
      assoc_sats = {},
      assoc_moons = {},
      gravity = 0, --2000
	    targetRange = 0,
      yvel = 0,
      oy = 0,
      ring = false,
      color = {}
    },

    mercury = {
      name = "Mercury",
      quad = lg.newQuad(1025, 0, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.05,
      r = 0,
      x = 1600,
      y = 900,
      assoc_sats = {},
      assoc_moons = {},
      gravity = 0,
      targetRange = 0,
      selfOrbit = 0,
      yvel = -80,
      oy = 0,
      ring = false,
      color = {}
    },

    venus = {
      name = "Venus",
      quad = lg.newQuad(2050, 0, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.065,
      r = 0,
      x = 1641,
      y = 525,
      assoc_sats = {},
      assoc_moons = {},
      gravity = 0,
      targetRange = 0,
      selfOrbit = 0,
      yvel = -100,
      oy = 0,
      ring = false,
      color = {}
    },

    earth = {
      name = "Earth",
      quad = lg.newQuad(0, 1025, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.078,
      r = 0,
      x = 1350,
      y = 781,
      assoc_sats = {},
      assoc_moons = {},
      gravity = 0,
      targetRange = 0,
      selfOrbit = 0,
      yvel = 100,
      oy = 0,
      ring = false,
      color = {}
    },

    mars = {
      name = "Mars",
      quad = lg.newQuad(1025, 1025, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.065,
      r = 0,
      x = 1330,
      y = 424,
      assoc_sats = {},
      assoc_moons = {},
      gravity = 0,
      targetRange = 0,
      selfOrbit = 0,
      yvel = -95,
      oy = 0,
      ring = false,
      color = {}
    },

    jupiter = {
      name = "Jupiter",
      quad = lg.newQuad(2050, 1025, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.18,
      r = 0,
      x = 965,
      y = 797,
      assoc_sats = {},
      assoc_moons = {},
      gravity = 0,
      targetRange = 0,
      selfOrbit = 0,
      yvel = 80,
      oy = 0,
      ring = false,
      color = {}
    },

    saturn = {
      name = "Saturn",
      quad = lg.newQuad(0, 2050, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.13,
      r = 0,
      x = 852,
      y = 380,
      assoc_sats = {},
      assoc_moons = {},
      gravity = 0,
      targetRange = 0,
      selfOrbit = 0,
      yvel = -90,
      oy = 0,
      ring = true,
      color = {}
    },

    uranus = {
      name = "Uranus",
      quad = lg.newQuad(1025, 2050, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.13,
      r = 0,
      x = 484,
      y = 764,
      assoc_sats = {},
      assoc_moons = {},
      gravity = 0,
      targetRange = 0,
      selfOrbit = 0,
      yvel = 85,
      oy = 0,
      ring = true,
      color = {}
    },

    neptune = {
      name = "Neptune",
      quad = lg.newQuad(2050, 2050, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.10,
      r = 0,
      x = 411,
      y = 318,
      assoc_sats = {},
      assoc_moons = {},
      gravity = 0,
      targetRange = 0,
      selfOrbit = 0,
      yvel = 95,
      oy = 0,
      ring = false,
      color = {}
    },

    pluto = {
      name = "Pluto",
      quad = lg.newQuad(0, 3075, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.03,
      r = 0,
      x = 171,
      y = 491,
      assoc_sats = {},
      assoc_moons = {},
      gravity = 0,
      targetRange = 0,
      selfOrbit = 0,
      yvel = -80,
      oy = 0,
      ring = false,
      color = {}
    }
  }
  ring = {
    saturn = {
      quad = lg.newQuad(0, 0, 2000, 350, ringsheet:getDimensions())
    },
    uranus = {
      quad = lg.newQuad(0, 351, 2000, 351, ringsheet:getDimensions())
    },
    normal = {
      quad = lg.newQuad(0, 710, 2000, 350, ringsheet:getDimensions())
    }
  }

  -- calculate and set self orbits. twice the radius at 120% or 1024%120 (scaled)
  -- done after we set everything since a table cant refference itself
  -- unlike the sun ones these are important for our satelites
  for i,object in pairs(planet) do
    if object ~= planet.sun then
      object.selfOrbit = 1024*object.scale*1.2
      object.gravity = 1024*object.scale*1.4
	    object.targetRange = 1024*object.scale*1.4
      object.ring = true
      local x, y, w, h = object.quad:getViewport( )
      local r, g, b, a = planetsheetData:getPixel( x+w/2, y+h/2 )
      object.color = {r-20, g-20, b-20, a}
    end
  end
end

-- ENEMY BASE VALUES
function baseValues:loadEnemies(args)
  -- enemy table
  enemy = {
    normal = {
      quad = lg.newQuad(0, 0, 1024, 1024, enemysheet:getDimensions()),
      health = 1,
      damage = 1,
      speed = 100,
      scale = 0.025,
      score = 1
    },
    medium = {
      quad = lg.newQuad(1024, 0, 1024, 1024, enemysheet:getDimensions()),
      health = 1,
      damage = 1,
      speed = 100,
      scale = 1,
      score = 1
    },
    hard = {
      quad = lg.newQuad(0, 1024, 1024, 1024, enemysheet:getDimensions()),
      health = 1,
      damage = 1,
      speed = 100,
      scale = 1,
      score = 1
    },
    extreme = {
      quad = lg.newQuad(1024, 1024, 1024, 1024, enemysheet:getDimensions()),
      health = 1,
      damage = 1,
      speed = 100,
      scale = 1,
      score = 1
    }
  }
  activeEnemies = {}

  -- path data. Paths on which enemies will travel series of rotation triggers
  enemyPath = {
    top = {},
    center = {},
    bottom = {}
  }
end
