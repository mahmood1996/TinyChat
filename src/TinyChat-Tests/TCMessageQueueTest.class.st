Class {
	#name : #TCMessageQueueTest,
	#superclass : #TestCase,
	#instVars : [
		'queue',
		'message'
	],
	#category : #'TinyChat-Tests'
}

{ #category : #running }
TCMessageQueueTest >> setUp [
	super setUp.
	
	queue := TCMessageQueue new.
	
	message := TCMessage from: 'Momen' text: 'Hello'.
]

{ #category : #tests }
TCMessageQueueTest >> testAddingMessage [
	self 
		assert: ( queue add: message; size )
		equals: 1.
]

{ #category : #tests }
TCMessageQueueTest >> testGettingMessagesFromIndex [
	10 timesRepeat: [ queue add: message ].
	
	self 
		assert:  ( queue messagesFrom: 9 )
	 	equals: ( { 'Momen > Hello' , String crlf .
					   'Momen > Hello' , String crlf } joinUsing: '' )
]

{ #category : #tests }
TCMessageQueueTest >> testResetting [
	queue add: message.
	
	queue reset.

	self assert: queue size equals: 0
]
