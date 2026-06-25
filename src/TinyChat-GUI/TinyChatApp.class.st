Class {
	#name : #TinyChatApp,
	#superclass : #SpPresenter,
	#instVars : [
		'list',
		'input',
		'client',
		'login'
	],
	#category : #'TinyChat-GUI'
}

{ #category : #layout }
TinyChatApp class >> defaultLayout [
	<spec: #default>
	^ SpBoxLayout
		newTopToBottom
			add: #list;
			add: #input height: 30;
			yourself
]

{ #category : #'instance creation' }
TinyChatApp class >> startOn: aPort withLogin: aLogin [
	| client |
	
	client := TCClient startOn: aPort.
	
	self new 
		updateLogin: aLogin;
		updateClient: client;
		open.
		
]

{ #category : #'initialization - deprecated' }
TinyChatApp >> initializeWidgets [
	list := SpListPresenter new.
	
	input := SpTextInputFieldPresenter new
					placeholder: 'Type your message here...';
					enabled: true;
					whenSubmitDo: [ 
						:string | 
						client send: (TCMessage from: login text: string).
						input text: '' ];
					yourself.

	self focusOrder add: input.
		
]

{ #category : #initialization }
TinyChatApp >> initializeWindow: aWindowPresenter [
	| messagesStream |
	
	super initializeWindow: aWindowPresenter.
	
	messagesStream := client messagesStream.
	
	messagesStream 
		onEventEmitted: [ :messages | self print: messages ].
	
	aWindowPresenter 
		whenClosedDo: [ messagesStream close ].
		
]

{ #category : #private }
TinyChatApp >> input [

	^ input
]

{ #category : #private }
TinyChatApp >> list [
	
	^ list 
]

{ #category : #private }
TinyChatApp >> print: aMessages [
	list 
		items: (aMessages collect: [ :msg | msg printString ]); 
		withAdapterDo: [ 
			:anAdapter | 
			anAdapter widget scrollToIndex: aMessages size 
		].
]

{ #category : #TOREMOVE }
TinyChatApp >> title [
	^ login
]

{ #category : #private }
TinyChatApp >> updateClient: aClient [
	
	client := aClient 
]

{ #category : #private }
TinyChatApp >> updateLogin: aLogin [
	
	login := aLogin
]
