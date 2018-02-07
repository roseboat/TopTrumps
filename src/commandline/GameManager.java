package commandline;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Scanner;

/**
 * Class responsible for organising flow of the game, in place of a dealer.
 */
public class GameManager {
	private Human humanPlayer;
	private Player activePlayer; //player whose turn it is 
	private Player winner; //winner of round
	private Player gameWinner; // winner of game
	private int numPlayers;
	private Deck deck;
	private ArrayList<Card> winnerPile = new ArrayList<Card>(); // stores cards that are 'in play'
	private static ArrayList<Player> players; // players stored in this
	private int numRounds;
	private int numDraws;
	private static Log myLog;
	private Database database; 
	private int[] playerWinCounts = new int[5]; // for storing player win counts
	private final String divider = "\r\n******************************************\r\n"; // for system.out formatting clarity

	/**
	 * Constructor
	 * 
	 * @param playerName
	 *            - name of user (given as default value)
	 * @param numberOfPlayers
	 *            - number of players (given as 5 for CLI version)
	 */
	public GameManager(String playerName, int numberOfPlayers) {
		this.numPlayers = numberOfPlayers;
		this.deck = new Deck();

		myLog = new Log();
		myLog.logDeck(deck);

		// deck is shuffled
		Collections.shuffle(deck.getDeck());
		myLog.logShuffle(deck);

		// cards are dealt
		Deck[] cards = deck.advancedSplit(this.numPlayers);
		humanPlayer = new Human(playerName, cards[0]);
		players = new ArrayList<Player>();
		players.add(humanPlayer);
		for (int i = 1; i < cards.length; i++) {
			players.add(new Computer("Computer " + i, cards[i]));
		}

		// write to log
		myLog.playerDecks(players);

		// player to start game randomised
		randomiseOrder();
		// round initiated
		initiateRound();
	}

	/**
	 * Core round loop. While loop keeps repeating code until only 1 player is
	 * remaining. See internal comments for description.
	 */
	public void initiateRound() {
		// check that two players are still in the game
		while (players.size() > 1) {

			for (int i = 0; i < players.size(); i++) {
				// checks to see if any players have run out of cards
				if (players.get(i).getDeckSize() < 1) {
					removePlayer(i);
					i--;
				}
				// all players draw their first card
				players.get(i).drawCard();
			}

			if (players.size() > 1) {

				// increment numRounds here
				numRounds++;
				// Displays round number
				System.out.println("Round number " + numRounds);

				// displays starting player's card
				activePlayer.promptUser();

				// first player selects the category for all players
				// index corresponds to the index of the value held in the cardValues array in
				// Card
				int index = activePlayer.chooseCategory();

				for (int i = 0; i < players.size(); i++) {
					// sets the value that each player has for the chosen category on their top card
					players.get(i).getHeldCard().setSelectedValue(index);
					// assigns the above value to each player
					players.get(i).setChosenCat(players.get(i).getHeldCard().getSelectedValue());

					// adds card to the winner's pile
					winnerPile.add(players.get(i).getHeldCard());

					// remove top cards from player's decks
					players.get(i).playerDeck.getDeck().remove(0);
				}

				myLog.cardsInPlay(winnerPile);

				decideWinner(index);

			} else
				endGame();
		}
	}

	/**
	 * Computes winner by comparing values.
	 * 
	 * @param index
	 *            - dictates the card category, and thus the value, that players
	 *            will be compared against.
	 */
	public void decideWinner(int index) {

		// log bit - could be put in log class
		String category = "";
		for (int i = 0; i < players.size(); i++) {
			// gets the category
			category = players.get(i).heldCard.getSelectedCategory(index);
		}
		myLog.categoryChosen(category, players);

		// cards in winner pile given to the winner of the round
		// winner pile resets
		Collections.sort(players, Collections.reverseOrder());
		winner = players.get(0);
		myLog.logRoundWinner(winner);

		if (players.get(0).compareTo(players.get(1)) == 0)
			drawHandler();
		else {
			// starting player of next round is the winner
			myLog.postRound(players);
			activePlayer = winner;
			winner.addToDeck(winnerPile);
			winnerPile.clear();
			System.out.println("The winner of this round is Player: " + winner.getName() + " who won with the "
					+ winner.heldCard.getName() + divider);

			// increment player wins count
			incrementPlayerWins();
		}
	}

	/**
	 * Handles draw situation, resets core game loop without providing a winner
	 */
	public void drawHandler() {

		myLog.communalPile(winnerPile);

		System.out.println("Round ended in a draw. The next round will be started." + divider);

		// increment drawCount
		numDraws++;

		// return to round loop
		initiateRound();
	}

	/**
	 * Handles end game functionality: resets round number, draw number, player win
	 * counts. Also saves game information to database.
	 */
	public void endGame() {
		gameWinner = players.get(0);
		myLog.logGameWinner(gameWinner);
		myLog.close();
		System.out.println(gameWinner.getName() + " has won the game!");

		// save game stats here
		saveGameStats();

		// reset database statistics
		numRounds = 0;
		numDraws = 0;
		for (int i = 0; i < playerWinCounts.length; i++)
			playerWinCounts[i] = 0;
	}

	/**
	 * Shuffles the player order, so random player takes first turn
	 */
	public void randomiseOrder() {
		Collections.shuffle(players);
		activePlayer = players.get(0);
	}

	/**
	 * Removes a player from the game
	 * 
	 * @param i
	 *            - index position of player to be reomved (in players arrayList)
	 */
	public void removePlayer(int i) {
		players.remove(i);
	}

	/**
	 * Increments player win counts
	 */
	public void incrementPlayerWins() {
		if (winner.getName().equals(humanPlayer.getName()))
			playerWinCounts[0]++;
		else if (winner.getName().equals("Computer 1"))
			playerWinCounts[1]++;
		else if (winner.getName().equals("Computer 2"))
			playerWinCounts[2]++;
		else if (winner.getName().equals("Computer 3"))
			playerWinCounts[3]++;
		else if (winner.getName().equals("Computer 4"))
			playerWinCounts[4]++;
	}

	/**
	 * Saves game statistics to database
	 */
	public void saveGameStats() {
		database = new Database();
		if (numPlayers == 2)
			database.gameStats(gameWinner.getName(), numRounds, numDraws, playerWinCounts[0], playerWinCounts[1]);
		else if (numPlayers == 3)
			database.gameStats(gameWinner.getName(), numRounds, numDraws, playerWinCounts[0], playerWinCounts[1],
					playerWinCounts[2]);
		else if (numPlayers == 4)
			database.gameStats(gameWinner.getName(), numRounds, numDraws, playerWinCounts[0], playerWinCounts[1],
					playerWinCounts[2], playerWinCounts[3]);
		else if (numPlayers == 4)
			database.gameStats(gameWinner.getName(), numRounds, numDraws, playerWinCounts[0], playerWinCounts[1],
					playerWinCounts[2], playerWinCounts[3]);
		else if (numPlayers == 5)
			database.gameStats(gameWinner.getName(), numRounds, numDraws, playerWinCounts[0], playerWinCounts[1],
					playerWinCounts[2], playerWinCounts[3], playerWinCounts[4]);
		database.closeConnection();
	}
}
