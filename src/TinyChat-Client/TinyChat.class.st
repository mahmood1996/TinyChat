Class {
	#name : #TinyChat,
	#superclass : #Object,
	#instVars : [
		'url',
		'login',
		'exit',
		'messages',
		'console',
		'lastMessageIndex'
	],
	#category : #'TinyChat-Client'
}

{ #category : #'instance creation' }
TinyChat class >> connect: aHost port: aPort login: aLogin [
	^ self new 
		host: aHost port: aPort login: aLogin; start
]

{ #category : #'connection open/close' }
TinyChat >> disconnect [
	self sendNewMessage: (TCMessage from: login text: 'I exited from the chat room.').
	exit := true
]

{ #category : #private }
TinyChat >> host: aHost port: aPort login: aLogin [
	url := 'http://' , aHost , ':' , aPort asString.
	login := aLogin
]

{ #category : #initialization }
TinyChat >> initialize [
	super initialize.
	exit := false.
	lastMessageIndex := 0.
	messages := OrderedCollection new.
]

{ #category : #private }
TinyChat >> lastMessageID [
	| id |
	id := (ZnClient new url: self lastMessageIDUrl ; get) asInteger.
	id = 0 ifTrue: [ id := 1 ].
	^ id
]

{ #category : #private }
TinyChat >> lastMessageIDUrl [
	^ self urlFor: '/messages/count'
]

{ #category : #private }
TinyChat >> messagesUrl [
	"Returns the server messages from my current last index to the last one on the server."
	^ self urlFor: '/messages' andArgument: lastMessageIndex
]

{ #category : #private }
TinyChat >> newMessageUrl [
	^ self urlFor: '/messages/add'
]

{ #category : #private }
TinyChat >> readMissingMessages [
	"Gets the new messages that have been posted since the last request."
	| response receivedMessages |
	
	response := (ZnClient new url: self messagesUrl ; get).
	
	^ response 
		ifNil: [ 0 ]
		ifNotNil: [
			receivedMessages := ( response split: String crlf ).
			messages addAll: ( receivedMessages collect: [ :msg | TCMessage fromString: msg ] ). 
			receivedMessages size.
].
]

{ #category : #refreshing }
TinyChat >> refreshMessages [
	[
		[ exit ] whileFalse: [
			(Delay forSeconds: 2) wait.
			lastMessageIndex := lastMessageIndex + (self readMissingMessages).
			console print: messages.
		]
	] fork
]

{ #category : #instructions }
TinyChat >> send: aString [
	"When we send a message, we push it to the server and in addition we update the local list of posted messages."
	| msg |
	msg := TCMessage from: login text: aString.
	self sendNewMessage: msg.
	lastMessageIndex := lastMessageIndex + (self readMissingMessages).
	console print: messages.
]

{ #category : #private }
TinyChat >> sendNewMessage: aMessage [
	| msgAsDictionary |
	
	msgAsDictionary := aMessage asDictionary.

	^ ZnClient new
		url: self newMessageUrl ;
		formAt: 'sender' put: (msgAsDictionary at: 'sender');
		formAt: 'text' put: (msgAsDictionary at: 'text');
		post
]

{ #category : #accessing }
TinyChat >> start [
	console := TCConsole attach: self.
	self sendNewMessage: (TCMessage from: login text: 'I joined the
		chat room').
	lastMessageIndex := self lastMessageID.
	self refreshMessages.
]

{ #category : #private }
TinyChat >> urlFor: aPath [
	^'{1}{2}' format: { url . aPath }
]

{ #category : #private }
TinyChat >> urlFor: aPath andArgument: anArgument [
	^ '{1}{2}/{3}' format: { url . aPath . anArgument asString }
]
