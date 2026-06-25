Class {
	#name : #TCClient,
	#superclass : #Object,
	#instVars : [
		'url'
	],
	#category : #'TinyChat-Client'
}

{ #category : #public }
TCClient class >> startOn: aPort [
	^ self new startOn: aPort; yourself 
]

{ #category : #private }
TCClient >> lastMessageID [
	| id |
	id := (ZnClient new url: self lastMessageIDUrl ; get) asInteger.
	^ id
]

{ #category : #private }
TCClient >> lastMessageIDUrl [
	^ url, '/messages/count'
]

{ #category : #private }
TCClient >> messagesFrom: anIndex [
	^ ( ZnClient new 
		url: (self urlFor: '/messages' andArgument: anIndex ) ; 
		get ) 
			ifNil: [ #() ]
			ifNotNil: [ 
				:messages | 
				( messages splitOn: String crlf ) collect: [ 
					:aString | 
					TCMessage fromString: aString 
				]
			]
]

{ #category : #accessing }
TCClient >> messagesStream [
	| fetchedMessageID messages stream isStreamClosed |
	
	fetchedMessageID := 0.
	
	isStreamClosed := false.
	
	messages := OrderedCollection new.
	
	stream := ReactiveStream new 
		onClosed: [ isStreamClosed := true ]; 
		yourself.
	
	[ 
		[ isStreamClosed ] whileFalse: [ 
			( Delay forSeconds: 2 ) wait. 
			
			self lastMessageID  
				ifNotNil: [ 
					:value | 
					( value ~= fetchedMessageID ) 
						ifTrue: [ 
							fetchedMessageID := value.
							
							messages addAll: ( self messagesFrom: value ).
							
							stream emit: messages.
						]
				].
		] 
	] fork.
	
	^ stream
]

{ #category : #private }
TCClient >> newMessageUrl [

	^ url , '/messages/add'
]

{ #category : #instructions }
TCClient >> send: aMessage [
	| msgAsDictionary aClient |
	
	msgAsDictionary := aMessage asDictionary.

	aClient := ZnClient new url: self newMessageUrl; yourself.
	
	msgAsDictionary keysAndValuesDo: [ 
		:key :value | 
		aClient formAt: key put: value 
	].
	
	aClient post
]

{ #category : #private }
TCClient >> startOn: aPort [

	url := 'http://localhost:' , aPort asString.
]

{ #category : #private }
TCClient >> urlFor: aPath andArgument: anArgument [
	^ '{1}{2}/{3}' format: { url . aPath . anArgument asString }
]
