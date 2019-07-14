# The Open-Closed Game

## Test

```
mix test
```

## Build

```
mix escript.build
```

## Run

```
./open_closed
```

## Rules of the game
This game is played between two players.

One player will be the predictor.

To play the game, after a count of three, the players will need to simultaneously show their hands with each hand either open or closed, and the predictor need to shout out how many hands they think will be open on total.

If the predictor is correct, they win, otherwise the other player becomes the predictor and they go again. This continues until the game is won.

## The challenge
You need to create a program to play this game against the computer. This can just be a simple console application.

You will always be the predictor first.

The “AI” player will just do things randomly.

For each round, the computer will expect player input in the following format if you are the predictor:
`OC2`

Or if you are not:
`CO`

That is, the first two characters will show how you will play your hands, O for open or C for closed. If you are the predictor, you also need to enter a third character which is your prediction for how many open hands in total.

The program should then reveal the “AI” players input and indicate if the game was won, or move to the next round.

### Example of what game play could look like

```
Welcome to the game!
You are the predictor, what is your input? OO4
AI: CO
No winner.
AI is the predictor, what is your input? CC
AI: OO0
No winner.
You are the predictor, what is your input? CO3
AI: OO
You WIN!!
Do you want to play again? N
Ok, bye!
```
