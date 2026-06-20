Class {
	#name : #TCMessageTest,
	#superclass : #TestCase,
	#category : #'TinyChat-Tests'
}

{ #category : #tests }
TCMessageTest >> testMessageFromString [
	| message |
	
	message := TCMessage fromString: 'Momen > Hello' , String crlf .
	
	self assert: message printString equals: 'Momen > Hello' , String crlf
]

{ #category : #tests }
TCMessageTest >> testPrintingMessage [
	| message |
	
	message := TCMessage from: 'Momen' text: 'Hello'.
	
	self assert: message printString equals: 'Momen > Hello' , String crlf
]
