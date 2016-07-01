main:
#initialize
lui $t8,0xD00F
sw $zero,0($t8)
addi $s4,$zero,5
#reset all the argument
#let verilog do
j MAINLOOP

delay:
add $t9,$zero,$zero
lui $t9,0x000E
add $t8,$zero,$zero
dloop:
addi $t8, $t8, 1
bne $t9, $t8, dloop   #loop to delay,t9,t8 saved to it
jr $ra

#---------------delay done-------#

RESTART:
lui $t8,0xD00A
lw $t9,0($t8)
#get blood
lui $t8,0xD00F
sw $zero,0($t8)
#reset all the argument
#let verilog do
lui $t8,0xD00A
addi $t9,$t9,-1#----------------------------------------------------------------------------------------
sw $t9,0($t8)
#reset blood
beq $t9,$zero,GAMEOVER#----------------------------------------------------------------------------------------
#if blood==0 then GAMEOVER
addi $s4,$zero,5

MAINLOOP:
jal delay#----------------------------------------------------------------------------------------------------
lui $t8,0xD006
lw $t7, 0($t8)
#get Boom
beq $t7,$zero,NO_HURT
#if boom==0, then no hurt, continue
#-------------------BOOM AND TEST KILL!!------------#
lui $t8,0xD00E
sw $zero, 0($t8)
#set Bomb_EN=0
lui $t8,0xD006
sw $zero, 0($t8)
#set Boom=0
lui $t8,0xD007
lw $t0, 0($t8)
lui $t8,0xD008
lw $t1,0($t8)
#get Bomb_x and Bomb_y
lui $t8,0xD001
lw $t2, 0($t8)
lui $t8,0xD002
lw $t3,0($t8)
#get Man_x and Man_y
beq $t0,$t2,MAN_TESTY0
#x1=x2 means y1=y2-1 or y1=y2+1 or y1=y2
addi $t8,$t0,-1
beq $t8,$t2,MAN_TESTY1
#x1-1=x2 means y1=y2
addi $t8,$t0,1
beq $t8,$t2,MAN_TESTY1
#x1+1=x2 means y1=y2
j TEST_BOMB_MOSTER

MAN_TESTY0:
beq $t1, $t3, RESTART
#y1=t2
addi $t8,$t1,-1
beq $t8,$t3,RESTART
#y1=y2-1
addi $t8,$t1,1
beq $t8,$t3,RESTART
#y1=y2+1
j TEST_BOMB_MOSTER

MAN_TESTY1:
beq $t1, $t3, RESTART
j TEST_BOMB_MOSTER
#--------------------test man killed over

TEST_BOMB_MOSTER:
lui $t8,0xD004
lw $t2, 0($t8)
lui $t8,0xD005
lw $t3,0($t8)
#get Monster_x and Monster_y
beq $t0,$t2,MOSTER_TESTY0
#x1=x2 means y1=y2-1 or y1=y2+1 or y1=y2
addi $t8,$t0,-1
beq $t8,$t2,MOSTER_TESTY1
#x1-1=x2 means y1=y2
addi $t8,$t0,1
beq $t8,$t2,MOSTER_TESTY1
#x1+1=x2 means y1=y2
j NO_HURT

WIN:
lui $t8,0xD00C
addi $t7,$zero,1
sw $t7,0($t8)
#set win=1
loop:
j loop
#deadless loop

MOSTER_TESTY0:
beq $t1, $t3,WIN
#y1=t2
addi $t8,$t1,-1
beq $t8,$t3,WIN
#y1=y2-1
addi $t8,$t1,1
beq $t8,$t3,WIN
#y1=y2+1
j NO_HURT

MOSTER_TESTY1:
beq $t1, $t3,WIN
j NO_HURT
#--------------------test man killed over
#-------------------BOOM AND TEST KILL!!------------#

NO_HURT:
#if no boom or boom is no hurt
add $t5, $zero, $zero
lui $t5,0xF000
lw $t4, 0($t5)
#get Input of BTN and SW and save the t4 for it
lui $t0,0xD00E
lw $t1,0($t0)   #Bomb_EN state -- t1
#get Bomb_EN
bne $t1, $zero,COUNT_MINUS
#if Bomb_EN==1,then it's no matter 
#whether the button is pressed or not
addi $t3,$zero,0x4000
#to get 0x00008000,andi will get 0xffff8000
and $t3,$t4,$t3
beq $t3,$zero,BOMB_STATE_EXIT
#get SWITCH 0 state -- t3
#if Bomb_EN==0 and SW0 == 0 , noting to do
addi $t5,$zero,1
lui $t0,0xD00E
sw $t5,0($t0)
#set Bomb_EN=1
addi $t8,$zero,1
lui $t0,0xD007
sw $t8,0($t0)
#set BOMB_X=MAN_X,BOMB_Y=MAN_Y
j BOMB_STATE_EXIT
#------------------------test bomb----------#

COUNT_MINUS:
addi $s4,$s4,-1
#count-=1
bne $s4, $zero, BOMB_STATE_EXIT
#if not zero,it means we should continue to count--
#----------BOMB!!!
#else it means boom !!!!!!!!!!
addi $s4,$zero,5
#set count=5
lui $t8,0xD007
lw $t0, 0($t8)
lui $t8,0xD008
lw $t1,0($t8)
#get Bomb_x and Bomb_y
add $t8,$zero,$zero
#set t8=0
addi $a0,$t0,-1
addi $a1,$t1,0
jal getFire
add $t8,$t8,$v0
#x-1,y position   left
addi $a0,$t0,0
addi $a1,$t1,-1
jal getFire
sll $t8,$t8,1
add $t8,$t8,$v0
#x-1,y position   up
addi $a0,$t0,1
addi $a1,$t1,0
jal getFire
sll $t8,$t8,1
add $t8,$t8,$v0
#x-1,y position   right
addi $a0,$t0,0
addi $a1,$t1,1
jal getFire
sll $t8,$t8,1
add $t8,$t8,$v0
#x-1,y position   down
lui $t0,0xD009
addi $t8,$zero,0
sw $t8,0($t0)
#set fire info
addi $t7,$zero,1
lui $t8,0xD006
sw $t7, 0($t8)
#set Boom=1
lui $t8,0xD00E
sw $zero, 0($t8)
#set Bomb_EN=0
#then wait for the next cycle

#--------------MAN MOVE START---------------#

BOMB_STATE_EXIT:
#start to move man
add $a0, $zero, $zero
lui $s0,0xD001
lui $s1,0xD002  #MAN MOVE
add $t8,$zero,$zero
lui $t8,0x0001
and $s3,$t4,$t8   #The 17th bit
#get the BTN0 by 0000000000010000000... with $t4
bne $s3,$zero,GOTOMOVE_MAN
#BTN1
addi $a0,$a0,1
add $t8,$zero,$zero
lui $t8,0x0002
#left move one by one
and $s3,$t4,$t8
bne $s3,$zero,GOTOMOVE_MAN
#BTN2
addi $a0,$a0,1
add $t8,$zero,$zero
lui $t8,0x0004
and $s3,$t4,$t8
bne $s3,$zero,GOTOMOVE_MAN
#BTN3
addi $a0,$a0,1
add $t8,$zero,$zero
lui $t8,0x0008
and $s3,$t4,$t8
bne $s3,$zero,GOTOMOVE_MAN

#-------------------------------Man move --------------#

MAIN_MAN_MOVE_DONE:
#go on ,then monster should move on
jal Random
add $a0,$zero,$v0
#get a random direction and move 
lui $s0,0xD004
lui $s1,0xD005  #MONSTER MOVE
jal MM_Move
#Test again if the man is on the same position with monster
lui $s0,0xD001
lui $s1,0xD002  #MAN position
lw $s2,0($s0)
lw $s3,0($s1)
bne $t7, $s2, NOT_EQUAL_AFTER_MONSTER_MOVE
bne $t6, $s3, NOT_EQUAL_AFTER_MONSTER_MOVE
j RESTART

#-------------------------------Monster move --------------#

GOTOMOVE_MAN:
jal MM_Move
#save the next inst address to $ra
#Test if the man is on the same position with monster
lui $s0,0xD004
lui $s1,0xD005  #MONSTER position
lw $s2,0($s0)
lw $s3,0($s1)
bne $t7, $s2, MAIN_MAN_MOVE_DONE
bne $t6, $s3, MAIN_MAN_MOVE_DONE
j RESTART
#we should be back if not equal


NOT_EQUAL_AFTER_MONSTER_MOVE:
#...
j MAINLOOP


#-------------- main -----------#

MM_Move:     #t6,t7 for man's position
lw $t7, 0($s0)    #READ MAN_X from VRAM
lw $t6, 0($s1)    #READ MAN_Y from VRAM
beq $a0, $zero, MX_ADD_ONE
addi $t8, $zero, 1
beq $a0, $t8, MX_SUB_ONE
addi $t8, $zero, 2
beq $a0, $t8, MY_ADD_ONE
addi $t8, $zero, 3
beq $a0, $t8, MY_SUB_ONE
j MMEXIT

MMOVE_DONE:
addi $s7,$zero,4
addi $s6,$zero,60   #Loops to Calculate x*60+y*4
add $s5, $zero, $zero
add $t8, $t6, $zero  #y
Inner_Loop:
beq $t8, $zero, ITEXIT
add $s5, $s5, $s7   #s5+=4
addi $t8,$t8,-1
j Inner_Loop
ITEXIT:

add $t8, $t7, $zero  #x
Outer_Loop:
beq $t8, $zero, OTEXIT
add $s5, $s5, $s6
addi $t8,$t8,-1
j Outer_Loop

OTEXIT:
addi $t0,$zero,0x0A20
add $t0,$s5,$t0 #x*60+y*4+ 0x0F000000
lw $s5,0($t0)
#get if it is wall or not
bne $s5, $zero, RECOVER
#0 means there are no walls
sw $t7, 0($s0)    #MAN_X to VRAM
sw $t6, 0($s1)    #MAN_Y to VRAM
RECOVER:
lw $t7, 0($s0)    #MAN_X to VRAM
lw $t6, 0($s1)    #MAN_Y to VRAM
MMEXIT:
jr $ra  #back

MX_ADD_ONE:
addi $t8, $zero, 14  #If X=18,X can't be bigger
beq $t7,$t8,MMEXIT
addi $t7,$t7,1
j MMOVE_DONE

MY_ADD_ONE:
addi $t8, $zero, 13  #If Y=13,X can't be bigger
beq $t6,$t8,MMEXIT
addi $t6,$t6,1
j MMOVE_DONE

MX_SUB_ONE:
addi $t8, $zero, 1  #If X<1,X can't be smaller
beq $t7,$t8,MMEXIT
addi $t7,$t7,-1
j MMOVE_DONE

MY_SUB_ONE:
addi $t8, $zero, 1  #If X>20,X can't be bigger
beq $t6,$t8,MMEXIT
addi $t6,$t6,-1
j MMOVE_DONE

#------------------ move ok --------------------

Random:
addi $v0,$zero,0x7FA3
addi $t8,$zero,0x0A00 #the first data
lw $t7, 0($t8)
xor $v0,$t7,$v0
sw $v0, 0($t8)
lw $t7, 4($t8)
xor $v0,$t7,$v0
sw $v0, 4($t8)
lw $t7, 8($t8)
xor $v0,$t7,$v0
sw $v0, 8($t8)
andi $v0,$v0,3
jr $ra

#------------------ random ok --------------------

GAMEOVER:
addi $t1,$zero,1
lui $t2,0xD00D
sw $t1, 0($t2)
Gloop:
j Gloop

#------------------ GAMEOVER --------------------

getFire:
addi $s7,$zero,4
addi $s6,$zero,60   #Loops to Calculate x*60+y*4
add $s5, $zero, $zero
add $t8, $a1, $zero  #y
GFInner_Loop:
beq $t8, $zero, GFITEXIT
add $s5, $s5, $s7   #s5+=4
addi $t8,$t8,-1
j GFInner_Loop
GFITEXIT:

add $t8, $a0, $zero  #x
GFOuter_Loop:
beq $t8, $zero, GFOTEXIT
add $s5, $s5, $s6
addi $t8,$t8,-1
j GFOuter_Loop

GFOTEXIT:
addi $t8,$zero,0x0A20
add $t8,$s5,$t8 #x*60+y*4+ 0x0F000000
lw $v0,0($t8)
#get if it is wall or not, and return to v0
jr $ra
#----------------------------getFire---------------#


.data 0x0A00
.word 0x1C7BCBE5
.word 0xCBE5587D
.word 0x86AA78D0
.word 0x11570C33

.data 0x0A20
#x=0
.word 0x00000001,0x00000001,0x00000001,0x00000001,0x00000001,0x00000001,0x00000001,0x00000001,0x00000001,0x00000001
.word 0x00000001,0x00000001,0x00000001,0x00000001,0x00000001
#x=1
.word 0x00000001,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000
.word 0x00000000,0x00000000,0x00000000,0x00000000,0x00000001
#x=2
.word 0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000
.word 0x00000001,0x00000000,0x00000001,0x00000000,0x00000001
#x=3
.word 0x00000001,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000
.word 0x00000000,0x00000000,0x00000000,0x00000000,0x00000001
#x=4
.word 0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000
.word 0x00000001,0x00000000,0x00000001,0x00000000,0x00000001
#x=5
.word 0x00000001,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000
.word 0x00000000,0x00000000,0x00000000,0x00000000,0x00000001
#x=6
.word 0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000
.word 0x00000001,0x00000000,0x00000001,0x00000000,0x00000001
#x=7
.word 0x00000001,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000
.word 0x00000000,0x00000000,0x00000000,0x00000000,0x00000001
#x=8
.word 0x00000001,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000
.word 0x00000000,0x00000000,0x00000000,0x00000000,0x00000001
#x=9
.word 0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000
.word 0x00000001,0x00000000,0x00000001,0x00000000,0x00000001
#x=10
.word 0x00000001,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000
.word 0x00000000,0x00000000,0x00000000,0x00000000,0x00000001
#x=11
.word 0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000
.word 0x00000001,0x00000000,0x00000001,0x00000000,0x00000001
#x=12
.word 0x00000001,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000
.word 0x00000000,0x00000000,0x00000000,0x00000000,0x00000001
#x=13
.word 0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000,0x00000001,0x00000000
.word 0x00000001,0x00000000,0x00000001,0x00000000,0x00000001
#x=14
.word 0x00000001,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000
.word 0x00000000,0x00000000,0x00000000,0x00000000,0x00000001
#x=15
.word 0x00000001,0x00000001,0x00000001,0x00000001,0x00000001,0x00000001,0x00000001,0x00000001,0x00000001,0x00000001
.word 0x00000001,0x00000001,0x00000001,0x00000001,0x00000001