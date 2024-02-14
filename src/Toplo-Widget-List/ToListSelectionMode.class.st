Class {
	#name : #ToListSelectionMode,
	#superclass : #ToListAbstractSelectionMode,
	#instVars : [
		'preserveSelectionOnFocused',
		'installedShortcuts'
	],
	#category : #'Toplo-Widget-List-Selection-Mode'
}

{ #category : #initialization }
ToListSelectionMode >> initialize [ 

	super initialize.
	preserveSelectionOnFocused := true
]

{ #category : #'event handling' }
ToListSelectionMode >> onClickEvent: anEvent onNode: aNode [


]

{ #category : #'api - hooks' }
ToListSelectionMode >> onInstalledIn: anElement [

	super onInstalledIn: anElement. 
	installedShortcuts := self shortcutsIn: anElement.
	installedShortcuts do: [ :s | anElement addShortcut: s ]
]

{ #category : #'api - hooks' }
ToListSelectionMode >> onUninstalledIn: anElement [

	installedShortcuts do: [ :s | anElement removeShortcut: s ].
	installedShortcuts := nil.
	super onUninstalledIn: anElement. 

]

{ #category : #accessing }
ToListSelectionMode >> preserveSelectionOnFocused [

	^ preserveSelectionOnFocused
]

{ #category : #accessing }
ToListSelectionMode >> preserveSelectionOnFocused: aBoolean [

	preserveSelectionOnFocused := aBoolean
]

{ #category : #shortcuts }
ToListSelectionMode >> shortcutsIn: anElement [

	^ {
		  (BlShortcutWithAction new
			   combination: BlKeyCombination builder arrowDown build;
			   action: [ :aShortcutEvent :aShortcut |
				   self selecter selectAndScrollToNext ]).
		  (BlShortcutWithAction new
			   combination: BlKeyCombination builder arrowUp build;
			   action: [ :aShortcutEvent :aShortcut |
				   self selecter selectAndScrollToPrevious ]) }
]