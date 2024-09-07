Class {
	#name : #ToListSelectionElementOption,
	#superclass : #Object,
	#instVars : [
		'masked',
		'grouped',
		'beneath',
		'triggerSelectionState',
		'animationDuration',
		'selectionContainer',
		'groupHolder',
		'selectionModel',
		'listEventHandler',
		'elementFactory'
	],
	#category : #'Toplo-Widget-List-Selection-Mode'
}

{ #category : #'instance creation' }
ToListSelectionElementOption class >> grouped [

	^ self new grouped: true
]

{ #category : #'instance creation' }
ToListSelectionElementOption class >> separate [

	^ self new grouped: false
]

{ #category : #'instance creation' }
ToListSelectionElementOption >> addSelectionElement: aSelectionElement [

	selectionContainer addChild: aSelectionElement
]

{ #category : #'instance creation' }
ToListSelectionElementOption >> addSelectionElements: aSelectionElementArray [

	selectionContainer addChildren: aSelectionElementArray
]

{ #category : #accessing }
ToListSelectionElementOption >> animationDuration [

	^ animationDuration
]

{ #category : #accessing }
ToListSelectionElementOption >> animationDuration: aDuration [

	animationDuration := aDuration
]

{ #category : #accessing }
ToListSelectionElementOption >> beneath: aBoolean [

	beneath := aBoolean.
	selectionContainer ifNotNil: [
		| elevation |
		elevation := beneath
			             ifTrue: [ BlRelativeElevation elevation: 5 ]
			             ifFalse: [ BlRelativeElevation elevation: 15 ].
		selectionContainer elevation: elevation ]
]

{ #category : #'nodes collecting' }
ToListSelectionElementOption >> collectSelectionGroupsFrom: aListElement [

	^ self currentSelectionGroupsFrom: aListElement
]

{ #category : #'nodes collecting' }
ToListSelectionElementOption >> currentSelectionGroupsFrom: aListElement [

	^ grouped
		  ifTrue: [
			  (aListElement innerContainer nodeGroupsSatisfying: [ :node |
				   selectionModel containsIndex: node holder position ]) collect: [
				  :arr | ToNeighboringSelection new nodes: arr ] ]
		  ifFalse: [
			  (aListElement innerContainer nodesSelect: [ :node |
				   selectionModel containsIndex: node holder position ]) collect: [
				  :node | ToSeparateSelection new node: node ] ]
]

{ #category : #accessing }
ToListSelectionElementOption >> elementFactory: aSelectionElementFactoryValuable [

	elementFactory := aSelectionElementFactoryValuable
]

{ #category : #accessing }
ToListSelectionElementOption >> groupHolder [ 

	^ groupHolder 
]

{ #category : #accessing }
ToListSelectionElementOption >> grouped: aBoolean [

	grouped := aBoolean
]

{ #category : #initialization }
ToListSelectionElementOption >> initialize [ 

	super initialize.
	triggerSelectionState := false.
	animationDuration := 0 milliSecond.
	masked := false.
	beneath := true.
	grouped := false.
	groupHolder := ToSelectionGroupHolder new.
	groupHolder option: self.

]

{ #category : #accessing }
ToListSelectionElementOption >> isAnimated [

	^ animationDuration asMilliSeconds > 0
]

{ #category : #testing }
ToListSelectionElementOption >> isBeneath [

	^ beneath
]

{ #category : #testing }
ToListSelectionElementOption >> isGrouped [

	^ grouped
]

{ #category : #testing }
ToListSelectionElementOption >> isOver [

	^ self isBeneath not
]

{ #category : #testing }
ToListSelectionElementOption >> isSeparate [

	^ self isGrouped not
]

{ #category : #accessing }
ToListSelectionElementOption >> listEventHandler: aListEventHandler [

	listEventHandler := aListEventHandler
]

{ #category : #accessing }
ToListSelectionElementOption >> masked [

	^ masked
]

{ #category : #accessing }
ToListSelectionElementOption >> masked: aBoolean [

	masked := aBoolean
]

{ #category : #'instance creation' }
ToListSelectionElementOption >> newSelectionContainerIn: anElement [

	| container elevation |
	container := ToOverlayElement new.
	container clipChildren: false.
	container attachTo: anElement innerContainer.
	elevation := beneath
		             ifTrue: [ BlRelativeElevation elevation: 5 ]
		             ifFalse: [ BlRelativeElevation elevation: 15 ].
	container elevation: elevation.
	^ container
]

{ #category : #'instance creation' }
ToListSelectionElementOption >> newSelectionElementIn: aListElement [

	^ elementFactory value
		  selectionOption: self;
		  focused: (triggerSelectionState and: [ aListElement isFocused ]);
		  yourself
]

{ #category : #'api - hooks' }
ToListSelectionElementOption >> onInstalledIn: aListElement [

	aListElement addEventHandler: listEventHandler.
	selectionContainer := self newSelectionContainerIn: aListElement.
	aListElement addChild: selectionContainer
]

{ #category : #'api - hooks' }
ToListSelectionElementOption >> onUninstalledIn: aListElement [

	aListElement removeEventHandler: listEventHandler.
	selectionContainer removeFromParent.
	selectionContainer := nil.
	listEventHandler := nil.
	elementFactory := nil.
	selectionModel := nil
]

{ #category : #accessing }
ToListSelectionElementOption >> selectionContainer [

	^ selectionContainer
]

{ #category : #accessing }
ToListSelectionElementOption >> selectionElements [

	^ selectionContainer children select: [ :child |
		  child isKindOf: ToListSelectionElement ]
]

{ #category : #accessing }
ToListSelectionElementOption >> selectionModel: aSelectionModel [

	selectionModel := aSelectionModel
]

{ #category : #testing }
ToListSelectionElementOption >> triggerSelectionState [

	^ triggerSelectionState
]

{ #category : #accessing }
ToListSelectionElementOption >> triggerSelectionState: aBoolean [

	triggerSelectionState := aBoolean
]