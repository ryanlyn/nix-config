import XMonad
import XMonad.Config.Gnome
import XMonad.Layout.Minimize
import qualified Data.Map as M
import System.Exit -- exitWith
import XMonad.Layout.Fullscreen
import XMonad.Layout.CenteredMaster
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.Circle
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiColumns
-- Fullscreen imports:
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W
import XMonad.Util.Run(spawnPipe)
import Control.Monad
import Data.Monoid (All (All))


myTerminal = "alacritty"
myFocusFollowsMouse:: Bool 
myFocusFollowsMouse = True

myBorderWidth = 3
myNormalBorderColor = "#000000"
myFocusedBorderColor = "#A6E1FF"

myModMask = mod1Mask
myWorkspaces = ["1", "2", "3"]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- * NOTE: XMonad.Hooks.EwmhDesktops users must remove the obsolete
-- ewmhDesktopsLayout modifier from layoutHook. It no longer exists.
-- Instead use the 'ewmh' function from that module to modify your
-- defaultConfig as a whole. (See also logHook, handleEventHook, and
-- startupHook ewmh notes.)
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.

myLayouts = smartBorders(avoidStruts(
    -- ThreeColMid layout puts the large master window in the center
    -- of the screen. As configured below, by default it takes of 3/4 of
    -- the available space. Remaining windows tile to both the left and
    -- right of the master window. You can resize using "super-h" and
    -- "super-l".
    ThreeColMid 1 (3/100) (1/3)
    -- The same but with 2 master panes
    -- ||| ThreeColMid 2 (3/100) (1/3)
    ||| multiCol [1] 1 0.01 (-0.5)
    -- Circle layout places the master window in the center of the screen.
    -- Remaining windows appear in a circle around it
    ||| Circle
    -- Grid layout tries to equally distribute windows in the available
    -- space, increasing the number of columns and rows as necessary.
    -- Master window is at top left.
    ||| Grid
    -- Full layout makes every window full screen. When you toggle the
    -- active window, it will bring the active window to the front.
    ||| noBorders Full))

------------------------------------------------------------------------
-- Window rules:

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

myManageHook = composeAll (
    [ 
        manageHook gnomeConfig
        , className =? "Unity-2d-panel" --> doIgnore
        , className =? "Unity-2d-launcher" --> doIgnore
        , resource  =? "desktop_window" --> doIgnore
    ])

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.

myKeys conf@(XConfig {XMonad.modMask = modm}) = -- M.fromList $ -- comment M.fromList when using 'newKeys'
        [
            ((modm , xK_Escape)          , kill)
            , ((modm , xK_s)               , spawn $ XMonad.terminal conf)
            , ((modm , xK_a)                , spawn "rofi -show combi")
            , ((modm , xK_v)               , spawn "code-insiders")
            , ((modm , xK_c)               , spawn "google-chrome")
            , ((modm .|. shiftMask , xK_q) , spawn "killall")
            , ((modm .|. shiftMask , xK_l) , spawn "xdg-screensaver lock")
            , ((modm .|. shiftMask , xK_p) , spawn "gnome-session-quit --power-off")
        ]

newKeys x = M.union (keys def x) (M.fromList (myKeys x))

------------------------------------------------------------------------
-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH event handling to your custom event hooks by
-- combining them with ewmhDesktopsEventHook.
--
-- myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH logHook actions to your custom log hook by
-- combining it with ewmhDesktopsLogHook.
--
-- myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add initialization of EWMH support to your custom startup
-- hook by combining it with ewmhDesktopsStartup.
--
-- myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs

defaults = gnomeConfig {
    -- general 
    terminal    = myTerminal
    , modMask = myModMask
    , focusFollowsMouse = myFocusFollowsMouse
    , borderWidth = myBorderWidth
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , workspaces = myWorkspaces
    -- keys
    , keys       = newKeys
    -- hooks
    , layoutHook = myLayouts
    , manageHook = myManageHook
    -- , handleEventHook = myEventHook
    -- , logHook = myLogHook
    -- , startupHook = myStartupHook
}


-- main = do
--     xmproc <- spawnPipe "xmobar"

    -- xmonad $ gnomeConfig
--         { terminal    = myTerminal
--         , focusFollowsMouse = myFocusFollowsMouse
--         , borderWidth = myBorderWidth
--         , normalBorderColor  = myNormalBorderColor
--         , focusedBorderColor = myFocusedBorderColor
--         , layoutHook = myLayouts
--         , keys       = newKeys
--         , manageHook = myManageHook
--     }
