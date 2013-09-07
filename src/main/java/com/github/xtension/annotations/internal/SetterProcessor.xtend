package com.github.xtension.annotations.internal

import org.eclipse.xtend.lib.macro.AbstractFieldProcessor
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableFieldDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility

abstract class AbstractSetProcessor extends AbstractFieldProcessor {

	override doTransform(MutableFieldDeclaration field, extension TransformationContext context) {
		if (field.final) {
			field.addError('Cannot create a setter for a final field')
		} else {
			addSetter(field)
		}
	}

	private def void addSetter(MutableFieldDeclaration field) {
		field.declaringType.addMethod('set' + field.simpleName.toFirstUpper) [
			visibility = setterVisibility
			static = field.static
			addParameter(field.simpleName + 'Param', field.type)
			body = ['''«field.simpleName» = «field.simpleName»Param;''']
		]
	}

	def Visibility getSetterVisibility()
}

class SetProcessor extends AbstractSetProcessor {
	override getSetterVisibility() { Visibility::PUBLIC }
}

class PrivateSetterProcessor extends AbstractSetProcessor {
	override getSetterVisibility() { Visibility::PRIVATE }
}

class ProtectedSetterProcessor extends AbstractSetProcessor {
	override getSetterVisibility() { Visibility::PROTECTED }
}

class PackageSetterProcessor extends AbstractSetProcessor {
	override getSetterVisibility() { Visibility::DEFAULT }
}
