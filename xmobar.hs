-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

-- This is setup for dual 1920x1080 monitors, with the right monitor as primary
Config {
  font = "xft:Hack:hinting=slight:size=10:antialias=true"
  --font = "xft:Fixed-8"
  , bgColor = "#000000"
  , fgColor = "#ffffff"
  , position = Static { xpos = 1920, ypos = 0, width = 1780, height = 16 }
  , lowerOnStart = True
  , commands =
    [ Run Weather "RJTT"    [ "--template", "<skyCondition> <fc=#4682B4><tempC></fc>°C~<fc=#4682B4><rh></fc>%~<fc=#4682B4><pressure></fc>hPa"
                            ] 3600
    , Run DynNetwork        [ "--template" , "<dev>: <tx>kB/s|<rx>kB/s"
                            , "--Low"      , "1000"       -- units: kB/s
                            , "--High"     , "5000"       -- units: kB/s
                            , "--low"      , "darkgreen"
                            , "--normal"   , "darkorange"
                            , "--high"     , "darkred"
                            ] 60
    , Run TopProc           [] 40
    , Run TopMem            [] 40
    , Run MultiCpu          [ "--template" , "Cpu: <total0>% <total1>% <total2>% <total3>%"
                            , "--Low"      , "50"         -- units: %
                            , "--High"     , "85"         -- units: %
                            , "--low"      , "darkgreen"
                            , "--normal"   , "darkorange"
                            , "--high"     , "darkred"
                            ] 40
    , Run CoreTemp          [ "--template" , "Temp: <core0>°C|<core1>°C"
                            , "--Low"      , "70"        -- units: °C
                            , "--High"     , "80"        -- units: °C
                            , "--low"      , "darkgreen"
                            , "--normal"   , "darkorange"
                            , "--high"     , "darkred"
                            ] 50
    , Run Memory            [ "--template" , "Mem: <usedratio>%"
                            , "--Low"      , "50"        -- units: %
                            , "--High"     , "80"        -- units: %
                            , "--low"      , "darkgreen"
                            , "--normal"   , "darkorange"
                            , "--high"     , "darkred"
                            ] 40
    , Run DiskIO            [ ("/"         , "/ <read> <write>"),
                              ("/home"     , "~ <read> <write>")
                            ]
                            [ "--low"      , "darkgreen"
                            , "--normal"   , "darkorange"
                            , "--high"     , "darkred"
                            ] 50
    , Run Battery           [ "--template" , "Batt: <acstatus>"
                            , "--Low"      , "10"        -- units: %
                            , "--High"     , "80"        -- units: %
                            , "--low"      , "darkred"
                            , "--normal"   , "darkorange"
                            , "--high"     , "darkgreen"

                            , "--" -- discharging status
                            , "-o" , "<left>% (<timeleft>)"
                                     -- AC "on" status
                            , "-O" , "<fc=#dAA520>Charging</fc>"
                                     -- charged status
                            , "-i" , "<fc=#006000>Charged</fc>"
                            ] 50
    , Run Date              "<fc=#ABABAB>%F (%a) %T</fc>" "date" 30
    , Run Kbd               [ ("us(dvp)", "<fc=#66CD00>DVP</fc>")
                            , ("ru", "<fc=#8B0000>RU</fc>")
                            , ("us", "<fc=#9999ff>US</fc>")
                            ]
    , Run StdinReader
    ]
  , sepChar = "%"
  , alignSep = "}{"
  , template = "%StdinReader% }{%dynnetwork% | %top% | %multicpu% | %topmem% <fc=#66CD00>|</fc> %memory% %diskio% <fc=#66CD00>|</fc> %date% <fc=#66CD00>|</fc> %kbd%"
}
