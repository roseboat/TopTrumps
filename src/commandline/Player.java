package commandline;

import java.util.ArrayList;

public abstract class Player {

	protected Deck playerDeck;
	private String name;
	protected Card topCard;
	protected int choice;
	
	// not sure how players are assigned decks
	public Player(String name, Deck playerDeck) {
		this.name = name;
		this.playerDeck = playerDeck;

	}

	}
	
	public Card drawCard() {
		
		ArrayList<Card> deckArray=playerDeck.getCards();
		// player draws card whilst there are still cards in deck
		while (playerDeck.getDeckSize()>0) {
			// top card represented by the index 0 in Deck arraylist
			// top card is removed from Deck
			this.topCard= deckArray.get(0);
			deckArray.remove(0);
		
			// returns the top card of player's deck
			return topCard;
		}
		return null;
		// I'll try think of a better solution since dealing with null is just...
	}

	
	
	public abstract int chooseCategory();
	
	public void addToDeck(boolean win, Deck winnerPile) {
		if (win = true) {
			
			ArrayList<Card> winnerP = winnerPile.getCards();
			playerDeck.addCards(winnerP);

		}
	}
	}

