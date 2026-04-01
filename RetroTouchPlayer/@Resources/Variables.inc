[Variables]
PlayerPlugin=MediaPlayer
PlayerName=Default
PlayingDotAlpha=200

DisplayFont=CozetteVector
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

; Track title: centered on bottom overlay row (ScreenMask coords; matches reference-website)
TitleAreaX=156
TitleAreaY=170
TitleAreaWidth=288

; Bottom overlay row: tighter to progress bar (less bottom padding than reference 14px)
InfoY=184
ElapsedX=26
; Status text (PAUSED/STANDBY): aligns with clock row; record dot uses RecordDot* below
StatusTopY=42
ClockX=314
; Record dot: inset from screen top-right (larger = further from corner, toward center)
RecordDotInsetX=24
RecordDotInsetY=22
RecordDotSize=10

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
; Normal: inset 0 1px 2px rgba(255,255,255,.05) — top edge + softer side spread from blur
ButtonHighlightEdge=255,255,255,13
ButtonHighlightSide=255,255,255,7
; Pressed: inset 0 2px 4px rgba(0,0,0,.3) — dark shadow flips the highlight
ButtonPressedEdge=0,0,0,77
ButtonPressedSide=0,0,0,38

ButtonPressedFill=20,20,20,255
IconPressedColor=182,182,182,255
PrevBtnFill=26,26,26,255
PlayBtnFill=26,26,26,255
NextBtnFill=26,26,26,255
PrevIconFill=208,208,208,255
PlayIconFill=208,208,208,255
NextIconFill=208,208,208,255
PrevEdgeColor=255,255,255,13
PrevSideColor=255,255,255,7
PlayEdgeColor=255,255,255,13
PlaySideColor=255,255,255,7
NextEdgeColor=255,255,255,13
NextSideColor=255,255,255,7
