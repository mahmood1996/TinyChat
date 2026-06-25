Class {
	#name : #TCMessage,
	#superclass : #Object,
	#instVars : [
		'sender',
		'text'
	],
	#category : #TinyChat
}

{ #category : #'instance creation' }
TCMessage class >> from: aSender text: aString [ 
	^ self new 
		sender: aSender; 
		text: aString; 
		yourself
]

{ #category : #'instance creation' }
TCMessage class >> fromString: aString [ 
	| result |
	
	result := aString trimmed splitOn: self separator.
	
	^ ( result size == 2 ) 
		ifTrue: [ self from: (result at: 1) text: (result at: 2) ] 
		ifFalse: [ self new ]
]

{ #category : #private }
TCMessage class >> separator [ 
	^ ' > '
]

{ #category : #converting }
TCMessage >> asDictionary [ 
	"Returns message content as dictionary"
	^ { 'sender' -> sender . 'text' -> text } asDictionary
]

{ #category : #initialization }
TCMessage >> initialize [
	super initialize.
	
	self sender: ''.
	
	self text: ''
]

{ #category : #printing }
TCMessage >> printOn: aStream [
	sender ifNotEmpty: [ 
		aStream
			<< sender; 
			<< self class separator;
			<< text; 
			<< String crlf ].

	
]

{ #category : #private }
TCMessage >> sender: aString [
	sender := aString 
]

{ #category : #private }
TCMessage >> text: aString [
	text := aString 
]
