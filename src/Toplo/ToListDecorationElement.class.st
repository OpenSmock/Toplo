Class {
	#name : #ToListDecorationElement,
	#superclass : #BlElement,
	#instVars : [
		'listElement'
	],
	#category : #'Toplo-Widget-List'
}

{ #category : #accessing }
ToListDecorationElement >> borderColor [

	^ Color gray
]

{ #category : #accessing }
ToListDecorationElement >> borderWidth [

	^ 1
]

{ #category : #accessing }
ToListDecorationElement >> defaultBorder [

	^ BlBorder paint: self borderColor width: self borderWidth
]

{ #category : #initialization }
ToListDecorationElement >> initialize [ 

	super initialize.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 6).
	self background: Color transparent.
	self border:	self defaultBorder.
	self constraintsDo: [ :c | c ignoreByLayout  ].
	self outskirts: BlOutskirts inside

]

{ #category : #accessing }
ToListDecorationElement >> listElement [

	^ listElement
]

{ #category : #accessing }
ToListDecorationElement >> listElement: aListElement [

	listElement := aListElement
]