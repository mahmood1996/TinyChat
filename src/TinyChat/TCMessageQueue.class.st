Class {
	#name : #TCMessageQueue,
	#superclass : #Object,
	#instVars : [
		'messages'
	],
	#category : #TinyChat
}

{ #category : #adding }
TCMessageQueue >> add: aMessage [ 
	messages add: aMessage
]

{ #category : #initialization }
TCMessageQueue >> initialize [ 
	
	super initialize.
	
	messages := OrderedCollection new
]

{ #category : #private }
TCMessageQueue >> listFrom: anInteger [ 
	^ ( anInteger between: 1 and: anInteger )
		ifFalse:  [ #() ]
		ifTrue: [ messages copyFrom: anInteger to: messages size ].
]

{ #category : #accessing }
TCMessageQueue >> messagesFrom: anInteger [ 
	^ String streamContents: [ 
			:aStream | 
			( self listFrom: anInteger ) do: [ :message | message printOn: aStream ]
		]
]

{ #category : #initialization }
TCMessageQueue >> reset [
	messages removeAll
]

{ #category : #accessing }
TCMessageQueue >> size [ 
	^ messages size
	
]
