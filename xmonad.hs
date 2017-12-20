import           System.Exit
import           System.IO
import           XMonad

import           Control.Applicative

import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.UrgencyHook

import           XMonad.Layout.Circle
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.Grid
import           XMonad.Layout.IM            as IM
import           XMonad.Layout.NoBorders
import           XMonad.Layout.PerWorkspace
import           XMonad.Layout.Reflect
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.Spiral
import           XMonad.Layout.Tabbed
import           XMonad.Layout.Decoration
import           XMonad.Layout.ThreeColumns

import           XMonad.Actions.CopyWindow
import           XMonad.Actions.CycleWS      (nextWS, prevWS, shiftToNext, shiftToPrev)
import           XMonad.Actions.GridSelect

import           XMonad.Util.EZConfig
import           XMonad.Util.Cursor
import           XMonad.Util.NamedWindows
import           XMonad.Util.Run             (safeSpawn, spawnPipe)
import           XMonad.Util.Scratchpad
import           XMonad.Util.NamedScratchpad

import qualified Data.Map                    as M
import qualified XMonad.StackSet             as W

myTerminal = "/usr/bin/urxvtc"
myWorkspaces = ["1:term", "2:web", "3:code", "4:chat", "5:media", "6:term", "7:stock"] ++ map show [8..9]

------------------------------------------------------------------------
-- Window rules
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
myManageHook = composeAll
  [ className =? "Google-chrome-unstable"  --> doShift "2:web"
  , className =? "Google-chrome-beta"      --> doShift "2:web"
  , className =? "Google-chrome-stable"    --> doShift "2:web"
  , isDialog                      --> doFloat
  , className =? "Firefox"        --> doShift "2:web"
  , className =? "Gimp"           --> doFloat
  , className =? "Pavucontrol"    --> doFloat
  , className =? "Emacs"          --> doShift "3:code"
  , className =? "Remacs"         --> doShift "3:code"
  , className =? "Vim"            --> doShift "3:code"
  , className =? "Pidgin"         --> doShift "4:chat"
  , className =? "Franz"          --> doShift "4:chat"
  , className =? "mpv"            --> doShift "5:media"
  , className =? "Vlc"            --> doShift "5:media"
  , className =? "sun-awt-X11-XFramePeer"  --> doShift "7:stock" -- For interactive brokers
  , className =? "Steam"          --> doShift "9"
  , resource  =? "desktop_window" --> doIgnore
  , className =? "stalonetray"    --> doIgnore
  , className =? "Xfce4-notifyd"  --> doIgnore
  , isFullscreen --> (doF W.focusDown <+> doFullFloat)]

-- Layouts
myTabbed = tabbed shrinkText tabConfig

fullscreenLayout = noBorders (fullscreenFull Full)
defaultLayout = (Tall 1 (3/100) (1/2) |||
  Mirror (Tall 1 (3/100) (1/2)) |||
  myTabbed |||
  Circle |||
  Full |||
  spiral (6/7)) |||
  fullscreenLayout

imLayout = IM.withIM (1/8) (IM.And (IM.ClassName "Pidgin") (IM.Role "buddy_list")) $ reflectHoriz $
           IM.withIM (1/8) (IM.Title "Hangouts") $ reflectHoriz Grid

myLayout = smartBorders . avoidStruts $
           onWorkspace "4:chat" imLayout $
           onWorkspace "5:media" fullscreenLayout $
           onWorkspace "7:stock" fullscreenLayout $
           onWorkspace "9" fullscreenLayout defaultLayout

------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the ir_black theme.
myNormalBorderColor  = "#7c7c7c"
myFocusedBorderColor = "#ffb6b0"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = def {
  activeBorderColor   = "#7C7C7C",
  activeTextColor     = "#CEFFAC",
  activeColor         = "#000000",
  inactiveBorderColor = "#7C7C7C",
  inactiveTextColor   = "#EEEEEE",
  inactiveColor       = "#000000"
}

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"

 -- Width of the window border in pixels.
myBorderWidth = 1

------------------------------------------------------------------------
-- Window WM_URGENT
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
  urgencyHook LibNotifyUrgencyHook w = do
    name     <- getName w
    Just idx <- W.findTag w <$> gets windowset

    safeSpawn "notify-send" [show name, "workspace " ++ idx]

showActivePid = do
  d <- asks display
  withFocused $ \w -> do
    net_wm_pid <- getAtom "_NET_WM_PID"
    name       <- getName w
    pid        <- io $ getWindowProperty32 d net_wm_pid w
    case pid of
      Just [pid] -> do spawn $ "echo " ++ show pid ++ "| xsel -ib"
                       safeSpawn "notify-send" [show name, "pid " ++ show pid]
      Nothing    -> trace $ "can't find pid for window " ++ show w

------------------------------------------------------------------------
-- Key bindings
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
myModMask = mod4Mask

myKeys conf = mkKeymap conf $
  -- Launch dmenu via yeganesh.
  [ ("M-p"           , spawn "~/.xmonad/bin/dmenu-with-yeganesh")
  , ("M-S-<Space>"   , setLayout $ XMonad.layoutHook conf)
  , ("M-'"           , scratchpadSpawnAction conf) -- quake terminal

  -- Close focused window.
  , ("M-S-a"         , kill)
  -- Start a terminal. Terminal to start is specified by myTerminal variable.
  , ("M-S-<Return>"  , spawn myTerminal)
  -- Resize viewed windows to the correct size.
  , ("M-n"           , refresh)
  -- Move focus to the master window.
  , ("M-m"           , windows W.focusMaster)
  -- Move focus to the next window.
  , ("M-<Tab>"       , windows W.focusDown)
  -- Move focus to the previous window.
  , ("M-S-<Tab>"     , windows W.focusUp)
  -- Swap the focused window and the master window.
  , ("M-<Return>"    , windows W.swapMaster)
  -- Swap the focused window with the next window.
  , ("M-j"           , windows W.swapDown)
  -- Swap the focused window with the previous window.
  , ("M-k"           , windows W.swapUp)
  -- hide xmobar
  , ("M-f"           , sendMessage ToggleStruts)
  -- Push window back into tiling.
  , ("M-t"           , withFocused $ windows . W.sink)
  -- Cycle through the available layout algorithms.
  , ("M-<Space>"     , sendMessage NextLayout)
  , ("M-a"           , sendMessage MirrorShrink)
  , ("M-z"           , sendMessage MirrorExpand)
  , ("M-y"           , spawn "wget -q --spider youtube.com && notify-send 'Youtube available'")
  , ("M-h"           , showActivePid)
  --, ("M-d"           , spawn "~/.xmonad/bin/pavumute " ++ showActivePid)
  , ("M-d"           , spawn "setxkbmap -model 'kinesis' -layout 'us,ru,us' -variant 'dvp,'")

  , ("M-<Right>"     , nextWS)
  , ("M-<Left>"      , prevWS)
  , ("M-S-<Right>"   , shiftToNext)
  , ("M-S-<Left>"    , shiftToPrev)

  , ("M-s"           , goToSelected def)

  -- System func
  , ("M-q"           , restart "xmonad" True)
  , ("M-S-q"         , io exitSuccess)
  , ("M-S-l"         , spawn "i3lock -c000000")
  --, ("M-S-s"         , spawn "systemctl suspend")
  , ("M-S-s"         , spawn "sudo pm-suspend")

  -- Redshift
  , ("M-<F9>"        , spawn "redshift -O 2375")
  , ("M-<F10>"       , spawn "redshift -O 3750")
  , ("M-<F11>"       , spawn "redshift -O 5125")
  , ("M-<F12>"       , spawn "redshift -O 6500")

  , ("M-<Print>"     , spawn "sleep 0.2; scrot -s")
  , ("<Print>"       , spawn "scrot")
  , ("<XF86Back>"    , prevWS)
  , ("<XF86Forward>" , nextWS)

  --, ("<XF86AudioPlay>"       , spawn "setsid deadbeef --play-pause")
  --, ("<XF86AudioPrev>"       , spawn "setsid deadbeef --prev")
  --, ("<XF86AudioNext>"       , spawn "setsid deadbeef --next")
  --, ("<XF86AudioStop>"       , spawn "setsid deadbeef --random")

  --, ("<XF86AudioPlay>"       , spawn "mpc toggle")
  --, ("<XF86AudioStop>"       , spawn "mpc stop")
  --, ("<XF86AudioPrev>"       , spawn "mpc prev")
  --, ("<XF86AudioNext>"       , spawn "mpc next")

  --, ("<XF86AudioMute>"       , spawn "amixer -c0 -- sset Master toggle")
  --, ("<XF86AudioLowerVolume>", spawn "amixer -c0 -- sset Master 0.75dB-")
  --, ("<XF86AudioRaiseVolume>", spawn "amixer -c0 -- sset Master 0.75dB+")
  ]
  ++
  -- "M-[1..9]" -- Switch to workspace N
  -- "M-S-[1..9]" -- Move client to workspace N
  -- "M-C-[1..9]" -- Copy client to workspace N
  [ ("M-" ++ m ++ [k], windows $ f i)
  | (i, k) <- zip (XMonad.workspaces conf) "&[{}(=*)+"
  , (f, m) <- [ (W.greedyView, "")
              , (W.shift, "S-")
              , (copy, "C-")
              ]
  ]
  ++
  -- "M-C-S-[1..9]" -- Move client to workspace N and follow
  [ ("M-C-S-" ++ [k], windows (W.shift i) >> windows (W.greedyView i))
  | (i, k) <- zip (XMonad.workspaces conf) "&[{}(=*)+"
  ]
  ++
  -- "M-{w,e,r}" -- Switch to physical/Xinerama screens 1, 2, or 3
  -- "M-S-{w,e,r}" -- Move client to screen 1, 2, or 3
  [ ("M-" ++ m ++ [k], screenWorkspace sc >>= flip whenJust (windows . f))
  | (k, sc) <- zip ";,." [0..]
  , (f, m) <- [(W.view, ""), (W.shift, "S-")
              ]
 ]

------------------------------------------------------------------------
-- Mouse bindings
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse = True

myMouseBindings XConfig{XMonad.modMask = modMask} = M.fromList
  -- mod-button1, Set the window to floating mode and move by dragging
  [ ((modMask, button1), \ w -> focus w >> mouseMoveWindow w)
  -- mod-button2, Raise the window to the top of the stack
  , ((modMask, button2), \ w -> focus w >> windows W.swapMaster)
  -- mod-button3, Set the window to floating mode and resize by dragging
  , ((modMask, button3), \ w -> focus w >> mouseResizeWindow w)
  ]

------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
-- logHook = dynamicLogDzen

------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
myStartupHook = setDefaultCursor xC_gumby --return ()

------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ docks $ withUrgencyHook LibNotifyUrgencyHook $ defaults {
    logHook = dynamicLogWithPP $ xmobarPP {
        ppOutput = hPutStrLn xmproc
        , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
        , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
        , ppSep = "   "
        }
  }

------------------------------------------------------------------------
-- Combine it all together
defaults = def {
  -- simple stuff
  terminal           = myTerminal,
  focusFollowsMouse  = myFocusFollowsMouse,
  borderWidth        = myBorderWidth,
  modMask            = myModMask,
  workspaces         = myWorkspaces,
  normalBorderColor  = myNormalBorderColor,
  focusedBorderColor = myFocusedBorderColor,

  -- key bindings
  keys               = myKeys,
  mouseBindings      = myMouseBindings,

  -- hooks, layouts
  layoutHook         = myLayout,
  manageHook         = myManageHook <+> manageDocks,

  startupHook        = myStartupHook
}
