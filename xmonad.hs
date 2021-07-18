import XMonad 
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Util.EZConfig(additionalKeys)
import qualified XMonad.StackSet as W
------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces :: [String]
myWorkspaces = ["1:term", "2:emacs", "3:web"] ++ map show [4..6]

-- Command to launch the bar
myBar :: String
myBar = "xmobar"

-- Terminal
myTerminal :: String
myTerminal = "alacritty"

-- Styles and Colors
border :: String
border = "#101030"

fBorder :: String
fBorder = "#202050"

-- key binding to toggle gap for the bar
toggleStrutsKey :: XConfig l -> (KeyMask, KeySym)
toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP :: PP
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "Navigator"      --> doShift "3:web"
    , className =? "firefox"        --> doShift "3:web"
    , resource  =? "desktop_window" --> doIgnore
    , className =? "Gimp"           --> doFloat
    , resource  =? "gpicview"       --> doFloat
    , className =? "MPlayer"        --> doFloat
    , className =? "Xchat"          --> doShift "5:media"
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]
  
-- The rest of the custom settings
myConfig :: XConfig (Choose Tall (Choose (Mirror Tall) Full))
myConfig = def { modMask = mod4Mask
               , borderWidth = 1
               , terminal = myTerminal
               , normalBorderColor = border
               , focusedBorderColor = fBorder
               } `additionalKeys`
               [ ((0 , 0x1008FF11), spawn "amixer -q sset Master 2%-"),
                 ((0 , 0x1008FF13), spawn "amixer -q sset Master 2%+"),
                 ((0 , 0x1008FF12), spawn "amixer set Master toggle")
               ]

main :: IO ()
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

-- main2 :: IO ()
-- main2 = do
--   xmproc <- spawnPipe "xmobar"
--   xmonad $ docks defaultConfig
  
--     { layoutHook = avoidStruts $ layoutHook defaultConfig
--     } `additionalKeys`
--     [ ((0 , 0x1008FF11), spawn "amixer -q sset Master 2%-"),
--       ((0 , 0x1008FF13), spawn "amixer -q sset Master 2%+"),
--       ((0 , 0x1008FF12), spawn "amixer set Master toggle")
--     ]
