Class {
	#name : #ToSingleSelectContainerElement,
	#superclass : #ToElementBarContainerElement,
	#instVars : [
		'node'
	],
	#category : #'Toplo-Widget-Select-Core'
}

{ #category : #adding }
ToSingleSelectContainerElement >> addFakeNode [

	self addChild: fakeNode
]

{ #category : #initialization }
ToSingleSelectContainerElement >> defaultNodeClass [ 

	^ ToSingleSelectNode
]

{ #category : #accessing }
ToSingleSelectContainerElement >> filterString [ 

	^ self textInputElement filterString
]

{ #category : #'t - orientable - orientation' }
ToSingleSelectContainerElement >> horizontal: aBoolean [
]

{ #category : #accessing }
ToSingleSelectContainerElement >> inputTextField [

	^ self textInputElement inputTextField
]

{ #category : #testing }
ToSingleSelectContainerElement >> isSingleNode [

	^ true
]

{ #category : #accessing }
ToSingleSelectContainerElement >> nodeAutoDistribution: aBoolean [


]

{ #category : #accessing }
ToSingleSelectContainerElement >> nodeBuilder [
	" return a valuable that is used to build a bar node element from a data. 
	aValuable take the bar node element to build as first argument 
	and its holder as second argument"

	^ [ :aSelectNode :aNodeHolder |  ]
]

{ #category : #accessing }
ToSingleSelectContainerElement >> nodeScrolling: aBoolean [


]

{ #category : #accessing }
ToSingleSelectContainerElement >> nodeWrapping: aBoolean [


]

{ #category : #enumerating }
ToSingleSelectContainerElement >> nodesDo: aBlock [

	node ifNil: [ ^ self ].
	aBlock value: node
]

{ #category : #'api - hooks' }
ToSingleSelectContainerElement >> onInstalledIn: anElementBar [

	super onInstalledIn: anElementBar.
	self
		vFitContent;
		hMatchParent;
		constraintsDo: [ :c | c linear vertical alignCenter ].
	node := self newNode.
	self nodeBuilder value: node value: node holder.
	self addChild: node.
	self installFakeNode
]

{ #category : #'api - hooks' }
ToSingleSelectContainerElement >> onUninstalledIn: anElementBar [

	node onUninstalledIn: anElementBar.
	node removeFromParent.
	node := nil.
	self uninstallFakeNode.
	super onUninstalledIn: anElementBar.


]

{ #category : #window }
ToSingleSelectContainerElement >> onWindowClosed [

	self textInputElement onWindowClosed
]

{ #category : #window }
ToSingleSelectContainerElement >> onWindowOpened [

	self textInputElement onWindowOpened
]

{ #category : #accessing }
ToSingleSelectContainerElement >> refresh [

	| nodeHolder idx selectedData |
	nodeHolder := node holder.
	elementBar selectionModel isEmpty
		ifTrue: [
			idx := 0.
			selectedData := nil ]
		ifFalse: [
			idx := elementBar selectionModel firstIndex.
			selectedData := idx <= elementBar dataAccessor size
				                ifTrue: [ elementBar dataAccessor at: idx ]
				                ifFalse: [  ] ].
	nodeHolder
		position: idx;
		dataItem: selectedData.
	self refreshInputTextElementWithSelectedData
]

{ #category : #accessing }
ToSingleSelectContainerElement >> refreshInputTextElementWithSelectedData [

	self inputTextField text: ''.
	self selectedDataTextField text:
		(node holder dataItem ifNil: [ '' ] ifNotNil: [ :d | d asString ])
]

{ #category : #accessing }
ToSingleSelectContainerElement >> textInputElement [

	^ node textInputElement
]