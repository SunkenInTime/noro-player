[Variables]
PlayerPlugin=MediaPlayer
PlayerName=Default

DisplayFont=Geist Mono
; Icons match reference-website/index.html SVGs (24 viewBox, scaled to IconSize)
IconSize=28

ShellWidth=340
ShellHeight=356
ShellRadius=51
; Full-skin grain overlay (Player.ini GrainOverlay); 0-255
GrainAlpha=7.2

ScreenX=14
ScreenY=14
ScreenWidth=312
ScreenHeight=188
; Reference screen-area: border-radius 36px 36px 4px 4px (top / bottom corners)
ScreenRadiusTop=36
ScreenRadiusBottom=4

; Track title: inset readout on the screen (same horizontal padding as bottom row: ElapsedX - ScreenX)
TitleAreaX=12
TitleAreaY=28
TitleAreaWidth=288

; Bottom overlay row: aligned with reference padding (~14px from screen bottom)
InfoY=180
ElapsedX=26
StatusTextX=170
ClockX=314

ProgressHeight=3

GrilleX=14
GrilleY=212
GrilleWidth=312
GrilleHeight=24

ButtonY=240
; Row matches grille width: GrilleX + GrilleWidth = three buttons + two 6px gaps (312 = 3*100 + 12)
ButtonGap=6
ButtonWidth=100
ButtonHeight=100
ButtonRadius=8
Button1X=14
Button2X=120
Button3X=226

ShellColor=26,26,26,255
ShellStroke=0,0,0,255
ShellHighlight=255,255,255,26

ScreenFrameColor=0,0,0,255
ScreenStroke=0,0,0,255
ScreenHighlight=255,255,255,26
ScreenFallback=0,0,0,255

GridColor=255,255,255,10

TextColor=255,255,255,255
IconColor=208,208,208,255
RecordColor=255,59,48,255

ProgressBase=255,255,255,13
ProgressFill=255,255,255,255

GrilleFill=26,26,26,255
GrilleStroke=0,0,0,255
; Reference .grille: ~1px black dots @ 0.6 opacity — modest dot size + tint for legibility
GrilleDotTint=0,0,0,165

; Match reference .btn: flat #1a1a1a, border #0a0a0a, box-shadow inset 0 1px 2px rgba(255,255,255,.05)
ButtonFill=26,26,26,255
ButtonCenterFill=26,26,26,255
ButtonStroke=10,10,10,255
ButtonHighlightEdge=255,255,255,13
ButtonHighlightSide=255,255,255,5
ButtonShadowEdge=0,0,0,12

ButtonPressedFill=20,20,20,255
IconPressedColor=182,182,182,255
PrevBtnFill=26,26,26,255
PlayBtnFill=26,26,26,255
NextBtnFill=26,26,26,255
PrevIconFill=208,208,208,255
PlayIconFill=208,208,208,255
NextIconFill=208,208,208,255
