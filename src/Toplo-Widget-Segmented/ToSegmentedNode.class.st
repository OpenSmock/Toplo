Class {
	#name : #ToSegmentedNode,
	#superclass : #ToItemNode,
	#category : #'Toplo-Widget-Segmented-Node'
}

{ #category : #accessing }
ToSegmentedNode >> checkableElement [ 

	^ self item
]

{ #category : #accessing }
ToSegmentedNode >> checkableElement: aCheckable [

	self item: aCheckable
]

{ #category : #'t - list node' }
ToSegmentedNode >> clickEventHandlerClasses [

	^  { ToSegmentedNodeSelectionEventHandler } 
]

{ #category : #skin }
ToSegmentedNode >> newRawSkin [ 

	^ ToSegmentedNodeSkin new
]
