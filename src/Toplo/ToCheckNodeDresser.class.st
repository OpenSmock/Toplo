Class {
	#name : #ToCheckNodeDresser,
	#superclass : #ToNodeDresser,
	#instVars : [
		'checkedIcon',
		'indeterminateIcon',
		'uncheckedIcon'
	],
	#category : #'Toplo-Core-Node'
}

{ #category : #enumerating }
ToCheckNodeDresser >> addedToSelection: anElement [

	anElement isChecked ifFalse: [anElement check]
]

{ #category : #accessing }
ToCheckNodeDresser >> checkIndeterminateIn: anElement [

	anElement hasIndeterminateState
		ifTrue: [ self withIndeterminateIn: anElement ]
		ifFalse: [ self withoutIndeterminateIn: anElement ].

]

{ #category : #initialization }
ToCheckNodeDresser >> defaultAnimationDuration [

	^ 300 milliSeconds
]

{ #category : #initialization }
ToCheckNodeDresser >> defaultCheckedIconImage [

	^ checkedIcon ifNil: [ 
		  checkedIcon := ToImage inner: (BlElement new
				                  size: 12 @ 12;
				                  border: (BlBorder paint: Color lightGray width: 1);
				                  margin: (BlInsets all: 2);
				                  background: theme button hoveredBorderColor;
				                  yourself) ]
]

{ #category : #initialization }
ToCheckNodeDresser >> defaultCheckedState [

	^ ToWidgetState new
		  name: #checked;
		  whenEnterDo: [ :ann | 
			  ann widget element: self defaultCheckedIconImage.
			  ann widget isAttachedToSceneGraph ifTrue: [ 
					  | op |
					  op := ann widget element innerImage opacity.
					  ann widget element innerImage opacity: 0.1.
					  ann widget element innerImage addAnimation:
							  (BlOpacityAnimation new
								   duration: (ann state counter isZero
										    ifTrue: [ 0 milliSecond ]
										    ifFalse: [ self defaultAnimationDuration ]);
								   opacity: op;
								   yourself) ] ];
		  yourself
]

{ #category : #initialization }
ToCheckNodeDresser >> defaultIndeterminateIconImage [

	| bar im |
	indeterminateIcon ifNotNil: [ ^ indeterminateIcon ].

	bar := BlElement new
		       size: 10 @ 2;
		       border: (BlBorder paint: Color black width: 1);
		       background: Color gray.
	bar constraintsDo: [ :c | 
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	im := BlElement new
		      size: 12 @ 12;
		      margin: (BlInsets all: 2);
		      border: (BlBorder paint: Color lightGray width: 1);
		      yourself.
	im layout: BlFrameLayout new.
	im addChild: bar.
	indeterminateIcon := ToImage inner: im.
	^ indeterminateIcon
]

{ #category : #initialization }
ToCheckNodeDresser >> defaultIndeterminateState [

	^ ToWidgetState new
		  name: #indeterminate;
		  whenEnterDo: [ :ann | 
			  ann widget element: self defaultIndeterminateIconImage ];
		  yourself
]

{ #category : #initialization }
ToCheckNodeDresser >> defaultUncheckedIconImage [

	^ uncheckedIcon ifNil: [ 
		  uncheckedIcon := ToImage inner: (BlElement new
				                    size: 12 @ 12;
				                    margin: (BlInsets all: 2);
				                    border: (BlBorder paint: Color gray width: 1);
				                    background: (Color gray alpha: 0.2);
				                    yourself) ]
]

{ #category : #initialization }
ToCheckNodeDresser >> defaultUncheckedState [

	^ ToWidgetState new
		  name: #unchecked;
		  whenEnterDo: [ :ann | 
			  ann widget element: self defaultUncheckedIconImage ]
]

{ #category : #'api - install/uninstall  hook' }
ToCheckNodeDresser >> onInstalledIn: anElement [

	super onInstalledIn: anElement.
	self checkIndeterminateIn: anElement.
	anElement
		whenAnnouncement: ToStatesDefinitionChangedAnnouncement
		do: [ self checkIndeterminateIn: anElement ]
]

{ #category : #'api - install/uninstall  hook' }
ToCheckNodeDresser >> onUninstalledIn: anElement [

	super onUninstalledIn: anElement.
	anElement unsubscribe: self

]

{ #category : #enumerating }
ToCheckNodeDresser >> removedFromSelection: anElement [

	anElement isChecked ifTrue: [anElement uncheck]
]

{ #category : #accessing }
ToCheckNodeDresser >> withIndeterminateIn: anElement [

	anElement setUpStatesWith: { 
			self defaultIndeterminateState.
			self defaultCheckedState.
			self defaultUncheckedState }
]

{ #category : #accessing }
ToCheckNodeDresser >> withoutIndeterminateIn: anElement [

	anElement setUpStatesWith: { 
			self defaultUncheckedState.
			self defaultCheckedState }
]