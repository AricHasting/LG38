--Offset baseValues outside of main logic files for clarity
baseValues = {}
local lg = love.graphics

-- THESE FUNCTIONS ARE MEANT FOR RE-CALLING
-- DO NOT LOAD DRAWABLES! ONLY BASE VALUES
function baseValues:loadGame(args)

  love.audio.stop()
  love.audio.play(musicSelected)
  musicSelected:setVolume(0.1)

  healthbarShine = {
    img = lg.newImage("assets/healthbarShine.png"),
    x = 1920,
    y = 0,
    a = 255
  }
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
      baseRange = 0,
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
      baseRange = 0,
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
      baseRange = 0,
      selfOrbit = 0,
      yvel = -100,
      oy = 0,
      ring = false,
      color = {}
    },

    earth = {
      name = "Earth",
      health = 100,
      quad = lg.newQuad(0, 1025, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.078,
      r = 0,
      x = 1350,
      y = 781,
      assoc_sats = {},
      assoc_moons = {},
      gravity = 0,
      targetRange = 0,
      baseRange = 0,
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
      baseRange = 0,
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
      baseRange = 0,
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
      baseRange = 0,
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
      baseRange = 0,
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
      baseRange = 0,
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
      targetRange = 70,
      baseRange = 70,
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

  moonData = {
    quad = lg.newQuad(1025, 3075, 1024, 1024, planetsheet:getDimensions()),
    scale = 0.03
  }

  selectedPlanet = nil

  -- calculate and set self orbits. twice the radius at 120% or 1024%120 (scaled)
  -- done after we set everything since a table cant refference itself
  -- unlike the sun ones these are important for our satelites
  for i,object in pairs(planet) do
    if object ~= planet.sun then
      object.selfOrbit = 1024*object.scale*1.2
      object.gravity = 1024*object.scale*1.4
      object.targetRange = 1024*object.scale*1.4
      object.baseRange = 1024*object.scale*1.4
      local x, y, w, h = object.quad:getViewport( )
      local r, g, b, a = planetsheetData:getPixel( x+w/2, y+h/2 )
      object.color = {r-20, g-20, b-20, a}
    end
  end

  planet.pluto.baseRange = 70
  planet.pluto.targetRange = 70

  planet.venus.baseRange = 110
  planet.venus.targetRange = 110
end

-- ENEMY BASE VALUES
function baseValues:loadEnemies(args)
  -- enemy table
  enemy = {
    normal = {
      quads = {
        lg.newQuad(0, 0, 1024, 1024, enemysheet:getDimensions()),
        lg.newQuad(1025, 0, 1024, 1024, enemysheet:getDimensions()),
        lg.newQuad(0, 0, 1024, 1024, enemysheet:getDimensions()),
        lg.newQuad(2050, 0, 1024, 1024, enemysheet:getDimensions())
      },
      health = 1,
      damage = 1,
      speed = 100,
      scale = 0.05,
      score = 5
    },
    medium = {
      quads = {
        lg.newQuad(0, 1025, 1024, 1024, enemysheet:getDimensions()),
        lg.newQuad(1025, 1025, 1024, 1024, enemysheet:getDimensions()),
        lg.newQuad(0, 1025, 1024, 1024, enemysheet:getDimensions()),
        lg.newQuad(2050, 1025, 1024, 1024, enemysheet:getDimensions())
      },
      health = 2,
      damage = 1,
      speed = 200,
      scale = 0.05,
      score = 10
    },
    hard = {
      quads = {
        lg.newQuad(0, 2050, 1024, 1024, enemysheet:getDimensions()),
        lg.newQuad(1025, 2050, 1024, 1024, enemysheet:getDimensions()),
        lg.newQuad(0, 2050, 1024, 1024, enemysheet:getDimensions()),
        lg.newQuad(2050, 2050, 1024, 1024, enemysheet:getDimensions())
      },
      health = 5,
      damage = 2,
      speed = 100,
      scale = 0.05,
      score = 30
    },
    extreme = {
      quads = {
        lg.newQuad(0, 3075, 1024, 1024, enemysheet:getDimensions()),
        lg.newQuad(1025, 3075, 1024, 1024, enemysheet:getDimensions()),
        lg.newQuad(0, 3075, 1024, 1024, enemysheet:getDimensions()),
        lg.newQuad(2050, 3075, 1024, 1024, enemysheet:getDimensions())
      },
      health = 10,
      damage = 3,
      speed = 100,
      scale = 0.05,
      score = 50
    }
  }
  activeEnemies = {}

  -- path data. Paths on which enemies will travel series of rotation triggers
  enemyPath = {
    top = {{y=369.64285714286,x=331.00446428571,radius=25,r=128.65980825409},{y=377.67857142857,x=341.04910714286,radius=25,r=126.0273733851},{y=401.78571428571,x=379.21875,radius=25,r=111.80140948635},{y=409.82142857143,x=403.32589285714,radius=25,r=101.30993247402},{y=413.83928571429,x=437.47767857143,radius=25,r=90},{y=413.83928571429,x=455.55803571429,radius=25,r=81.869897645844},{y=407.8125,x=489.70982142857,radius=25,r=66.370622269343},{y=391.74107142857,x=513.81696428571,radius=25,r=58.722297133134},{y=245.08928571429,x=726.76339285714,radius=25,r=50.7105931375},{y=225,x=756.89732142857,radius=25,r=54.462322208026},{y=206.91964285714,x=789.04017857143,radius=25,r=75.963756532074},{y=196.875,x=827.20982142857,radius=25,r=90},{y=196.875,x=875.42410714286,radius=25,r=90},{y=212.94642857143,x=919.62053571429,radius=25,r=113.19859051365},{y=233.03571428571,x=949.75446428571,radius=25,r=122.73522627211},{y=251.11607142857,x=977.87946428571,radius=25,r=127.55128212618},{y=498.21428571429,x=1299.3080357143,radius=25,r=100.30484646877},{y=510.26785714286,x=1345.5133928571,radius=25,r=90},{y=500.22321428571,x=1387.7008928571,radius=25,r=71.565051177078},{y=413.83928571429,x=1612.7008928571,radius=25,r=82.146686698022},{y=405.80357142857,x=1674.9776785714,radius=25,r=108.43494882292},{y=421.875,x=1711.1383928571,radius=25,r=123.69006752598},{y=458.03571428571,x=1749.3080357143,radius=25,r=153.43494882292},{y=480.13392857143,x=1755.3348214286,radius=25,r=171.86989764584},{y=516.29464285714,x=1755.3348214286,radius=25,r=194.03624346793},{y=918.08035714286,x=1636.8080357143,radius=25,r=218.65980825409},{y=930.13392857143,x=1616.71875,radius=25,r=264.2894068625},{y=932.14285714286,x=1584.5758928571,radius=25,r=294.77514056883}},
    center = {{y=522.32142857143,x=180.33482142857,radius=25,r=71.565051177078},{y=514.28571428571,x=192.38839285714,radius=25,r=38.65980825409},{y=349.55357142857,x=308.90625,radius=25,r=15.642246457209},{y=315.40178571429,x=310.91517857143,radius=25,r=0},{y=281.25,x=312.92410714286,radius=25,r=0},{y=249.10714285714,x=318.95089285714,radius=25,r=36.869897645844},{y=225,x=339.04017857143,radius=25,r=51.34019174591},{y=204.91071428571,x=367.16517857143,radius=25,r=75.068582821862},{y=196.875,x=401.31696428571,radius=25,r=90},{y=202.90178571429,x=445.51339285714,radius=25,r=113.19859051365},{y=214.95535714286,x=475.64732142857,radius=25,r=119.05460409908},{y=243.08035714286,x=511.80803571429,radius=25,r=140.19442890773},{y=271.20535714286,x=523.86160714286,radius=25,r=167.90524292299},{y=309.375,x=529.88839285714,radius=25,r=180},{y=345.53571428571,x=527.87946428571,radius=25,r=206.56505117708},{y=377.67857142857,x=509.79910714286,radius=25,r=204.39030706247},{y=703.125,x=328.99553571429,radius=25,r=196.38954033403},{y=737.27678571429,x=318.95089285714,radius=25,r=180},{y=755.35714285714,x=318.95089285714,radius=25,r=170.53767779197},{y=795.53571428571,x=324.97767857143,radius=25,r=164.74488129694},{y=841.74107142857,x=343.05803571429,radius=25,r=156.03751102542},{y=869.86607142857,x=357.12053571429,radius=25,r=135},{y=897.99107142857,x=383.23660714286,radius=25,r=128.65980825409},{y=914.0625,x=407.34375,radius=25,r=120.96375653207},{y=924.10714285714,x=427.43303571429,radius=25,r=102.52880770915},{y=932.14285714286,x=463.59375,radius=25,r=90},{y=932.14285714286,x=501.76339285714,radius=25,r=90},{y=928.125,x=547.96875,radius=25,r=60.945395900923},{y=910.04464285714,x=578.10267857143,radius=25,r=48.36646066343},{y=879.91071428571,x=612.25446428571,radius=25,r=36.869897645844},{y=849.77678571429,x=630.33482142857,radius=25,r=21.250505507133},{y=787.5,x=650.42410714286,radius=25,r=9.1011242852351},{y=343.52678571429,x=680.55803571429,radius=25,r=12.094757077012},{y=307.36607142857,x=690.60267857143,radius=25,r=21.801409486352},{y=271.20535714286,x=706.67410714286,radius=25,r=36.869897645844},{y=253.125,x=720.73660714286,radius=25,r=49.398705354996},{y=233.03571428571,x=748.86160714286,radius=25,r=63.434948822922},{y=218.97321428571,x=772.96875,radius=25,r=71.565051177078},{y=208.92857142857,x=807.12053571429,radius=25,r=78.69006752598},{y=204.91071428571,x=839.26339285714,radius=25,r=90},{y=206.91964285714,x=887.47767857143,radius=25,r=96.34019174591},{y=214.95535714286,x=915.60267857143,radius=25,r=119.05460409908},{y=231.02678571429,x=949.75446428571,radius=25,r=119.05460409908},{y=249.10714285714,x=975.87053571429,radius=25,r=139.398705355},{y=285.26785714286,x=997.96875,radius=25,r=144.46232220803},{y=325.44642857143,x=1016.0491071429,radius=25,r=174.80557109227},{y=369.64285714286,x=1020.0669642857,radius=25,r=180},{y=405.80357142857,x=1020.0669642857,radius=25,r=193.24051991519},{y=450,x=1010.0223214286,radius=25,r=208.30075576601},{y=490.17857142857,x=987.92410714286,radius=25,r=212.00538320808},{y=520.3125,x=969.84375,radius=25,r=215.03164382953},{y=703.125,x=770.95982142857,radius=25,r=197.52556837372},{y=747.32142857143,x=758.90625,radius=25,r=180},{y=771.42857142857,x=756.89732142857,radius=25,r=186.34019174591},{y=803.57142857143,x=754.88839285714,radius=25,r=174.2894068625},{y=843.75,x=760.91517857143,radius=25,r=167.47119229085},{y=879.91071428571,x=768.95089285714,radius=25,r=158.19859051365},{y=910.04464285714,x=783.01339285714,radius=25,r=139.398705355},{y=938.16964285714,x=805.11160714286,radius=25,r=138.81407483429},{y=968.30357142857,x=831.22767857143,radius=25,r=135},{y=988.39285714286,x=859.35267857143,radius=25,r=106.69924423399},{y=1000.4464285714,x=893.50446428571,radius=25,r=111.80140948635},{y=1010.4910714286,x=927.65625,radius=25,r=96.34019174591},{y=1012.5,x=969.84375,radius=25,r=90},{y=1008.4821428571,x=1020.0669642857,radius=25,r=79.695153531234},{y=996.42857142857,x=1060.2455357143,radius=25,r=60.945395900923},{y=972.32142857143,x=1098.4151785714,radius=25,r=60.255118703058},{y=946.20535714286,x=1136.5848214286,radius=25,r=33.69006752598},{y=914.0625,x=1158.6830357143,radius=25,r=33.495184673741}},
    bottom = {{y=652.90178571429,x=373.19196428571,radius=25,r=54.162347045722},{y=626.78571428571,x=411.36160714286,radius=25,r=60.255118703058},{y=614.73214285714,x=449.53125,radius=25,r=90},{y=614.73214285714,x=491.71875,radius=25,r=101.30993247402},{y=630.80357142857,x=525.87053571429,radius=25,r=113.19859051365},{y=654.91071428571,x=564.04017857143,radius=25,r=132.70938995736},{y=934.15178571429,x=841.27232142857,radius=25,r=126.0273733851},{y=968.30357142857,x=893.50446428571,radius=25,r=104.03624346793},{y=978.34821428571,x=931.67410714286,radius=25,r=90},{y=980.35714285714,x=975.87053571429,radius=25,r=90},{y=970.3125,x=1022.0758928571,radius=25,r=63.434948822922},{y=950.22321428571,x=1060.2455357143,radius=25,r=48.81407483429},{y=916.07142857143,x=1098.4151785714,radius=25,r=32.005383208084},{y=867.85714285714,x=1128.5491071429,radius=25,r=18.152705886651},{y=397.76785714286,x=1257.1205357143,radius=25,r=23.198590513648},{y=361.60714285714,x=1275.2008928571,radius=25,r=53.130102354156},{y=341.51785714286,x=1307.34375,radius=25,r=82.874983651099},{y=339.50892857143,x=1339.4866071429,radius=25,r=102.52880770915},{y=355.58035714286,x=1373.6383928571,radius=25,r=120.96375653207},{y=369.64285714286,x=1393.7276785714,radius=25,r=154.9831065219},{y=843.75,x=1598.6383928571,radius=25,r=127.56859202883},{y=857.8125,x=1620.7366071429,radius=25,r=120.96375653207},{y=871.875,x=1644.84375,radius=25,r=155.55604521958},{y=914.0625,x=1658.90625,radius=25,r=180},{y=942.1875,x=1652.8794642857,radius=25,r=228.81407483429},{y=964.28571428571,x=1616.71875,radius=25,r=258.69006752598},{y=960.26785714286,x=1578.5491071429,radius=25,r=299.19748604606}},
    all = {{y=825.66964285714,x=1433.90625,radius=25,r=223.26429541107},{y=859.82142857143,x=1401.7633928571,radius=25,r=254.05460409908},{y=871.875,x=1359.5758928571,radius=25,r=277.1250163489},{y=865.84821428571,x=1311.3616071429,radius=25,r=307.8749836511},{y=837.72321428571,x=1275.2008928571,radius=25,r=334.65382405805},{y=799.55357142857,x=1257.1205357143,radius=25,r=6.5819446551781},{y=747.32142857143,x=1263.1473214286,radius=25,r=39.805571092265},{y=711.16071428571,x=1293.28125,radius=25,r=65.376435213836},{y=689.0625,x=1341.4955357143,radius=25,r=97.125016348902},{y=695.08928571429,x=1389.7098214286,radius=25,r=131.423665625},{y=725.22321428571,x=1423.8616071429,radius=25,r=156.37062226934},{y=757.36607142857,x=1437.9241071429,radius=25,r=180}}
  }

  waves = {
    {normalSpawner = {spawnDelay = 0, spawnPeriod = 0.5, spawnType = enemy.normal, spawnPath = enemyPath.center, spawnCount = 10, myTimer = 0, periodTimer = 0.5}},
    {normalSpawner = {spawnDelay = 0, spawnPeriod = 0.4, spawnType = enemy.normal, spawnPath = enemyPath.center, spawnCount = 20, myTimer = 0, periodTimer = 0.2}},
    {normalSpawner = {spawnDelay = 0, spawnPeriod = 0.5, spawnType = enemy.normal, spawnPath = enemyPath.center, spawnCount = 10, myTimer = 0, periodTimer = 0.2}, mediumSpawner = {spawnDelay = 1, spawnPeriod = 1, spawnType = enemy.medium, spawnPath = enemyPath.center, spawnCount = 5, myTimer = 0, periodTimer = 1}},
    {normalSpawner = {spawnDelay = 0, spawnPeriod = 0.4, spawnType = enemy.normal, spawnPath = enemyPath.center, spawnCount = 20, myTimer = 0, periodTimer = 0.2}, normalSpawner2 = {spawnDelay = 0, spawnPeriod = 0.4, spawnType = enemy.normal, spawnPath = enemyPath.bottom, spawnCount = 20, myTimer = 0, periodTimer = 0.2}},
    {normalSpawner = {spawnDelay = 0, spawnPeriod = 0.4, spawnType = enemy.normal, spawnPath = enemyPath.center, spawnCount = 20, myTimer = 0, periodTimer = 0.2}, normalSpawner2 = {spawnDelay = 0, spawnPeriod = 0.4, spawnType = enemy.normal, spawnPath = enemyPath.bottom, spawnCount = 20, myTimer = 0, periodTimer = 0.2}, normalSpawner3 = {spawnDelay = 0, spawnPeriod = 0.4, spawnType = enemy.normal, spawnPath = enemyPath.top, spawnCount = 20, myTimer = 0, periodTimer = 0.2}},
    {hardSpawner = {spawnDelay = 0, spawnPeriod = 3, spawnType = enemy.hard, spawnPath = enemyPath.center, spawnCount = 5, myTimer = 0, periodTimer = 3}, extremeSpawner = {spawnDelay = 10, spawnPeriod = 1, spawnType = enemy.extreme, spawnPath = enemyPath.center, spawnCount = 1, myTimer = 0, periodTimer = 3}}
  }

  waveOngoing = false
  wavetimer = 0
  waveNumber = 1
end

function baseValues:loadStore(args)
  -- track the player's credits and const costs for each upgrade
  store = {
    credits = 100,
    price_laser = 70,
    price_moon = 40,
    price_colony = 100,
    price_lidar = 110,
    price_shock = 120,
    price_ring = 10,
    bonus_colony = 15,
    round_bonus = 100
  }
end

function baseValues:loadSatellites(args)
  laserquad = lg.newQuad(0, 0, 254, 254, satellitesheet:getDimensions())
  shockquad = lg.newQuad(255, 0, 254, 254, satellitesheet:getDimensions())

  laserFireRate = 1
  shockFireRate = 2

  shockDamage = 1
  laserDamage = 1
end

function baseValues:loadAll()
  self:loadGame()
  self:loadPlanets()
  self:loadEnemies()
  self:loadSatellites()
  self:loadStore()
end
