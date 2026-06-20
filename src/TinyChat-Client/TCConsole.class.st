Class {
	#name : #TCConsole,
	#superclass : #SpPresenter,
	#instVars : [
		'chat',
		'list',
		'input'
	],
	#category : #'TinyChat-Client'
}

{ #category : #'instance creation' }
TCConsole class >> attach: aTinyChat [
	| window |
	window := self new chat: aTinyChat.
	window open whenClosedDo: [ aTinyChat disconnect ].
	^ window
]

{ #category : #layout }
TCConsole class >> defaultLayout [
	<spec: #default>
	^ SpBoxLayout
		newTopToBottom
			add: #list;
			add: #input height: 30;
			yourself
]

{ #category : #accessing }
TCConsole >> chat: anObject [

	chat := anObject
]

{ #category : #'initialization - deprecated' }
TCConsole >> initializeWidgets [
	list := SpListPresenter new.
	input := SpTextInputFieldPresenter new
					placeholder: 'Type your message here...';
					enabled: true;
					whenSubmitDo: [ :string |
							chat send: string.
							input text: '' ].
	self focusOrder add: input.
]

{ #category : #accessing }
TCConsole >> input [

	^ input
]

{ #category : #accessing }
TCConsole >> list [

	^ list
]

{ #category : #printing }
TCConsole >> print: aCollectionOfMessages [
	list items: (aCollectionOfMessages collect: [ :m | m printString ])
]

{ #category : #TOREMOVE }
TCConsole >> title [
	^ 'TinyChat'
]
