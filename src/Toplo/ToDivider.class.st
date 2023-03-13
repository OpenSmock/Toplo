Class {
	#name : #ToDivider,
	#superclass : #ToElement,
	#traits : 'TToWidget',
	#classTraits : 'TToWidget classTrait',
	#instVars : [
		'thickness',
		'pane',
		'firstTarget',
		'secondTarget'
	],
	#category : #'Toplo-Widget-Pane'
}

{ #category : #'instance creation' }
ToDivider class >> between: aFirstElement and: aSecondElement in: aPane [

	^ self basicNew
		  pane: aPane;
		  firstTarget: aFirstElement;
		  secondTarget: aSecondElement;
		  initialize;
		  yourself
]

{ #category : #'instance creation' }
ToDivider class >> new [

	^ self error: 'Use between:and:in'
]

{ #category : #'private - adding' }
ToDivider >> adaptToHorizontalPane [

	| firstY secondY gap firstX secondX firstH secondH |
	self width: self thickness.
	firstX := self leftTarget bounds right.
	secondX := self rightTarget bounds left.
	firstY := self leftTarget bounds top.
	secondY := self rightTarget bounds top.
	firstH := self topTarget bounds height.
	secondH := self bottomTarget bounds height.
	gap := secondX - firstX / 2 - (self thickness / 2).
	self relocate: firstX + gap @ (firstY max: secondY).
	self height: (firstH min: secondH)

]

{ #category : #'private - adding' }
ToDivider >> adaptToPane [

	self pane whenLayoutedDoOnce: [
		self isHorizontal
			ifTrue: [ self adaptToVerticalPane ]
			ifFalse: [ self adaptToHorizontalPane ] ].
	"self pane requestLayout"
]

{ #category : #'private - adding' }
ToDivider >> adaptToVerticalPane [

	| firstY secondY gap firstX secondX firstW secondW|
	self height: self thickness.
	firstY := self topTarget bounds bottom.
	secondY := self bottomTarget bounds top.
	firstX := self topTarget bounds left.
	secondX := self bottomTarget bounds left.
	firstW := self topTarget bounds width.
	secondW := self bottomTarget bounds width.
	gap := secondY - firstY / 2 - (self thickness / 2).
	self relocate: (firstX max: secondX) @ firstY + gap.
	self width: (firstW min: secondW)
]

{ #category : #'private - adding' }
ToDivider >> addedInPane [

	self adaptToPane.
	self pane whenOrientationChangedDo: [ self adaptToPane ].
	self pane when: BlElementExtentChangedEvent do: [ self adaptToPane ]
]

{ #category : #accessing }
ToDivider >> bottomTarget [

	^ self pane isLeftToRight 
		  ifTrue: [ self secondTarget ]
		  ifFalse: [ self firstTarget ]
]

{ #category : #'t - initialization dresser' }
ToDivider >> defaultDresser [

	^ ToDividerDresser new
]

{ #category : #'t - initialization' }
ToDivider >> defaultLayout [

	^ BlFrameLayout new 
]

{ #category : #accessing }
ToDivider >> firstTarget [

	^ firstTarget
]

{ #category : #accessing }
ToDivider >> firstTarget: anObject [

	firstTarget := anObject
]

{ #category : #initialization }
ToDivider >> initialize [

	super initialize.
	self initializeDresser 
]

{ #category : #testing }
ToDivider >> isHorizontal [

	^ self pane isVertical
]

{ #category : #testing }
ToDivider >> isVertical [

	^ self isHorizontal not
]

{ #category : #accessing }
ToDivider >> leftTarget [

	^ self pane isLeftToRight ifTrue: [  self firstTarget ] ifFalse: [ self secondTarget ]
]

{ #category : #accessing }
ToDivider >> pane [

	^ pane
]

{ #category : #accessing }
ToDivider >> pane: aPane [

	pane := aPane
]

{ #category : #accessing }
ToDivider >> rightTarget [

	^ self pane isLeftToRight
		  ifTrue: [ self secondTarget ]
		  ifFalse: [ self firstTarget ]
]

{ #category : #accessing }
ToDivider >> secondTarget [

	^ secondTarget
]

{ #category : #accessing }
ToDivider >> secondTarget: anObject [

	secondTarget := anObject
]

{ #category : #accessing }
ToDivider >> thickness [

	^ thickness
]

{ #category : #accessing }
ToDivider >> thickness: aNumber [

	thickness := aNumber
]

{ #category : #accessing }
ToDivider >> topTarget [

	^ self pane isLeftToRight  
		  ifTrue: [ self firstTarget ]
		  ifFalse: [ self secondTarget ]
]