Class {
	#name : #ToAbstractButtonDresser,
	#superclass : #ToDresser,
	#instVars : [
		'clickCandidateHandler',
		'mouseDownHandler',
		'mouseUpHandler',
		'mouseEnterHandler',
		'mouseLeaveHandler',
		'clickHandler'
	],
	#category : #'Toplo-Widget-Button'
}

{ #category : #'events handling' }
ToAbstractButtonDresser >> clicked: anElement [

	self subclassResponsibility 

]

{ #category : #'events handling' }
ToAbstractButtonDresser >> escaped: anElement [

	self subclassResponsibility 

]

{ #category : #'events handling' }
ToAbstractButtonDresser >> hover: anElement [

	self subclassResponsibility 

]

{ #category : #'events handling' }
ToAbstractButtonDresser >> initialState: anElement [

	self subclassResponsibility 

]

{ #category : #'api - install/uninstall  hook' }
ToAbstractButtonDresser >> installEventListenersIn: anElement [

	clickCandidateHandler := BlEventHandler on: BlClickCandidateEvent do: [ self escaped: anElement ].
	clickHandler := ToButtonClickEventHandler new button: anElement.
	mouseDownHandler := BlEventHandler on: BlMouseDownEvent do: [ :event | event modifiers isEmpty ifTrue: [self pressed: anElement] ].
	mouseUpHandler := BlEventHandler on: BlMouseUpEvent do: [ :event | event modifiers isEmpty ifTrue: [self clicked: anElement ]].
	mouseEnterHandler := BlEventHandler on: BlMouseEnterEvent 
		do: [ :event | 
			(event anyButtonPressed and: [event currentTarget ~= anElement ] )
				ifFalse: [self hover: anElement ] ].
	mouseLeaveHandler := BlEventHandler on: BlMouseLeaveEvent do: [ self leaved: anElement ].
	anElement addEventHandler: clickCandidateHandler.
	anElement addEventHandler: mouseDownHandler.
	anElement addEventHandler: mouseUpHandler.
	anElement addEventHandler: mouseEnterHandler.
	anElement addEventHandler: mouseLeaveHandler.
	anElement addEventHandler: clickHandler.


]

{ #category : #'events handling' }
ToAbstractButtonDresser >> leaved: anElement [

	self subclassResponsibility 

]

{ #category : #'api - install/uninstall  hook' }
ToAbstractButtonDresser >> onInstalledIn: anElement [

	super onInstalledIn: anElement.
	self initialState: anElement.
	anElement outskirts: (BlOutskirts outside).
	self installEventListenersIn: anElement
]

{ #category : #'api - install/uninstall  hook' }
ToAbstractButtonDresser >> onUninstalledIn: anElement [

	self uninstallEventListenersIn: anElement.
	super onUninstalledIn: anElement.

]

{ #category : #'events handling' }
ToAbstractButtonDresser >> pressed: anElement [

	self subclassResponsibility 

]

{ #category : #'api - install/uninstall  hook' }
ToAbstractButtonDresser >> uninstallEventListenersIn: anElement [

	anElement removeEventHandler: clickCandidateHandler.
	anElement removeEventHandler: mouseDownHandler.
	anElement removeEventHandler: mouseUpHandler.
	anElement removeEventHandler: mouseEnterHandler.
	anElement removeEventHandler: mouseLeaveHandler.
	anElement removeEventHandler: clickHandler.
]