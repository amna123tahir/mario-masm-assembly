INCLUDE Irvine32.inc
includelib WinMM.lib

PlaySoundA PROTO :PTR BYTE, :DWORD, :DWORD
.data

SCREEN_WIDTH  = 110     
SCREEN_HEIGHT = 28     

; level parameters
levelWidth     = 200               
viewWidth      = SCREEN_WIDTH      
viewHeight     = SCREEN_HEIGHT

; Mario state (world coordinates)
marioStartX    DWORD 5
marioX         DWORD ?
marioY         BYTE  (SCREEN_HEIGHT - 9) 
marioLives     DWORD 5                

; camera offset (world coordinate of leftmost column on screen)
cameraX        DWORD 0

; drawing characters (null-terminated strings so WriteString works)
charMario      BYTE "X",0
charCoin       BYTE "O",0
charGolden     BYTE "M",0
charPlatform   BYTE "=",0
charGround     BYTE "?",0
spc            BYTE " ",0
strLivesLabel  BYTE "LIVES: ",0
strWorldLabel  BYTE "WORLD 1-1",0

; number of platforms
numPlatforms   = 6
platformX      DWORD 10, 24, 48, 72, 130, 198
platformY      BYTE  (SCREEN_HEIGHT-12), (SCREEN_HEIGHT-14), (SCREEN_HEIGHT-16), (SCREEN_HEIGHT-12), (SCREEN_HEIGHT-18), (SCREEN_HEIGHT-14)
platformLen    DWORD 8, 6, 10, 5, 12, 7

; coins placed (world coords) - coins on ground and on platforms
numCoins       = 14
coinX          DWORD 6, 9, 12, 26, 30, 50, 55, 60, 74, 78, 133, 137, 140, 210
coinY          BYTE  (SCREEN_HEIGHT-9), (SCREEN_HEIGHT-9), (SCREEN_HEIGHT-9), (SCREEN_HEIGHT-15), (SCREEN_HEIGHT-15), (SCREEN_HEIGHT-17), (SCREEN_HEIGHT-17), (SCREEN_HEIGHT-17), (SCREEN_HEIGHT-13), (SCREEN_HEIGHT-13), (SCREEN_HEIGHT-19), (SCREEN_HEIGHT-19), (SCREEN_HEIGHT-19), (SCREEN_HEIGHT-9)

menuTitle   BYTE "================= MAIN MENU =================",0
opt1        BYTE "1. Play World 1-1",0
opt2        BYTE "2. Play World 1-2",0
opt3        BYTE "3. Play World 1-3",0
opt4        BYTE "4. Play World 1-4",0
opt5        BYTE "5. High Scores",0
opt6        BYTE "6. Sound Settings",0
opt7        BYTE "7. Instructions",0
opt8        BYTE "8. Exit Game",0
chooseOpt   BYTE "Select an option (1-8): ",0
; Clouds (white on light blue background)
cloud1 BYTE "     ???     ???     ",0
cloud2 BYTE "   ?????   ???????   ",0
cloud3 BYTE "     ????     ??      ",0

numClouds = 7
cloudX   DWORD 15, 60, 120, 200, 30, 90, 150    ; world X positions
cloudY   BYTE  3, 5, 4, 6, 3, 5, 6         ; heights for each cloud

; Ground (green ? on brown background)
groundLine BYTE "????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????",0

; Title Text
title1 BYTE "==============================================================",0
title2   BYTE "                       SUPER MARIO BROS                       ",0
title3   BYTE "                         ROLL NO: 0770                        ",0

pressEnter  BYTE "                  Press ENTER to continue...                  ",0
marioIsJumping BYTE 0
instrTitle      BYTE "----- GAME INSTRUCTIONS -----",0

inst1 BYTE "Use A and D to move left and right.",0
inst2 BYTE "Press W to jump. Move in air with A or D.",0
inst3 BYTE "Collect coins and avoid falling off platforms.",0
inst4 BYTE "Reach the end of the world to clear the level.",0
inst5 byte "Goto sound settings to mute or change sound"

pressAnyKeyInst BYTE "Press any key to return...",0
pauseTitle   BYTE "=== GAME PAUSED ===",0
pauseMsg     BYTE "Press SPACE to resume...",0

numHills = 3
hillX    DWORD 20, 50, 100
hillY    BYTE  (SCREEN_HEIGHT-14), (SCREEN_HEIGHT-14), (SCREEN_HEIGHT-14)
hill1 BYTE "     /\\     ",0
hill2 BYTE "    /  \\    ",0
hill3 BYTE "   /    \\   ",0
hill4 BYTE "  /      \\  ",0
hill5 BYTE " /        \\ ",0
hill6 BYTE "/__________\\",0
numPipes = 3
pipeX    DWORD 40, 110, 175
pipeY    BYTE  (SCREEN_HEIGHT-10), (SCREEN_HEIGHT-10), (SCREEN_HEIGHT-10)
pipeTop   BYTE "#######",0
pipeBody  BYTE "#     #",0
numBlocks = 6
blockX   DWORD 25, 27, 29, 140, 142, 144
blockY   BYTE  (SCREEN_HEIGHT-15),(SCREEN_HEIGHT-15),(SCREEN_HEIGHT-15),
               (SCREEN_HEIGHT-17),(SCREEN_HEIGHT-17),(SCREEN_HEIGHT-17)
blockChar BYTE "#",0
playerScore DWORD 0            ; your score storage

; HUD additions
scoreStr       BYTE "000000",0      ; 6-digit score
coinsStr       BYTE "00",0          ; 2-digit coin counter
timeStr        BYTE "040",0         ; 3-digit timer starting at 40
timeValue      DWORD 40             ; actual countdown value
lastTick       DWORD 0              ; stores last millisecond timestamp
timelabel Byte "TIMER:",0
poleHeight = 7

charPole BYTE "^",0
; SOUND SETTINGS
currentMusic DWORD 1        ; 1 = default track, 2 = track2, 3 = track3, 0 = muted

; file names (WAV)
bgm1 BYTE "music1.wav",0
bgm2 BYTE "music2.wav",0
bgm3 BYTE "music3.wav",0

optMusic1 BYTE "1. Use Music Track 1 (Default)",0
optMusic2 BYTE "2. Use Music Track 2",0
optMusic3 BYTE "3. Use Music Track 3",0
optMute   BYTE "4. Mute Background Music",0
soundPrompt BYTE "Select an option (1–4): ",0


scoreFile       BYTE "scores.txt",0

playerName      BYTE 21 DUP(0)
playerNameLen   DWORD ?

newline         BYTE 13,10,0     ; FIXED missing symbol error

MAX_SCORES      = 100

scoreNames      BYTE MAX_SCORES * 21 DUP(0)
scoreValues     DWORD MAX_SCORES DUP(0)
scoreCount      DWORD 0
tempBuffer      BYTE 64 DUP(0)
namePrompt BYTE "Enter your name: ",0
highscoretitle byte "                            HIGHSCORES: TOP 10                   ", 0

timeoutFlag BYTE 0
gameOverText   BYTE "GAME OVER",0
gameOverPrompt BYTE "Press ENTER to return...",0


goldenCollected BYTE 0     ; 0 = visible, 1 = taken
goldenX DWORD 48           ; world coordinate (you already use 48)
goldenY BYTE (SCREEN_HEIGHT - 10)

coinCollected BYTE numCoins DUP(0)   ; 0 = not taken, 1 = taken
playerCoins   DWORD 0

; --- SPIKES ---
numSpikes = 3

spikeX DWORD 35, 95, 160      ; world positions of each spike group
spikeY BYTE  (SCREEN_HEIGHT - 9), (SCREEN_HEIGHT - 9), (SCREEN_HEIGHT - 9)

; spike width = 3 spikes (^^^)
spikeWidth = 3

charSpike BYTE "^",0
offsetTable BYTE 0,1,2

; ======== GOOMBAS ========
numGoombas = 3

goombaX      DWORD 60, 120, 170     ; world positions
goombaY      BYTE  (SCREEN_HEIGHT - 9),
                 (SCREEN_HEIGHT - 9),
                 (SCREEN_HEIGHT - 9)

goombaDir    BYTE 1, -1, 1          ; 1 = moving right, -1 = moving left
goombaAlive  BYTE 1, 1, 1           ; 1 = alive, 0 = stomped

charGoomba BYTE "G",0

; ===== JUMP POWER-UP (J) =====
jumpPowerX DWORD 90          ; world location
jumpPowerY BYTE (SCREEN_HEIGHT - 10)
jumpPowerCollected BYTE 0    ; 0 = visible, 1 = taken
charJump BYTE "J",0

jumpBoostActive BYTE 0        ; 0 = normal, 1 = boosted jump




.code
main PROC
    call Clrscr
    call PlayBackgroundMusic
    call TitleScreen
    call MainMenu
    call ExitGame
main ENDP


ExitGame PROC
    exit
ExitGame ENDP

TitleScreen PROC

    ; ----------------------------------------------------------
    ; 1. Clear screen and set sky color (Light Blue background)
    ; ----------------------------------------------------------
    call Clrscr
    mov eax, blue + (lightBlue SHL 4)
    call SetTextColor

    ; ----------------------------------------------------------
    ; 3. TITLE TEXT (Black on light blue)
    ; ----------------------------------------------------------
    mov eax, black + (lightRed SHL 4)
    call SetTextColor

    mov dh, 10
    mov dl, (SCREEN_WIDTH/2 - 28)    ; <---- centered for 60-char title
    call Gotoxy
    mov edx, OFFSET title1
    call WriteString

    mov dh, 11
    mov dl, (SCREEN_WIDTH/2 - 28)
    call Gotoxy
    mov edx, OFFSET title2
    call WriteString

    mov dh, 12
    mov dl, (SCREEN_WIDTH/2 - 28)
    call Gotoxy
    mov edx, OFFSET title3
    call WriteString

    mov dh, 13
    mov dl, (SCREEN_WIDTH/2 - 28)
    call Gotoxy
    mov edx, OFFSET title1
    call WriteString

    ; ----------------------------------------------------------
    ; 4. PRESS ENTER MESSAGE (centered)
    ; ----------------------------------------------------------
    mov dh, 17
    mov dl, (SCREEN_WIDTH/2 - 28)
    call Gotoxy
    mov edx, OFFSET pressEnter
    call WriteString

    ; ----------------------------------------------------------
    ; 5. NES GROUND — 1 Green block row + 7 Brown dirt rows
    ; ----------------------------------------------------------
    mov eax, green + (brown SHL 4)
    call SetTextColor

    mov dh, SCREEN_HEIGHT - 8       ; <---- starts 8 rows from bottom
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET groundLine
    call WriteString

    mov eax, green + (brown SHL 4)
    call SetTextColor

    mov ecx, 7                      ; number of rows
DrawDirtLoop:
        mov eax, SCREEN_HEIGHT
        sub eax, ecx               ; eax = SCREEN_HEIGHT - ecx
        mov dh, al                 ; move low byte into dh

        mov dl, 0
        call Gotoxy
        mov edx, OFFSET groundLine
        call WriteString
    loop DrawDirtLoop

    ; ----------------------------------------------------------
    ; 6. WAIT FOR ENTER
    ; ----------------------------------------------------------
WaitEnter:
    mov eax, black + (lightBlue SHL 4)
    call SetTextColor
    call ReadChar
    cmp al, 0Dh        ; ENTER key
    jne WaitEnter

    ret
TitleScreen ENDP



; --------------------------------------------------------
; MAIN MENU
; --------------------------------------------------------
MainMenu PROC
MenuStart:
    call Clrscr

    mov edx, OFFSET menuTitle
    call WriteString
    call Crlf
    call Crlf

    mov edx, OFFSET opt1
    call WriteString
    call Crlf

    mov edx, OFFSET opt2
    call WriteString
    call Crlf

    mov edx, OFFSET opt3
    call WriteString
    call Crlf

    mov edx, OFFSET opt4
    call WriteString
    call Crlf

    mov edx, OFFSET opt5
    call WriteString
    call Crlf

    mov edx, OFFSET opt6
    call WriteString
    call Crlf

    mov edx, OFFSET opt7
    call WriteString
    call Crlf

    mov edx, OFFSET opt8
    call WriteString
    call Crlf
    call Crlf

    mov edx, OFFSET chooseOpt
    call WriteString

    call ReadChar

    cmp al, '1'
    je CallPW1
    cmp al, '2'
    je CallPW2
    cmp al, '3'
    je CallPW3
    cmp al, '4'
    je CallPW4
    cmp al, '5'
    je CallShowHS
    cmp al, '6'
    je CallSoundSettings
    cmp al, '7'
    je Instructions
    cmp al, '8'
    je ExitGameFromMenu

    jmp MenuStart

; call wrappers return to MenuStart
CallPW1:
    call PlayWorld1
    jmp MenuStart

CallPW2:
    call PlayWorld2
    jmp MenuStart

CallPW3:
    call PlayWorld3
    jmp MenuStart

CallPW4:
    call PlayWorld4
    jmp MenuStart
CallSoundSettings:
    call SoundSettings
    jmp MenuStart
CallShowHS:
    call ShowHighScores
    jmp MenuStart
PlayWorld2 PROC
    call Clrscr
    ; TODO: ADD YOUR LEVEL 1-2 GAMEPLAY HERE
    call WaitForAnyKey
    ret
PlayWorld2 ENDP

PlayWorld3 PROC
    call Clrscr
    ; TODO: ADD YOUR LEVEL 1-3 GAMEPLAY HERE
    call WaitForAnyKey
    ret
PlayWorld3 ENDP

PlayWorld4 PROC
    call Clrscr
    ; TODO: ADD YOUR LEVEL 1-4 GAMEPLAY HERE
    call WaitForAnyKey
    ret
PlayWorld4 ENDP

ShowHighScores PROC
    call Clrscr
    mov edx, OFFSET title1
    call WriteString
    call Crlf
    mov edx, OFFSET title2
    call WriteString
    call Crlf
    mov edx, OFFSET title3
    call WriteString
    call Crlf
    mov edx, offset highscoretitle
    call writestring
    call crlf
    call LoadScoresFromFile
    call SortScoresDescending
    call DisplayTop10Scores

    call WaitForAnyKey

    ret
ShowHighScores ENDP


SoundSettings PROC
    call Clrscr

    mov eax, black + (lightBlue SHL 4)
    call SetTextColor

    mov dh, 4
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET title2
    call WriteString

    ; menu
    mov dh, 8
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET optMusic1
    call WriteString

    mov dh, 10
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET optMusic2
    call WriteString

    mov dh, 12
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET optMusic3
    call WriteString

    mov dh, 14
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET optMute
    call WriteString

    mov dh, 17
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET soundPrompt
    call WriteString

    call ReadChar

    cmp al, '1'
    je Select1
    cmp al, '2'
    je Select2
    cmp al, '3'
    je Select3
    cmp al, '4'
    je SelectMute

    jmp SoundSettings

Select1:
    mov currentMusic, 1
    call PlayBackgroundMusic
    ret

Select2:
    mov currentMusic, 2
    call PlayBackgroundMusic
    ret

Select3:
    mov currentMusic, 3
    call PlayBackgroundMusic
    ret

SelectMute:
    mov currentMusic, 0
    call PlayBackgroundMusic
    ret

SoundSettings ENDP

Instructions:
    call Clrscr

    ; set sky-colored background
    mov eax, black + (lightBlue SHL 4)
    call SetTextColor

    ; ----------- CENTERED TITLE -----------
    mov dh, 4
    mov dl, (SCREEN_WIDTH/2 - 10)
    call Gotoxy
    mov edx, OFFSET instrTitle
    call WriteString


    ; ----------- INSTRUCTIONS LINES -----------
    mov dh, 7
    mov dl, (SCREEN_WIDTH/2 - 22)
    call Gotoxy
    mov edx, OFFSET inst1
    call WriteString

    mov dh, 9
    mov dl, (SCREEN_WIDTH/2 - 22)
    call Gotoxy
    mov edx, OFFSET inst2
    call WriteString

    mov dh, 11
    mov dl, (SCREEN_WIDTH/2 - 22)
    call Gotoxy
    mov edx, OFFSET inst3
    call WriteString

    mov dh, 13
    mov dl, (SCREEN_WIDTH/2 - 22)
    call Gotoxy
    mov edx, OFFSET inst4
    call WriteString

    mov dh, 15
    mov dl, (SCREEN_WIDTH/2 - 22)
    call Gotoxy
    mov edx, OFFSET inst5
    call WriteString

    ; ----------- PRESS ANY KEY -----------
    mov dh, 18
    mov dl, (SCREEN_WIDTH/2 - 16)
    call Gotoxy
    mov edx, OFFSET pressAnyKeyInst
    call WriteString

    ; wait and return to menu
    call ReadChar
    jmp MenuStart


ExitGameFromMenu:
    jmp ExitGame

MainMenu ENDP


; --------------------------------------------------------
; HELPER PROC – PAUSE UNTIL ANY KEY
; --------------------------------------------------------
WaitForAnyKey PROC
    mov edx, OFFSET pressEnter
    call WriteString
WaitLoop:
    call ReadChar
    ret
WaitForAnyKey ENDP


; ----------------------------
; PLAYWORLD1 + HELPERS (MERGED + FIXED)
; ----------------------------
; Controls: 'a' = left, 'd' = right, 'w' = jump, 'q' = quit to menu
; ----------------------------
UpdateTimer PROC

    ; Get current milliseconds
    call GetMseconds        ; EAX = current ms
    mov ebx, lastTick
    sub eax, ebx            ; elapsed = now - lastTick

    cmp eax, 1000           ; 1 second?
    jl NoTick               ; no ? done

    ; record new tick
    call GetMseconds
    mov lastTick, eax

    ; ----------------------------
    ; DECREASE TIMER
    ; ----------------------------
    mov eax, timeValue
    cmp eax, 0
    jle NoTick              ; stop at 0
    dec eax                 ; subtract 1 second
    mov timeValue, eax      ; store updated value

    ; ----------------------------
    ; CONVERT timeValue ? ASCII (timeStr "XYZ")
    ; eax still holds updated time
    ; ----------------------------

    mov ebx, 100
    xor edx, edx
    div ebx                 ; eax = hundreds, edx = remainder
    add al, '0'
    mov timeStr[0], al

    mov eax, edx            ; remainder
    mov ebx, 10
    xor edx, edx
    div ebx                 ; eax = tens, edx = ones
    add al, '0'
    mov timeStr[1], al

    add dl, '0'
    mov timeStr[2], dl
    mov eax, timeValue
    cmp eax, 0
    jne NoTimeout
    mov timeoutFlag, 1
NoTimeout:
NoTick:
    ret

    
UpdateTimer ENDP


PlayWorld1 PROC
    call Clrscr
    call PromptPlayerName
    call GetMseconds
    mov lastTick, eax
    ; initialize mario and camera
    mov eax, DWORD PTR [OFFSET marioStartX]
    mov [marioX], eax

    mov dword ptr [cameraX], 0
    mov dword ptr [marioLives], 5

MainLoop_Play1:
    call UpdateTimer
    call CheckGoldenCollision
    call CheckCoinCollision
    call CheckJumpPowerCollision
    call MoveGoombas
    call CheckGoombaCollision


    cmp timeoutFlag, 1
    je TimeUp_EndGame
    call DrawFrame_Play1

    ; blocking input
    call ReadChar
    cmp al, 'q'
    je PW1_End
    cmp al, ' '
    je DoPause
    cmp al, 'a'
    je PL_MoveLeft
    cmp al, 'd'
    je PL_MoveRight
    cmp al, 'w'
    je PL_DoJump
    jmp MainLoop_Play1
DoPause:
    call PauseGame
    jmp MainLoop_Play1
; --- inline Move Left ---
PL_MoveLeft:
    mov eax, [marioX]
    cmp eax, 0
    jle PL_AfterMove
    dec eax
    mov [marioX], eax
PL_AfterMove:
    call UpdateCamera1
    jmp MainLoop_Play1

; --- inline Move Right ---
PL_MoveRight:
    mov eax, [marioX]
    mov ebx, levelWidth
    dec ebx                    ; max index = levelWidth - 1
    cmp eax, ebx
    jge PL_AfterMoveR
    inc eax
    mov [marioX], eax
PL_AfterMoveR:
    call UpdateCamera1
    jmp MainLoop_Play1

PL_DoJump:
    ; mark jumping = true
    mov al, 1
    mov [marioIsJumping], al

    ; ----------------------------
    ; Smooth jump with air-control (3 up, 3 down)
    ; ----------------------------

    ; -------- JUMP UP (3 frames) --------
    ; NORMAL = 3 frames, POWER-UP = 6 frames
mov al, jumpBoostActive
cmp al, 1
jne NormalUp
mov ecx, 6
jmp StartUp
NormalUp:
mov ecx, 3
StartUp:

JumpUpLoop:

        ; lift 1 row
        movzx eax, [marioY]
        sub eax, 1
        mov [marioY], al

        ; ----- NON-BLOCKING INPUT (air control) -----
        mov eax, 0
        call ReadKey
        jz NoUpMove

        cmp al, 'a'
        je JumpMoveLeftUp
        cmp al, 'd'
        je JumpMoveRightUp
        jmp NoUpMove

JumpMoveLeftUp:
    mov esi, 3
JLU_Loop:
        mov eax, [marioX]
        cmp eax, 0
        jle JLU_End
        dec eax
        mov [marioX], eax
        dec esi
        jg JLU_Loop
JLU_End:
    jmp NoUpMove

JumpMoveRightUp:
    mov esi, 3
JRU_Loop:
        mov eax, [marioX]
        mov edx, levelWidth
        dec edx
        cmp eax, edx
        jge JRU_End
        inc eax
        mov [marioX], eax
        dec esi
        jg JRU_Loop
JRU_End:
    jmp NoUpMove

NoUpMove:

        ; --- NEW: Check mushroom collision during jump ---
        call CheckGoldenCollision

        ; redraw frame
        call DrawFrame_Play1
        call DelayShort

    loop JumpUpLoop


    ; -------- FALL DOWN (3 frames) --------
    ; NORMAL fall = 3, boosted = 6
mov al, jumpBoostActive
cmp al, 1
jne NormalDown
mov ecx, 6
jmp StartDown
NormalDown:
mov ecx, 3
StartDown:

JumpDownLoop:

        ; fall 1 row
        movzx eax, [marioY]
        add eax, 1
        mov [marioY], al

        ; ----- NON-BLOCKING INPUT (air control) -----
        mov eax, 0
        call ReadKey
        jz NoDownMove

        cmp al, 'a'
        je JumpMoveLeftDown
        cmp al, 'd'
        je JumpMoveRightDown
        jmp NoDownMove

JumpMoveLeftDown:
    mov esi, 3
JLD_Loop:
        mov eax, [marioX]
        cmp eax, 0
        jle JLD_End
        dec eax
        mov [marioX], eax
        dec esi
        jg JLD_Loop
JLD_End:
    jmp NoDownMove

JumpMoveRightDown:
    mov esi, 3
JRD_Loop:
        mov eax, [marioX]
        mov edx, levelWidth
        dec edx
        cmp eax, edx
        jge JRD_End
        inc eax
        mov [marioX], eax
        dec esi
        jg JRD_Loop
JRD_End:
    jmp NoDownMove

NoDownMove:

        ; --- NEW: Check mushroom collision during fall ---
        call CheckGoldenCollision

        ; redraw frame
        call DrawFrame_Play1
        call DelayShort

    loop JumpDownLoop


    ; landed: clear jumping flag and update camera once
    mov al, 0
    mov [marioIsJumping], al

    call UpdateCamera1
    jmp MainLoop_Play1




PW1_End:
TimeUp_EndGame:
    ; Save score before exiting
    call SaveScoreToFile

    ; Reset flag for next game
    mov timeoutFlag, 0

    ; Reset timer for next play
    mov timeValue, 40
    mov timeStr[0], '0'
    mov timeStr[1], '4'
    mov timeStr[2], '0'
    mov timeoutFlag, 0

    ; Show GAME OVER screen
    call GameOverScreen
    ret

    ; return to caller (MainMenu's CallPW1 wrapper will resume)
    ret
PlayWorld1 ENDP

; Camera update: center when Mario passes half the view
UpdateCamera1 PROC

    ; If Mario is jumping, do NOT update camera — keep current cameraX
    mov al, BYTE PTR [marioIsJumping]
    cmp al, 0
    jne UCam_SkipOnJump

    ; camera should follow Mario so he stays around screen center
    mov eax, [marioX]
    mov ebx, [cameraX]

    ; desired camera = marioX - (viewWidth/2)
    mov ecx, viewWidth
    shr ecx, 1                 ; viewWidth / 2
    sub eax, ecx               ; eax = target camera position

    ; clamp low end
    cmp eax, 0
    jl UCam_SetZero

    ; clamp high end
    mov edx, levelWidth
    sub edx, viewWidth
    cmp eax, edx
    jg UCam_SetMax

    ; store clamped value
    mov [cameraX], eax
    ret

UCam_SetZero:
    mov dword ptr [cameraX], 0
    ret

UCam_SetMax:
    mov [cameraX], edx
    ret

UCam_SkipOnJump:
    ; skip updating camera while in-air
    ret

UpdateCamera1 ENDP


; Draw frame: ground, platforms, coins, golden mushroom, mario, HUD
DrawFrame_Play1 PROC
    pushad

    call Clrscr

    ; sky color
    mov eax, black + (lightBlue SHL 4)
    call SetTextColor
    ; ====================== HUD ===========================

    ; White text on sky
    mov eax, black + (lightBlue SHL 4)
    call SetTextColor

    ; ----- MARIO (Label) -----
    mov dh, 0
    mov dl, 2
    call Gotoxy
    mov edx, OFFSET title2    ; uses your existing SUPER MARIO BROS title
    call WriteString

    ; ----- SCORE (000000) -----
    mov dh, 1
    mov dl, 2
    call Gotoxy
    mov edx, OFFSET scoreStr
    call WriteString

    ; ----- COINS x00 -----
    mov dh, 1
    mov dl, (SCREEN_WIDTH/2 - 3)
    call Gotoxy
    mov al, 'x'
    call WriteChar

    mov dh, 1
    mov dl, (SCREEN_WIDTH/2)
    call Gotoxy
    mov edx, OFFSET coinsStr
    call WriteString

    ; ----- WORLD 1-1 -----
    mov dh, 0
    mov dl, SCREEN_WIDTH - 12
    call Gotoxy
    mov edx, OFFSET strWorldLabel
    call WriteString

    ; ----- TIME -----
    mov dh, 1
    mov dl, SCREEN_WIDTH - 12
    call Gotoxy
    mov edx, OFFSET timelabel
    call WriteString

    mov dh, 1
    mov dl, SCREEN_WIDTH - 6
    call Gotoxy
    mov edx, OFFSET timeStr
    call WriteString

    ; ----- LIVES: MARIO × 5 -----
    mov dh, 2
    mov dl, 2
    call Gotoxy
    mov edx, OFFSET strLivesLabel
    call WriteString

    ; ----- LIVES DISPLAY -----
    mov dh, 2
    mov dl, 10
    call Gotoxy

    ; erase old char
    mov edx, OFFSET spc
    call WriteString

    mov dh, 2
    mov dl, 10
    call Gotoxy

    mov eax, marioLives
    add al, '0'
    call WriteChar


    ; Draw ground row across visible view
    mov eax, green + (lightGreen SHL 4)
    call SetTextColor
    mov dh, SCREEN_HEIGHT - 8

    mov ecx, viewWidth
    xor ebx, ebx            ; ebx will be column index (0..viewWidth-1)
   

GroundColsLoop:
    mov dl, bl              ; dl = low byte of ebx (safe as viewWidth <= 255)
    call Gotoxy
    mov edx, OFFSET charGround
    call WriteString

    inc ebx
    dec ecx
    jnz GroundColsLoop

    
; Draw coins
mov edi, 0
mov ecx, numCoins
CoinMainLoop:
    cmp edi, ecx
    jge CoinDone

    ; skip collected coins
    mov al, coinCollected[edi]
    cmp al, 1
    je CoinNext

    mov eax, coinX[edi*4]
    mov ebx, cameraX
    sub eax, ebx
    cmp eax, 0
    jl CoinNext
    cmp eax, viewWidth-1
    jg CoinNext

    mov dl, al
    mov dh, coinY[edi]

    mov eax, brown + (lightBlue SHL 4)
    call SetTextColor
    call Gotoxy
    mov edx, OFFSET charCoin
    call WriteString

CoinNext:
    inc edi
    jmp CoinMainLoop
CoinDone:

        ; ---- Draw golden mushroom if not collected ----
cmp goldenCollected, 1
je GoldenSkip1

mov eax, goldenX        ; world X
mov ebx, [cameraX]
sub eax, ebx            ; screenX

cmp eax, 0
jl GoldenSkip1
cmp eax, viewWidth-1
jg GoldenSkip1

mov dl, al              ; screen column
mov dh, goldenY         ; <<--- MUST be goldenY here
mov eax, brown + (lightBlue SHL 4)
call SetTextColor
call Gotoxy
mov edx, OFFSET charGolden
call WriteString

GoldenSkip1:
; ===== DRAW JUMP POWER-UP =====
cmp jumpPowerCollected, 1
je SkipJumpPU

mov eax, jumpPowerX
mov ebx, cameraX
sub eax, ebx

cmp eax, 0
jl SkipJumpPU
cmp eax, viewWidth - 1
jg SkipJumpPU

mov dl, al
mov dh, jumpPowerY
mov eax, yellow + (lightBlue SHL 4)
call SetTextColor
call Gotoxy
mov edx, OFFSET charJump
call WriteString

SkipJumpPU:

; ===================== DRAW SPIKES =====================
mov edi, 0
mov ecx, numSpikes

SpikeLoop:
    cmp edi, ecx
    jge SpikesDone

    mov eax, spikeX[edi*4]
    mov ebx, cameraX
    sub eax, ebx            ; screen X

    cmp eax, 0
    jl NextSpike
    cmp eax, viewWidth - 3
    jg NextSpike

    mov dh, spikeY[edi]     ; row of spikes

    mov esi, 0              ; spike index 0..2

DrawSpikeRow:
        mov dl, al          ; DL = base screenX
        add dl, byte ptr [offsetTable + esi]  

        call Gotoxy
        mov edx, OFFSET charSpike
        mov eax, red + (lightBlue SHL 4)
        call SetTextColor
        call WriteString

        inc esi
        cmp esi, 3
        jl DrawSpikeRow

NextSpike:
    inc edi
    jmp SpikeLoop

SpikesDone:

; ===================== DRAW GOOMBAS =====================
mov edi, 0
mov ecx, numGoombas

DrawGoombaLoop:
    cmp edi, ecx
    jge DoneGoombas

    ; skip dead goombas
    mov al, goombaAlive[edi]
    cmp al, 1
    jne GoombaNext

    ; convert worldX ? screenX
    mov eax, goombaX[edi*4]
    mov ebx, cameraX
    sub eax, ebx

    cmp eax, 0
    jl GoombaNext
    cmp eax, viewWidth-1
    jg GoombaNext

    mov dl, al
    mov dh, goombaY[edi]

    mov eax, red + (lightBlue SHL 4)
    call SetTextColor
    call Gotoxy

    mov edx, OFFSET charGoomba
    call WriteString

GoombaNext:
    inc edi
    jmp DrawGoombaLoop

DoneGoombas:

mov eax, white + (lightBlue SHL 4)
call SetTextColor
; ===================== DRAW GOAL POLE =====================
mov eax, levelWidth
dec eax                         ; worldX = levelWidth - 1 (rightmost)
mov ebx, [cameraX]
sub eax, ebx                    ; screenX = worldX - cameraX

cmp eax, 0
jl PoleDone
cmp eax, viewWidth-1
jg PoleDone

mov dl, al                      ; screen column

; ----- Draw the pole from bottom up -----

mov ecx, poleHeight             ; number of '^' characters
mov dh, SCREEN_HEIGHT - 9       ; ground level (same as Mario's default)

PoleLoop:
    call Gotoxy
    mov edx, OFFSET charMario   ; reuse "X"? Or do you want "^"?
    ; If you want "^" instead of X:
    ; replace the above line with:
    ; charPole BYTE "^",0   (put in .data)
    ; mov edx, OFFSET charPole

    mov eax, white + (lightBlue SHL 4)
    call SetTextColor
    call WriteString

    dec dh                      ; move up 1 row
    loop PoleLoop

PoleDone:

    ; ============ DRAW CLOUDS ============
mov edi, 0
mov ecx, numClouds

CloudLoop:
    cmp edi, ecx
    jge CloudsDone

    ; compute screenX = cloudX - cameraX
    mov eax, OFFSET cloudX
    mov eax, [eax + edi*4]
    mov ebx, [cameraX]
    sub eax, ebx

    cmp eax, 0
    jl CloudNext
    cmp eax, viewWidth-12
    jg CloudNext

    ; draw 3 cloud lines
    mov dh, BYTE PTR [OFFSET cloudY + edi]
    mov dl, al
    call Gotoxy
    mov edx, OFFSET cloud1
    call WriteString

    mov dh, BYTE PTR [OFFSET cloudY + edi]
    inc dh
    call Gotoxy
    mov edx, OFFSET cloud2
    call WriteString

    mov dh, BYTE PTR [OFFSET cloudY + edi]
    add dh, 2
    call Gotoxy
    mov edx, OFFSET cloud3
    call WriteString

CloudNext:
    inc edi
    jmp CloudLoop

CloudsDone:
mov eax, black + (lightBlue SHL 4)
call SetTextColor

; ============ DRAW HILLS ============
mov edi, 0
mov ecx, numHills

HillLoop:
    cmp edi, ecx
    jge HillsDone

    mov eax, OFFSET hillX
    mov eax, [eax + edi*4]
    mov ebx, [cameraX]
    sub eax, ebx

    cmp eax, 0
    jl HillNext
    cmp eax, viewWidth-13
    jg HillNext

    mov dl, al
    mov dh, BYTE PTR [OFFSET hillY + edi]

    ; each hill row
    call Gotoxy
    mov edx, OFFSET hill1
    call WriteString

    mov dh, BYTE PTR [OFFSET hillY + edi]
    inc dh
    mov dl, al
    call Gotoxy
    mov edx, OFFSET hill2
    call WriteString

    mov dh, BYTE PTR [OFFSET hillY + edi]
    add dh, 2
    mov dl, al
    call Gotoxy
    mov edx, OFFSET hill3
    call WriteString

    mov dh, BYTE PTR [OFFSET hillY + edi]
    add dh, 3
    mov dl, al
    call Gotoxy
    mov edx, OFFSET hill4
    call WriteString

    mov dh, BYTE PTR [OFFSET hillY + edi]
    add dh, 4
    mov dl, al
    call Gotoxy
    mov edx, OFFSET hill5
    call WriteString

    mov dh, BYTE PTR [OFFSET hillY + edi]
    add dh, 5
    mov dl, al
    call Gotoxy
    mov edx, OFFSET hill6
    call WriteString

HillNext:
    inc edi
    jmp HillLoop

HillsDone:
mov eax, black + (lightBlue SHL 4)
call SetTextColor

; ============ DRAW PIPES ============
mov edi, 0
mov ecx, numPipes

PipeLoop:
    cmp edi, ecx
    jge PipesDone

    mov eax, OFFSET pipeX
    mov eax, [eax + edi*4]
    mov ebx, [cameraX]
    sub eax, ebx

    cmp eax, 0
    jl PipeNext
    cmp eax, viewWidth-7
    jg PipeNext

    ; draw pipe top
    mov dl, al
    mov dh, BYTE PTR [OFFSET pipeY + edi]
    call Gotoxy
    mov edx, OFFSET pipeTop
    call WriteString

    ; draw pipe body (2 rows)
    mov dh, BYTE PTR [OFFSET pipeY + edi]
    inc dh
    mov dl, al
    call Gotoxy
    mov edx, OFFSET pipeBody
    call WriteString

    inc dh
    mov dl, al
    call Gotoxy
    mov edx, OFFSET pipeBody
    call WriteString

PipeNext:
    inc edi
    jmp PipeLoop

PipesDone:
; ============ DRAW BLOCKS ============
mov edi, 0
mov ecx, numBlocks

BlockLoop:
    cmp edi, ecx
    jge BlocksDone

    mov eax, OFFSET blockX
    mov eax, [eax + edi*4]
    mov ebx, [cameraX]
    sub eax, ebx

    cmp eax, 0
    jl BlockNext
    cmp eax, viewWidth-1
    jg BlockNext

    mov dl, al
    mov dh, BYTE PTR [OFFSET blockY + edi]
    call Gotoxy
    mov edx, OFFSET blockChar
    call WriteString

BlockNext:
    inc edi
    jmp BlockLoop

BlocksDone:


; ===================== DRAW PLATFORMS =====================
mov eax, green + (brown SHL 4)
call SetTextColor

mov edi, 0                     ; platform index
mov ecx, numPlatforms

PlatLoopMain:
    cmp edi, ecx
    jge PlatLoopDone

    ; -------- Load world X of platform --------
    mov eax, OFFSET platformX
    mov eax, [eax + edi*4]     ; worldStart

    ; -------- Compute worldEnd = worldStart + len - 1 --------
    mov esi, OFFSET platformLen
    mov ebx, [esi + edi*4]     ; len
    dec ebx
    add ebx, eax               ; ebx = worldEnd

    ; -------- Get camera bounds --------
    mov edx, [cameraX]         ; camLeft
    mov esi, edx
    add esi, viewWidth
    dec esi                    ; camRight = cameraX + viewWidth - 1

    ; -------- Visibility check (SAFE) --------
    cmp ebx, edx               ; if platformEnd < cameraLeft ? skip
    jl PlatNext

    cmp eax, esi               ; if platformStart > cameraRight ? skip
    jg PlatNext

    ; ========= At least part of platform is visible =========

    ; Convert worldStart ? screenStart = worldStart - cameraX
    sub eax, edx               ; eax = screenStart

    ; Load platform Y and length
    mov dl, BYTE PTR [OFFSET platformY + edi]  ; row
    mov dh, dl
    mov esi, OFFSET platformLen
    mov esi, [esi + edi*4]                     ; len

    ; Draw each tile of the platform
    mov ebx, 0                                 ; j counter

PlatDrawInnerLoop:
    cmp ebx, esi
    jge PlatNext

    ; screenX = screenStart + j
    mov edx, eax
    add edx, ebx

    cmp edx, 0
    jl SkipTile
    cmp edx, viewWidth-1
    jg SkipTile

    ; Draw tile at (row, screenX)
    mov dl, BYTE PTR [OFFSET platformY + edi]  ; row again
    mov dh, dl
    mov dl, al
    add dl, bl                                 ; dl = screenX

    call Gotoxy
    mov edx, OFFSET charPlatform
    call WriteString

SkipTile:
    inc ebx
    jmp PlatDrawInnerLoop

PlatNext:
    inc edi
    jmp PlatLoopMain

PlatLoopDone:

mov eax, yellow + (lightBlue SHL 4)
call SetTextColor
GoldenSkip:

    ; Draw Mario
    mov eax, [marioX]
    mov ebx, [cameraX]
    sub eax, ebx            ; screenX
    cmp eax, 0
    jl MarioSkip
    cmp eax, viewWidth-1
    jg MarioSkip
    mov dl, al
    mov dh, [marioY]
    mov eax, blue + (lightBlue SHL 4)
    call SetTextColor
    call Gotoxy
    mov edx, OFFSET charMario
    call WriteString

MarioSkip:

    ; restore text color
    mov eax, black + (lightBlue SHL 4)
    call SetTextColor

    popad
    ret
DrawFrame_Play1 ENDP

; small busy delay for jump visual
DelayShort PROC
    ; Delay ~100 ms (adjust if needed)
    mov eax, 100
    call Delay
    ret
DelayShort ENDP
PauseGame PROC
    ; Clear screen
    call Clrscr

    ; Blue background (same sky)
    mov eax, black + (lightBlue SHL 4)
    call SetTextColor

    ; Centered pause title
    mov dh, 10
    mov dl, (SCREEN_WIDTH/2 - 10)
    call Gotoxy
    mov edx, OFFSET pauseTitle
    call WriteString

    ; Centered resume message
    mov dh, 12
    mov dl, (SCREEN_WIDTH/2 - 15)
    call Gotoxy
    mov edx, OFFSET pauseMsg
    call WriteString

WaitResume:
    call ReadChar
    cmp al, ' '
    jne WaitResume   ; keep waiting for SPACE
    ret
PauseGame ENDP
PlayBackgroundMusic PROC

    cmp currentMusic, 0
    je StopMusic

    cmp currentMusic, 1
    je PlayTrack1
    cmp currentMusic, 2
    je PlayTrack2
    cmp currentMusic, 3
    je PlayTrack3
    jmp EndMusic

PlayTrack1:
    INVOKE PlaySoundA, OFFSET bgm1, NULL, 20009h   ; async + loop + filename
    jmp EndMusic

PlayTrack2:
    INVOKE PlaySoundA, OFFSET bgm2, NULL, 20009h
    jmp EndMusic

PlayTrack3:
    INVOKE PlaySoundA, OFFSET bgm3, NULL, 20009h
    jmp EndMusic

StopMusic:
    INVOKE PlaySoundA, NULL, NULL, 0
    jmp EndMusic

EndMusic:
    ret
PlayBackgroundMusic ENDP
PromptPlayerName PROC
    call Clrscr

    mov eax, black + (lightBlue SHL 4)
    call SetTextColor

    mov dh, 10
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET namePrompt
    call WriteString

    mov dh, 12
    mov dl, 20
    call Gotoxy

    mov edx, OFFSET playerName
    mov ecx, 20
    call ReadString        ; Irvine reads a full line

    ; store length
    mov edi, OFFSET playerName
    mov ecx, 0
CountLoop:
    cmp BYTE PTR[edi], 0
    je CountDone
    inc edi
    inc ecx
    jmp CountLoop
CountDone:
    mov playerNameLen, ecx

    ret
PromptPlayerName ENDP
SaveScoreToFile PROC
    ; open file for appending
    mov edx, OFFSET scoreFile
    call OpenInputFile       ; EAX = file handle
    mov ebx, eax

    ; write name
    mov edx, OFFSET playerName
    mov ecx, playerNameLen
    call WriteToFile

    ; space
    mov edx, OFFSET spc
    mov ecx, 1
    call WriteToFile

    ; score (6 digits)
    mov edx, OFFSET scoreStr
    mov ecx, 6
    call WriteToFile

    ; newline
    mov edx, OFFSET newline
    mov ecx, 2
    call WriteToFile

    call CloseFile
    ret
SaveScoreToFile ENDP
LoadScoresFromFile PROC

    mov scoreCount, 0

    mov edx, OFFSET scoreFile
    call OpenInputFile     ; eax = handle
    cmp eax, -1
    je NoScores
    mov ebx, eax

ReadLoop:
    mov edx, OFFSET tempBuffer
    mov ecx, 64
    call ReadFromFile
    cmp eax, 0
    jle DoneReading

    ; PARSE LINE: name + score
    ; find last space
    mov esi, OFFSET tempBuffer
FindTerminator:
    cmp BYTE PTR[esi], 0
    je StartBackward
    inc esi
    jmp FindTerminator

StartBackward:
    dec esi
FindSpace:
    cmp BYTE PTR[esi], ' '
    je FoundSpace
    dec esi
    jmp FindSpace

FoundSpace:
    ; copy SCORE digits
    mov edi, OFFSET scoreValues
    mov eax, scoreCount
    imul eax, 4
    add edi, eax

    mov ecx, 0
    mov eax, 0

ParseDigits:
    inc esi
    mov dl, [esi]
    cmp dl, 0
    je StoreScore
    sub dl, '0'
    imul eax, 10
    add eax, edx
    jmp ParseDigits

StoreScore:
    mov DWORD PTR[edi], eax

    ; copy NAME
    mov edi, OFFSET scoreNames
    mov eax, scoreCount
    imul eax, 21
    add edi, eax

    mov esi, OFFSET tempBuffer
CopyNameLoop:
    mov al, [esi]
    cmp al, ' '
    je NameDone
    mov [edi], al
    inc esi
    inc edi
    jmp CopyNameLoop

NameDone:
    inc scoreCount
    cmp scoreCount, MAX_SCORES
    jl ReadLoop

DoneReading:
    call CloseFile

NoScores:
    ret
LoadScoresFromFile ENDP
SortScoresDescending PROC

    mov ecx, scoreCount
    dec ecx
Outer:
    mov esi, 0
Inner:
    mov eax, scoreValues[esi*4]
    mov ebx, scoreValues[esi*4+4]

    cmp eax, ebx
    jge NoSwap

    mov scoreValues[esi*4], ebx
    mov scoreValues[esi*4+4], eax

    ; swap names (21 bytes)
    mov edi, OFFSET scoreNames
    mov edx, esi
    imul edx, 21
    add edi, edx
    mov ebx, edi
    add ebx, 21

    mov ebp, 21
SwapLoop:
    mov al, [edi]
    xchg al, [ebx]
    mov [edi], al
    inc edi
    inc ebx
    dec ebp
    jnz SwapLoop

NoSwap:
    inc esi
    mov eax, scoreCount
    dec eax
    cmp esi, eax
    jl Inner

    loop Outer
    ret
SortScoresDescending ENDP
DisplayTop10Scores PROC

    mov eax, black + (lightBlue SHL 4)
    call SetTextColor

    ; Print header
    mov dh, 2
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET title2
    call WriteString

    mov esi, 0        ; index
    mov ecx, 10       ; max entries

NextScore:
    cmp esi, scoreCount
    jge Done

    mov dh, 5
    mov ebx, esi
    add dh, bl        ; dh = 5 + index  (LEGAL!)

    mov dl, 5
    call Gotoxy

    ; print name
    mov edx, OFFSET scoreNames
    mov eax, esi
    imul eax, 21
    add edx, eax
    call WriteString

    mov edx, OFFSET spc
    call WriteString

    ; print score
    mov eax, scoreValues[esi*4]
    call WriteDec

    inc esi
    loop NextScore

Done:
    ret
DisplayTop10Scores ENDP
GameOverScreen PROC
    call Clrscr

    ; Sky background (light blue)
    mov eax, black + (lightBlue SHL 4)
    call SetTextColor

    ; ===== "GAME OVER" centered =====
    mov dh, 10
    mov dl, (SCREEN_WIDTH/2 - 5)
    call Gotoxy
    mov edx, OFFSET gameOverText
    call WriteString

    ; ===== "Press ENTER to return" =====
    mov dh, 14
    mov dl, (SCREEN_WIDTH/2 - 14)
    call Gotoxy
    mov edx, OFFSET gameOverPrompt
    call WriteString

WaitForEnter_GameOver:
    call ReadChar
    cmp al, 0Dh        ; ENTER key
    jne WaitForEnter_GameOver

    ret
GameOverScreen ENDP

CheckGoldenCollision PROC

    cmp goldenCollected, 1
    je NoGolden

    ; ---- Convert Mario screenX ? worldX ----
    mov eax, marioX                    ; world coordinate
    mov ebx, goldenX                   ; world coordinate
    cmp eax, ebx
    jne NoGolden

    ; ---- Y collision ----
    mov al, marioY
    cmp al, goldenY
    jne NoGolden

    ; ==== GOLDEN MUSHROOM PICKED ====
    mov goldenCollected, 1

    mov eax, playerScore
    add eax, 1000
    mov playerScore, eax

    call UpdateScoreString     ; <-- updates HUD string

NoGolden:
    ret
CheckGoldenCollision ENDP


UpdateScoreString PROC
    mov eax, playerScore
    mov ebx, 10
    mov edi, 5                ; fill scoreStr[5..0] from rightmost digit

ScoreLoop:
    xor edx, edx
    div ebx                   ; eax = value/10, edx = remainder
    add dl, '0'
    mov scoreStr[edi], dl
    dec edi
    cmp eax, 0
    jne ScoreLoop

FillZeros:
    cmp edi, -1
    jle DoneScore
    mov scoreStr[edi], '0'
    dec edi
    jmp FillZeros

DoneScore:
    ret
UpdateScoreString ENDP
CheckCoinCollision PROC

    mov edi, 0
    mov ecx, numCoins

CheckLoop:
    cmp edi, ecx
    jge DoneCoins

    ; Skip if already collected
    mov al, coinCollected[edi]
    cmp al, 1
    je NextCoin

    ; WORLD X check
    mov eax, coinX[edi*4]
    cmp eax, marioX
    jne NextCoin

    ; Y check
    mov al, coinY[edi]
    cmp al, marioY
    jne NextCoin

    ; ====== COLLECT COIN ======
    mov coinCollected[edi], 1

    ; +50 score
    mov eax, playerScore
    add eax, 200
    mov playerScore, eax
    call UpdateScoreString

    ; +1 coin counter
    mov eax, playerCoins
    inc eax
    mov playerCoins, eax
    call UpdateCoinsString

NextCoin:
    inc edi
    jmp CheckLoop

DoneCoins:
    ret
CheckCoinCollision ENDP

UpdateCoinsString PROC
    mov eax, playerCoins
    mov ebx, 10

    ; ones digit
    xor edx, edx
    div ebx
    add dl, '0'
    mov coinsStr[1], dl

    ; tens digit
    add al, '0'
    mov coinsStr[0], al

    ret
UpdateCoinsString ENDP
CheckSpikeCollision PROC

    mov edi, 0
    mov ecx, numSpikes

SpikeCheckLoop:
    cmp edi, ecx
    jge DoneSpikes

    ; base X of this spike group
    mov eax, spikeX[edi*4]
    mov ebx, marioX

    ; check 3 tiles: X, X+1, X+2
    cmp ebx, eax
    je SpikeYCheck

    mov edx, eax
    inc edx
    cmp ebx, edx
    je SpikeYCheck

    inc edx
    cmp ebx, edx
    jne NextSpike

SpikeYCheck:
    ; === Correct Y check ===
    mov al, marioY
    mov bl, spikeY[edi]
    cmp al, bl         ; SAME row ? hit!
    jne NextSpike

    ; === HIT! reduce life ===
    dec marioLives

    ; refresh HUD so lives update
    call DrawFrame_Play1

    cmp marioLives, 0
    jle SpikeGameOver

    jmp NextSpike

NextSpike:
    inc edi
    jmp SpikeCheckLoop

SpikeGameOver:
    mov timeoutFlag, 1
    ret

DoneSpikes:
    ret
CheckSpikeCollision ENDP

MoveGoombas PROC
    mov edi, 0
    mov ecx, numGoombas

NextMove:
    cmp edi, ecx
    jge DoneMove

    cmp goombaAlive[edi], 1
    jne SkipMove

    ; load X and direction
    mov eax, goombaX[edi*4]
    movsx ebx, goombaDir[edi]

    add eax, ebx          ; new X

    ; turn around at edges or platforms (simple bound logic)
    cmp eax, 0
    jl ReverseDir
    cmp eax, levelWidth-1
    jg ReverseDir

    mov goombaX[edi*4], eax
    jmp AfterMove

ReverseDir:
    neg ebx
    mov goombaDir[edi], bl

AfterMove:
SkipMove:
    inc edi
    jmp NextMove

DoneMove:
    ret
MoveGoombas ENDP
CheckGoombaCollision PROC
    mov edi, 0
    mov ecx, numGoombas

NextG:
    cmp edi, ecx
    jge DoneGoombaCheck

    cmp goombaAlive[edi], 1
    jne GNext

    ; compare X positions
    mov eax, goombaX[edi*4]
    mov ebx, marioX
    cmp eax, ebx
    jne GNext

    ; ---- check stomp: Mario is 1 row above ----
    mov al, marioY
    mov bl, goombaY[edi]
    dec bl
    cmp al, bl
    je Stomped

    ; ---- side collision ? lose life ----
    dec marioLives
    cmp marioLives, 0
    jle GoombaGameOver
    jmp GNext

Stomped:
    mov goombaAlive[edi], 0     ; kill goomba

    mov eax, playerScore
    add eax, 200               ; reward for stomp
    mov playerScore, eax
    call UpdateScoreString
    jmp GNext

GoombaGameOver:
    mov timeoutFlag, 1
    jmp DoneGoombaCheck

GNext:
    inc edi
    jmp NextG

DoneGoombaCheck:
    ret
CheckGoombaCollision ENDP

CheckJumpPowerCollision PROC

    cmp jumpPowerCollected, 1
    je NoHit

    ; X match
    mov eax, jumpPowerX
    cmp eax, marioX
    jne NoHit

    ; Y match
    mov al, marioY
    cmp al, jumpPowerY
    jne NoHit

    ; ===== POWER-UP COLLECTED =====
    mov jumpPowerCollected, 1
    mov jumpBoostActive, 1     ; enable high jump

    ; reward points if you want
    mov eax, playerScore
    add eax, 300
    mov playerScore, eax
    call UpdateScoreString

NoHit:
    ret
CheckJumpPowerCollision ENDP

END main
