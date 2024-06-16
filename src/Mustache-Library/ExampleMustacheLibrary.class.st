"
https://book.huihoo.com/smalltalk/pharo/enterprise-pharo/book-result/Mustache/Mustache.html
"
Class {
	#name : #ExampleMustacheLibrary,
	#superclass : #MustacheLibrary,
	#category : #'Mustache-Library-Examples'
}

{ #category : #templates }
ExampleMustacheLibrary >> pharoBookExampleTemplate [

    ^ 'Hello {{ name }}
You have just won ${{value}}!
{{#in_ca}}
Well, ${{taxed_value}}, after taxes.
{{/in_ca}}'	
]

{ #category : #templates }
ExampleMustacheLibrary >> pharoBookExampleTemplate_exampleContext [

	^ {
		  ('name' -> 'Chris').
		  ('value' -> 10000).
		  ('taxed_value' -> (10000 - (10000 * 0.4))).
		  ('in_ca' -> true) } asDictionary
]
