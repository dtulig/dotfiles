import XMonad
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (fullscreenEventHook, ewmh)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Util.Run
import XMonad.Util.EZConfig (additionalKeys)
import System.IO

main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ ewmh def
       { modMask = mod4Mask
       , terminal = "ghostty"
       , borderWidth = 2
       , normalBorderColor = "#5e81ac"
       , focusedBorderColor = "#88c0d0"
       , startupHook = setWMName "LG3D"
       , workspaces = myWorkspaces
       , handleEventHook = docksEventHook <+> handleEventHook def <+> fullscreenEventHook
       , manageHook = manageDocks <+> (isFullscreen --> doFullFloat) <+> manageHook def
       , layoutHook = smartBorders(avoidStruts $ myLayout)
       , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppCurrent = xmobarColor "#8fbcbb" ""
            , ppVisible = xmobarColor "#4c566a" ""
            , ppTitle = xmobarColor "#5e81ac" "" . shorten 50
            , ppLayout = const "" -- to disable the layout info on xmobar
            , ppSep = " :  "
            }
       } `additionalKeys`
       [ ((mod4Mask .|. shiftMask, xK_z), spawn "/home/dtulig/bin/lock_screen.sh")
       --, ((mod4Mask, xK_p), spawn "dmenu_run -fn 'xft:Fira Mono Medium for Powerline:pixelsize=18:antialias=true' -nb '#002b36'")
       , ((mod4Mask, xK_p), spawn "rofi -show run")
       ]

myWorkspaces = [ " 1 \xf269 "
               , "2 \xf121 "
               , "3 \xf121 "
               , "4 "
               , "5 \xf11b"
               , "6 "
               , "7 "
               , "8 "
               , "9 " ]

myLayout = tiled ||| Mirror tiled ||| Full
  where
    tiled = spacing 5 $ Tall nmaster delta ratio
    nmaster = 1
    ratio = 2/3
    delta = 5/100
