--Offset baseValues outside of main logic files for clarity
baseValues = {}
local lg = love.graphics

-- THIS FUNCTION IS MEANT FOR RE-CALLING
-- DO NOT LOAD DRAWABLES! ONLY BASE VALUES
function baseValues:loadPlanets(arg)
  -- planets table
  planet = {
    sun = {
      quad = lg.newQuad(0, 0, 1024, 1024, planetsheet:getDimensions()), -- drawable crop
      scale = 0.7,
      r = 0,
      x = gameWidth+220,
      y = gameHeight-50,
      assoc_sats = {}
    },

    mercury = {
      quad = lg.newQuad(1025, 0, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.05,
      r = 0,
      x = 1600,
      y = 900,
      selfOrbit = 0, -- placeholder
      assoc_sats = {}
    },

    venus = {
      quad = lg.newQuad(2050, 0, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.065,
      r = 0,
      x = 1641,
      y = 525,
      selfOrbit = 0, -- placeholder
      assoc_sats = {}
    },

    earth = {
      quad = lg.newQuad(0, 1025, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.078,
      r = 0,
      x = 1350,
      y = 781,
      selfOrbit = 0, -- placeholder
      assoc_sats = {}
    },

    mars = {
      quad = lg.newQuad(1025, 1025, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.065,
      r = 0,
      x = 1380,
      y = 461,
      selfOrbit = 0, -- placeholder
      assoc_sats = {}
    },

    jupiter = {
      quad = lg.newQuad(2050, 1025, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.18,
      r = 0,
      x = 965,
      y = 797,
      selfOrbit = 0, -- placeholder
      assoc_sats = {}
    },

    saturn = {
      quad = lg.newQuad(0, 2050, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.13,
      r = 0,
      x = 852,
      y = 380,
      selfOrbit = 0, -- placeholder
      assoc_sats = {}
    },

    uranus = {
      quad = lg.newQuad(1025, 2050, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.13,
      r = 0,
      x = 484,
      y = 764,
      selfOrbit = 0, -- placeholder
      assoc_sats = {}
    },

    neptune = {
      quad = lg.newQuad(2050, 2050, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.10,
      r = 0,
      x = 411,
      y = 318,
      selfOrbit = 0, -- placeholder
      assoc_sats = {}
    },

    pluto = {
      quad = lg.newQuad(0, 3075, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.03,
      r = 0,
      x = 171,
      y = 491,
      selfOrbit = 0, -- placeholder
      assoc_sats = {}
    }
  }

  -- calculate and set self orbits. twice the radius at 120% or 1024%120 (scaled)
  -- done after we set everything since a table cant refference itself
  -- unlike the sun ones these are important for our satelites
  for i,object in pairs(planet) do
    if object ~= planet.sun then
      object.selfOrbit = 1024*object.scale*1.2
    end
  end

end
