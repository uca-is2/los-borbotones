"
Game tests.
"
Class {
	#name : #GameTest,
	#superclass : #TestCase,
	#instVars : [
		'fourFaceDummyDice',
		'board',
		'game',
		'dices',
		'robert',
		'players',
		'atomicBombWithProbability',
		'emptyWithProbability',
		'gameElementsResource'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #accessing }
GameTest class >> resources [ 
	^{GameElementsResource}
]

{ #category : #asserting }
GameTest >> assertTile: aNumberOfTile andLap: aNumberOfLap for: aPlayer on: aGame [
	self assert: (aGame playersPositions tilePositionOf: aPlayer) equals: aNumberOfTile.
	self assert: (aGame playersPositions positionLapOf: aPlayer) equals: aNumberOfLap
]

{ #category : #tests }
GameTest >> juan [
	^ Player named: 'Juan'
]

{ #category : #tests }
GameTest >> loadedBoard [
	^(LoadedBoardBuilder startBoardWithSteps: 3)
		withEffectProbabilityAssociation: emptyWithProbability;
		buildBoard 
]

{ #category : #tests }
GameTest >> lucas [
	^ Player named: 'Lucas'
]

{ #category : #running }
GameTest >> setUp [
	super setUp.
	gameElementsResource := GameElementsResource current.
	fourFaceDummyDice := LoadedDice withFaces: 4 andValue: 4.
	
	dices := OrderedCollection with: fourFaceDummyDice.
	robert := Player named: 'Robert'.
	players := OrderedCollection with: robert.
	
	atomicBombWithProbability := AtomicBomb new -> 0.02.
	emptyWithProbability := Empty new -> 0.45.
	board := self loadedBoard.
	
	
]

{ #category : #asserting }
GameTest >> should: aBlock raise: anError withErrorMessage: aMessage [
	self should: aBlock
		raise: anError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText
				equals: aMessage ]
]

{ #category : #asserting }
GameTest >> should: aBlock raiseGameErrorWithMessage: aMessage [
	self should: aBlock
		raise: GameModelError 
		withErrorMessage: aMessage.
]

{ #category : #tests }
GameTest >> stocasticCardDeck [
	^gameElementsResource stocasticCardDeck.
]

{ #category : #tests }
GameTest >> testCanNotGetWinnerWhileGameIsRunning [
	game := Game
		playedBy: players
		withLapsToWin: 1
		board: board
		deck: self stocasticCardDeck
		using: dices.
	self deny: game hasEnded.
	self
		should: [ game winner ]
		raiseGameErrorWithMessage: 'There is no winner yet. The game is not finished'.
]

{ #category : #tests }
GameTest >> testCantInstantiatiateGameWithInvalidLapsAmount [
	| gameBlock|
	gameBlock := [ Game
		playedBy: players
		withLapsToWin: -3
		board: board
		deck: self stocasticCardDeck
		using: dices ].
	
	self should: gameBlock raiseGameErrorWithMessage: 'Laps amount must be a positive integer. '.
]

{ #category : #tests }
GameTest >> testCantInstantiatiateGameWithoutDices [
	| gameBlock|
	gameBlock := [ Game
		playedBy: players
		withLapsToWin: 5
		board: board
		deck: self stocasticCardDeck
		using: {  } ].
	
	self should: gameBlock raiseGameErrorWithMessage: 'Invalid set of dices. '.
]

{ #category : #tests }
GameTest >> testCantInstantiatiateGameWithoutPlayers [
	| gameBlock|
	gameBlock := [ Game
		playedBy: {}
		withLapsToWin: 5
		board: board
		deck: self stocasticCardDeck
		using: dices ].
	
	self should: gameBlock raiseGameErrorWithMessage: 'Invalid set of players. '.
]

{ #category : #tests }
GameTest >> testCantInstantiatiateInvalidPosition [

	self should: [ Position tile: -4 andLap: 2 ] raiseGameErrorWithMessage: 'Tile number must be a non negative integer. '.
	self should: [ Position tile: 2 andLap: -2 ] raiseGameErrorWithMessage: 'Lap number must be a non negative integer. '.
]

{ #category : #tests }
GameTest >> testGameCantBePlayedOnceItIsOver [
	game := Game
		playedBy: players
		withLapsToWin: 1
		board: board
		deck: self stocasticCardDeck
		using: dices.
	game turnIsPlayed.
	self
		should: [ game turnIsPlayed ]
		raiseGameErrorWithMessage: 'Game is over. '.
]

{ #category : #tests }
GameTest >> testGameHasEnded [
	game := Game
		playedBy: players
		withLapsToWin: 1
		board: board
		deck: self stocasticCardDeck 
		using: dices.
	self deny: game hasEnded.
	game turnIsPlayed.
	self assert: game hasEnded
]

{ #category : #tests }
GameTest >> testGameStartsWithA4StepsBoard [
	board := (LoadedBoardBuilder startBoardWithSteps: 4)
		withEffectProbabilityAssociation: emptyWithProbability;
		buildBoard.
	game := Game
		playedBy: players
		withLapsToWin: 1
		board: board
		deck: self stocasticCardDeck
		using: dices.
	self assert: game board numberOfTiles equals: 4
]

{ #category : #tests }
GameTest >> testGetWinnerOnceGameIsFinished [
	game := Game
		playedBy: players
		withLapsToWin: 1
		board: board
		deck: self stocasticCardDeck
		using: dices.
	self deny: game hasEnded.
	game turnIsPlayed.
	self assert: game hasEnded.
	self assert: game winner name equals: 'Robert'
]

{ #category : #tests }
GameTest >> testIsRobertTurn [
	| matt martin |
	matt := Player named: 'Matt'.
	martin := Player named: 'Martin'.
	players add: matt.
	players add: martin.
	board := (LoadedBoardBuilder startBoardWithSteps: 20)
		withEffectProbabilityAssociation: emptyWithProbability;
		buildBoard.
	game := Game
		playedBy: players
		withLapsToWin: 1
		board: board
		deck: self stocasticCardDeck
		using: dices.
	game turnIsPlayed.
	game turnIsPlayed.
	game turnIsPlayed.
	self assert: game currentPlayer name equals: 'Robert'
]

{ #category : #tests }
GameTest >> testLuciaCanNotPlayBecouseGameHasEnded [
	| lucia  |
	lucia := Player named: 'Lucia'.
	players add: lucia.
	game := Game
		playedBy: players
		withLapsToWin: 1
		board: board
		deck: self stocasticCardDeck
		using: dices.
	game turnIsPlayed.
	self
		should: [ game turnIsPlayed ]
		raiseGameErrorWithMessage: 'Game is over. '.
]

{ #category : #tests }
GameTest >> testPlayerMovesNineStepsWhenUsingTwoDices [
	| fiveFaceDummyDice  |
	fiveFaceDummyDice := LoadedDice withFaces: 5 andValue: 5.
	dices add: fiveFaceDummyDice.
	game := Game
		playedBy: players
		withLapsToWin: 3
		board: board
		deck: self stocasticCardDeck 
		using: dices.
	game turnIsPlayed.
	self
		assertTile: 0
		andLap: 3
		for: robert
		on: game
]

{ #category : #tests }
GameTest >> testPlayersStartWithTwoCards [
	| tomas lucia |
	tomas := Player named: 'Tomas'.
	lucia := Player named: 'Lucia'.
	players add: tomas.
	players add: lucia.
	game := Game
		playedBy: players
		withLapsToWin: 1
		board: board
		deck: self stocasticCardDeck 
		using: dices.
	game players
		do: [ :player | self assert: player cards size equals: 2 ]
]

{ #category : #tests }
GameTest >> testPositionNotFound [
	|lucia|
	lucia := Player named: 'Lucia'.
	board := (LoadedBoardBuilder startBoardWithSteps: 10)
		withEffectProbabilityAssociation: atomicBombWithProbability;
		buildBoard.
	game := Game
		playedBy: players
		withLapsToWin: 4
		board: board
		deck: self stocasticCardDeck 
		using: dices.
	game turnIsPlayed.
	
	self should: [ game changePositionOf: lucia toTile: 0 andLap:0  ] raiseGameErrorWithMessage: 'Player not found. '.
]

{ #category : #tests }
GameTest >> testPositionOfRobertAndLuciaAfterAtomicBombIsZero [
	| lucia |
	lucia := Player named: 'Lucia'.
	players add: lucia.
	board := (LoadedBoardBuilder startBoardWithSteps: 10)
		withEffectProbabilityAssociation: atomicBombWithProbability;
		buildBoard.
	game := Game
		playedBy: players
		withLapsToWin: 4
		board: board
		deck: self stocasticCardDeck 
		using: dices.
	game turnIsPlayed.
	self
		assertTile: 0
		andLap: 0
		for: robert
		on: game.
	self
		assertTile: 0
		andLap: 0
		for: lucia
		on: game
]

{ #category : #tests }
GameTest >> testThatRoberIsThirdLucasIsSecondAndJuanIsFirstInTheRanking [
	| lucas juan |
	lucas := self lucas.
	juan := self juan.
	players
		add: lucas;
		add: juan.
	board := (LoadedBoardBuilder startBoardWithSteps: 16)
		withEffectProbabilityAssociation: emptyWithProbability;
		buildBoard.
	game := Game
		playedBy: players
		withLapsToWin: 5
		board: board
		deck: self stocasticCardDeck
		using: dices.
	game turnIsPlayed.
	game changePositionOf: lucas toTile: 3 andLap: 4.
	game changePositionOf: juan toTile: 5 andLap: 5.
	self assert: game ranking first equals: juan.
	self assert: game ranking second equals: lucas.
	self assert: game ranking third equals: robert
]
