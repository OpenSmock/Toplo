Class {
	#name : #ToBarNodeManager,
	#superclass : #ToAbstractListNodeManager,
	#instVars : [
		'fakeDataItem'
	],
	#category : #'Toplo-Widget-List-Core'
}

{ #category : #initialization }
ToBarNodeManager >> defaultNodeBuilder [

	^ [ :node :holder :dataItem |
	  node addChild: (ToLabel text: dataItem asString) hMatchParent.
	  node constraintsDo: [ :c |
		  c horizontal fitContent.
		  c vertical fitContent ] ]
]

{ #category : #initialization }
ToBarNodeManager >> defaultNodeFactory [

	^ [ :holder | ToBarNode new ]
]

{ #category : #accessing }
ToBarNodeManager >> fakeDataItem [

	^ fakeDataItem
]

{ #category : #accessing }
ToBarNodeManager >> fakeDataItem: anObject [

	fakeDataItem := anObject
]

{ #category : #'instance creation' }
ToBarNodeManager >> newFakeNodeInHolder: anHolder [

	| fakeNode |
	anHolder dataItem: (ToMultiSelectDataItem index: (fakeDataItem ifNil: [0])).
	fakeNode := self newNodeInHolder: anHolder.
	self buildNode: fakeNode inHolder: anHolder.
	fakeNode margin: BlInsets empty.
	anHolder node: fakeNode.
	^ fakeNode

]