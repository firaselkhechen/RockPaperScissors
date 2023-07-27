#Gabriel Kirakossian (ID: 20212381)
#Firas El Kheshen (ID: 20214046)
#Jean-marie Mattar (ID: 20212816)

#Rock Paper Scissors Game

.data
    prompt: .asciiz "\nEnter 1 for Rock, 2 for Paper, 3 for Scissors: "  # Prompt message for user input
    round: .word 0  # Variable to store the current round count
    maxRounds: .word 5  # Maximum number of rounds in the game
    maxScore: .word 3  # Maximum score to win the game
    userScore: .word 0  # Variable to store the user's score
    compScore: .word 0  # Variable to store the computer's score
    userScoreMsg: .asciiz "\nYour score: "  # Message to display the user's score
    compScoreMsg: .asciiz "\nComputer's score: "  # Message to display the computer's score
    tieMsg: .asciiz "\nIt's a tie!\n"  # Message for a tie round
    userWinMsg: .asciiz "\nYou win this round!\n"  # Message for when the user wins a round
    compWinMsg: .asciiz "\nComputer wins this round!\n"  # Message for when the computer wins a round
    gameOverMsg: .asciiz "\nGame Over\n"  # Message for the end of the game
    userOverallWinMsg: .asciiz "\nYou win the game!\n"  # Message for when the user wins the game
    compOverallWinMsg: .asciiz "\nComputer wins the game!\n"  # Message for when the computer wins the game

.text
.globl main
main:
    # Load maximum rounds and score into registers
    lw $t4, maxRounds  # Load the maximum number of rounds
    lw $t5, maxScore  # Load the maximum score to win the game

round_loop:
    # Increment round count
    lw $t3, round  # Load the current round count
    addiu $t3, $t3, 1  # Increment the round count by 1
    sw $t3, round  # Store the updated round count

    # Get user's move
    li $v0, 4  # System call code for printing string
    la $a0, prompt  # Load the prompt message
    syscall  # Print the prompt message
    li $v0, 5  # System call code for reading integer
    syscall  # Read user input
    move $t0, $v0  # Store user's move in $t0

    # Generate computer's move
    li $a1, 3  # Maximum number for randomization
    li $v0, 42  # System call code for generating random number
    syscall  # Generate random number
    addiu $t1, $a0, 1  # Store the computer's move in $t1

    # Check who won
    beq $t0, $t1, tie  # If user's move and computer's move are the same, it's a tie
    beq $t0, 1, user_chose_rock  # If user chose rock
    beq $t0, 2, user_chose_paper  # If user chose paper
    beq $t0, 3, user_chose_scissors  # If user chose scissors

    # If it's a tie
tie:
     li $v0, 4  # System call code for printing string
    la $a0, tieMsg  # Load the tie message
    syscall  # Print the tie message
    j end_round  # Jump to the end of the current round

user_chose_rock:
    beq $t1, 2, comp_wins  # If computer chose paper, computer wins
    j user_wins  # Otherwise, user wins

user_chose_paper:
    beq $t1, 3, comp_wins  # If computer chose scissors, computer wins
    j user_wins  # Otherwise, user wins

user_chose_scissors:
    beq $t1, 1, comp_wins  # If computer chose rock, computer wins
    j user_wins  # Otherwise, user wins

user_wins:
    li $v0, 4  # System call code for printing string
    la $a0, userWinMsg  # Load the user win message
    syscall  # Print the user win message
    lw $t2, userScore  # Load the user's score
    addiu $t2, $t2, 1  # Increment the user's score by 1
    sw $t2, userScore  # Store the updated user's score
    j end_round  # Jump to the end of the current round

comp_wins:
    li $v0, 4  # System call code for printing string
    la $a0, compWinMsg  # Load the computer win message
    syscall  # Print the computer win message
    lw $t2, compScore  # Load the computer's score
    addiu $t2, $t2, 1  # Increment the computer's score by 1
    sw $t2, compScore  # Store the updated computer's score

end_round:
    # Print user's score
    li $v0, 4  # System call code for printing string
    la $a0, userScoreMsg  # Load the user score message
    syscall  # Print the user score message
    lw $a0, userScore  # Load the user's score
    li $v0, 1  # System call code for printing integer
    syscall  # Print the user's score

    # Print computer's score
    li $v0, 4  # System call code for printing string
    la $a0, compScoreMsg  # Load the computer score message
    syscall  # Print the computer score message
    lw $a0, compScore  # Load the computer's score
    li $v0, 1  # System call code for printing integer
    syscall  # Print the computer's score

    # Check if the game is over
    lw $t2, userScore  # Load the user's score
    lw $t3, compScore  # Load the computer's score
    beq $t2, $t5, user_wins_game  # If user's score reaches the maximum score, user wins the game
    beq $t3, $t5, comp_wins_game  # If computer's score reaches the maximum score, computer wins the game
    lw $t1, round  # Load the current round count
    beq $t1, $t4, end_game  # If current round count reaches the maximum rounds, end the game
    j round_loop  # Jump back to the beginning of the round loop

user_wins_game:
    li $v0, 4  # System call code for printing string
    la $a0, userOverallWinMsg  # Load the user overall win message
    syscall  # Print the user overall win message
    j end_game  # Jump to the end of the game

comp_wins_game:
    li $v0, 4  # System call code for printing string
    la $a0, compOverallWinMsg  # Load the computer overall win message
    syscall  # Print the computer overall win message
    j end_game  # Jump to the end of the game

end_game:
    li $v0, 4  # System call code for printing string
    la $a0, gameOverMsg  # Load the game over message
    syscall  # Print the game over message

    # Exit the program
    li $v0, 10  # System call code for program exit
    syscall  # Exit the program
