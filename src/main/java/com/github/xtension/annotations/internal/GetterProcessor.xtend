package com.github.xtension.annotations.internal

import com.github.xtension.annotations.Getter
import com.github.xtension.annotations.PackageGetter
import com.github.xtension.annotations.PrivateGetter
import com.github.xtension.annotations.ProtectedGetter
import org.eclipse.xtend.lib.macro.AbstractFieldProcessor
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.FieldDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableFieldDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility

abstract class AbstractGetterProcessor extends AbstractFieldProcessor {
	override doTransform(MutableFieldDeclaration field, extension TransformationContext context) {
		if (isLazy(field, context)) {
			addLazyGetter(field, context)
		} else {
			addGetter(field)
		}
	}

	private def isLazy(MutableFieldDeclaration field, extension TransformationContext context) {
		val annotation = field.findAnnotation(annotationClass.findTypeGlobally)
		annotation.getValue('lazy') as Boolean
	}

	private def void addGetter(MutableFieldDeclaration field) {
		field.declaringType.addMethod('get' + field.simpleName.toFirstUpper) [
			returnType = field.type
			visibility = getterVisibility
			static = field.static
			body = ['''return «field.simpleName»;''']
		]
	}

	private def void addLazyGetter(MutableFieldDeclaration field, extension TransformationContext context) {
		if (field.initializer === null) {
			field.addError("A lazy field must have an initializer")
		}

		field.final = false

		field.declaringType.addField(field.initializedFlagName) [
			visibility = Visibility::PRIVATE
			type = typeof(boolean).newTypeReference
			volatile = true
			static = field.static
			initializer = ['false']
		]

		field.declaringType.addMethod(field.initializerMethodName) [
			visibility = Visibility::PRIVATE
			returnType = field.type
			static = field.static
			body = field.initializer
		]

		val monitor = if (field.static) {
			field.declaringType.simpleName + '.class'
		} else {
			'this'
		}

		field.declaringType.addMethod('get' + field.simpleName.toFirstUpper) [
			returnType = field.type
			visibility = getterVisibility
			static = field.static
			body = ['''
				if (!«field.initializedFlagName») {
					synchronized («monitor») {
						if (!«field.initializedFlagName») {
							«field.simpleName» = «field.initializerMethodName»();
							«field.initializedFlagName» = true;
						}
					}
				}
				return «field.simpleName»;
			''']
		]
	}

	private def static getInitializedFlagName(FieldDeclaration field) {
		'_' + field.simpleName + 'Initialized'
	}

	private def static getInitializerMethodName(FieldDeclaration field) {
		'_init' + field.simpleName.toFirstUpper
	}

	def Visibility getGetterVisibility()

	def Class<?> getAnnotationClass()
}

class GetterProcessor extends AbstractGetterProcessor {
	override getGetterVisibility() { Visibility::PUBLIC }
	override getAnnotationClass() { typeof(Getter) }
}

class PrivateGetterProcessor extends AbstractGetterProcessor {
	override getGetterVisibility() { Visibility::PRIVATE }
	override getAnnotationClass() { typeof(PrivateGetter) }
}

class ProtectedGetterProcessor extends AbstractGetterProcessor {
	override getGetterVisibility() { Visibility::PROTECTED }
	override getAnnotationClass() { typeof(ProtectedGetter) }
}

class PackageGetterProcessor extends AbstractGetterProcessor {
	override getGetterVisibility() { Visibility::DEFAULT }
	override getAnnotationClass() { typeof(PackageGetter) }
}
