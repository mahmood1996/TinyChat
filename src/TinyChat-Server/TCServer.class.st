Class {
	#name : #TCServer,
	#superclass : #Object,
	#instVars : [
		'teapotServer',
		'messageQueue'
	],
	#category : #'TinyChat-Server'
}

{ #category : #public }
TCServer class >> startOn: aPortNumber [
	^ self new
		initializePort: aPortNumber;
		registerRoutes;
		registerErrorHandlers;
		yourself
]

{ #category : #registration }
TCServer class >> stopAll [
	self allInstancesDo: #stop
]

{ #category : #private }
TCServer >> addMessage: aRequest [

	messageQueue 
		add: ( TCMessage 
					from: ( aRequest at: #sender ) 
					text: ( aRequest at: #text ) ).
]

{ #category : #initialization }
TCServer >> initialize [ 
	super initialize.
	
	messageQueue := TCMessageQueue new.
	
	
]

{ #category : #private }
TCServer >> initializePort: anInteger [
	teapotServer := Teapot configure: {
		#defaultOutput -> #text.
		#port -> anInteger.
		#debugMode -> true
	}.
	
	teapotServer start.
]

{ #category : #private }
TCServer >> messageCount [

	^ messageQueue size
]

{ #category : #private }
TCServer >> messagesFrom: aRequest [

	^ messageQueue messagesFrom: ( aRequest at: #id ).
]

{ #category : #private }
TCServer >> registerErrorHandlers [
	teapotServer
		exception: KeyNotFound -> (TeaResponse notFound body: 'No such message')
]

{ #category : #private }
TCServer >> registerRoutes [
	teapotServer 
		GET: '/messages/count' -> (Send message: #messageCount to: self);
	 	GET: '/messages/<id:IsInteger>' -> (Send message: #messagesFrom: to: self);
	 	POST: '/messages/add' -> (Send message: #addMessage: to: self)
]

{ #category : #cleanup }
TCServer >> stop [
	teapotServer stop.
	messageQueue reset.
]
