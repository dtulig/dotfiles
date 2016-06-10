import XMonad
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Util.Run
import XMonad.Util.EZConfig (additionalKeys)
import System.IO

main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ def
       { modMask = mod4Mask
       , terminal = "urxvt"
       , borderWidth = 2
       , normalBorderColor = "#073642"
       , focusedBorderColor = "#cb4b16"
       , startupHook = setWMName "LG3D"
       , handleEventHook = docksEventHook <+> handleEventHook def
       , manageHook = manageDocks <+> manageHook def
       , layoutHook = avoidStruts $ myLayout
       , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppCurrent = xmobarColor "#b58900" "" . wrap "[" "]"
            , ppTitle = xmobarColor "#cb4b16" "" . shorten 50
            , ppLayout = const "" -- to disable the layout info on xmobar
            }
       } `additionalKeys`
       [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
       , ((mod4Mask, xK_p), spawn "dmenu_run -fn 'xft:inconsolata:size=10:antialias=true' -nb '#002b36'")
       ]

myLayout = tiled ||| Mirror tiled ||| Full
  where
    tiled = spacing 5 $ Tall nmaster delta ratio
    nmaster = 1
    ratio = 2/3
    delta = 5/100
