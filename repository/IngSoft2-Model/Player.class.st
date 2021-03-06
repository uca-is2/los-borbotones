"
""soy un jugador""
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	dice:		<Object>
	playerName:		<Object>


    Implementation Points
"
Class {
	#name : #Player,
	#superclass : #Object,
	#instVars : [
		'name',
		'cards',
		'playerChoosen'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #creation }
Player class >> named: aName [
	^ self new
		initializeWithName: aName;
		yourself
]

{ #category : #'private - assertions' }
Player >> assertPlayerHasCardInHand: aCard [
	cards
		detect: [ :card | card = aCard ]
		ifNone: [ GameModelError signal: 'No such card in hand. ' ]
]

{ #category : #accessing }
Player >> cards [
	^cards copy
]

{ #category : #action }
Player >> choose: aPlayerName inOrderToPlayCardOn: aGame [
	playerChoosen := aGame selectPlayers: aPlayerName
]

{ #category : #initialize }
Player >> initializeWithName: aName [
	name := aName.
	cards := OrderedCollection new.
]

{ #category : #presentation }
Player >> name [
	^ name
]

{ #category : #action }
Player >> playsCard: aCard affecting: aSetOfPlayers on: aGame [
	self assertPlayerHasCardInHand: aCard.
	aCard actOn: aGame affect: aSetOfPlayers by: self.
	cards remove: aCard
]

{ #category : #action }
Player >> take: aSetOfCards [
	cards addAll: aSetOfCards.
]
