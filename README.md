
# QUIZ MANIA

Welcome to QUIZ MANIA, a two-player quiz game developed in Assembly language. This game offers a series of true/false questions for a fun and competitive quiz experience.

## Game Structure

- **Initialization and Global Variables**: The program initializes at memory address 0x0100 and sets up the main control panel and global variables.
- **Questions and Answers**: A series of true/false questions are stored along with their corresponding answers.
- **Player Information**: Tracks each player's scores, lives, and answers.

## Gameplay Mechanics

- **Input Handling**: Players interact with the game by pressing keys to answer questions. The game responds accordingly to the input received.
- **Scoring System**: The game keeps track of each player's score and lives. Players' answers are checked against the correct answers, and scores are updated.
- **Win/Lose Conditions**: The game includes logic to determine the outcome based on players' scores and lives.

## User Interface

- **Screen Management**: Uses BIOS interrupt 0x10 services for displaying strings and managing the screen.
- **Subroutines**: Organized into specific tasks like displaying questions, checking answers, and showing players' lives.

## End Game

- **Determination of Winner**: The game concludes by determining the winner based on scores or other criteria.
- **Certificate Display**: There's a possibility of displaying a certificate for the winner.

## Termination

- The game terminates and exits using the appropriate system call.

## How to Play

- Start the game, and follow the on-screen instructions.
- Answer the true/false questions by pressing the designated keys.
- Keep track of your scores and lives displayed on the screen.
- Try to answer correctly to avoid losing lives and aim to get the highest score.

## Requirements

- An assembler that supports x86 assembly language.
- A system capable of running DOS-based assembly programs.

Thank you for playing QUIZ MANIA!
