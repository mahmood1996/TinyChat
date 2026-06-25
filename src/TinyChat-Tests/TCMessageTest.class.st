Class {
	#name : #TCMessageTest,
	#superclass : #TestCase,
	#category : #'TinyChat-Tests'
}

{ #category : #tests }
TCMessageTest >> testMessageFromEmptyString [
	| message |
	
	message := TCMessage fromString: '' , String crlf .
	
	self assert: message printString equals: ''
]

{ #category : #tests }
TCMessageTest >> testMessageFromString [
	| message |
	
	message := TCMessage fromString: 'Momen > Hello' , String crlf .
	
	self assert: message printString equals: 'Momen > Hello' , String crlf
]

{ #category : #tests }
TCMessageTest >> testMessagesFromString [
	| msgsAsString messages |
	
	msgsAsString := 'Momen > Hello', String crlf , 'Momen > Hello' , String crlf.
	
	messages := ( msgsAsString splitOn: String crlf ) collect: [ :msg | TCMessage fromString: msg ].
	
	self 
		assert: ( String streamContents: [ :aStream | messages do: [ :msg | msg printOn: aStream ] ] ) 
		equals: msgsAsString 
]

{ #category : #tests }
TCMessageTest >> testPrintingMessage [
	| message |
	
	message := TCMessage from: 'Momen' text: 'Hello'.
	
	self assert: message printString equals: 'Momen > Hello' , String crlf
]
