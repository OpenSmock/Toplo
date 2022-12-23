Trait {
	#name : #TToOrientableWidget,
	#category : #'Toplo-Core'
}

{ #category : #'t - widget orientation' }
TToOrientableWidget >> beHorizontal [ 

	self horizontal: true
]

{ #category : #'t - widget orientation' }
TToOrientableWidget >> beVertical [

	self horizontal: false
]

{ #category : #'t - widget orientation' }
TToOrientableWidget >> horizontal [

	^ self layout isHorizontal
]

{ #category : #'t - widget orientation' }
TToOrientableWidget >> horizontal: aBoolean [

	aBoolean
		ifTrue: [ self layout beHorizontal ]
		ifFalse: [ self layout beVertical ].
	self requestLayout   
]

{ #category : #initialization }
TToOrientableWidget >> initialize [
	
	self class initializeSlots: self.
	super initialize.
]

{ #category : #'t - widget orientation' }
TToOrientableWidget >> isHorizontal [

	^ self horizontal
]

{ #category : #'t - widget orientation' }
TToOrientableWidget >> orientation [

	^ self layout orientation
]

{ #category : #'t - widget orientation' }
TToOrientableWidget >> orientation: aBlLayoutOrientation [

	self layout orientation: aBlLayoutOrientation.
	self requestLayout 
]