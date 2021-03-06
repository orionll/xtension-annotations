package com.github.xtension.annotations.internal

import com.github.xtension.annotations.ToString
import java.util.ArrayList
import java.util.LinkedHashMap
import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableFieldDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableTypeDeclaration

import static extension com.github.xtension.annotations.internal.ProcessorUtil.*

class ToStringProcessor extends AbstractClassProcessor {

	override doTransform(MutableClassDeclaration type, extension TransformationContext context) {
		val annotation = type.findAnnotation(typeof(ToString).findTypeGlobally)

		val includeFieldNames = annotation.getValue('includeFieldNames') as Boolean
		val includeHashCode = annotation.getValue('hashcode') as Boolean
		val includeIdentityHashCode = annotation.getValue('identityHashcode') as Boolean
		val callSuper = annotation.getValue('callSuper') as Boolean
		val of = ProcessorUtil::<String>toList(annotation.getValue('of'))
		val exclude = ProcessorUtil::<String>toList(annotation.getValue('exclude'))

		if (!of.empty && !exclude.empty) {
			type.addError('ToString.of and ToString.exclude are mutually exclusive')
			return
		}
		for (name : of) {
			if (name.empty) {
				type.addError("The name in ToString.of must not be empty")
				return
			}
		}

		val fields = type.declaredFields.map[simpleName].toSet

		for (name : exclude) {
			if (name.empty) {
				type.addError("The name in ToString.exclude must not be empty")
				return
			} else if (!fields.contains(name)) {
				type.addError('''The field «name» is not a member of «type.qualifiedName»''')
			}
		}

		val valuesMap = type.getValuesMap(callSuper, of, exclude)

		val values = new ArrayList<String>
		valuesMap.forEach[ valueName, valueExpression |
			if (!values.empty) {
				values.add('builder.append(", ");')
			}
			if (includeFieldNames) {
				values.add('''builder.append("«valueName»=").append(«valueExpression»);''')
			} else {
				values.add('''builder.append(«valueExpression»);''')
			}
		]

		type.addMethod('toString') [
			returnType = typeof(String).newTypeReference
			body = ['''
				final StringBuilder builder = new StringBuilder();
				builder.append("«type.simpleName»");
				«IF includeHashCode»
					builder.append("@").append(Integer.toString(hashCode(), 16));
				«ENDIF»
				«IF includeIdentityHashCode»
					builder.append("#").append(Integer.toString(System.identityHashCode(this), 16));
				«ENDIF»
				«IF !values.empty»
					builder.append("[");
					«FOR value : values»
						«value»
					«ENDFOR»
					builder.append("]");
				«ENDIF»
				return builder.toString();
			''']
		]
	}

	private def static Map<String, String> getValuesMap(MutableTypeDeclaration type, boolean callSuper, List<String> of, List<String> exclude) {
		val values = new LinkedHashMap

		if (!of.empty) {
			of.forEach[values.put(it, getFieldValueExpression(type, it))]
		} else {
			getFields(type, exclude).forEach[values.put(simpleName, getFieldValueExpression(it))]
		}

		if (callSuper) {
			values.put('super', 'super.toString()')
		}

		values
	}

	private def static String getFieldValueExpression(MutableTypeDeclaration type, String fieldName) {
		val field = type.findDeclaredField(fieldName)

		if (field === null) {
			fieldName
		} else {
			getFieldValueExpression(field)
		}
	}

	private def static String getFieldValueExpression(MutableFieldDeclaration field) {
		val it = field
		switch (it) {
			case type.primitiveArray : '''java.util.Arrays.toString(«simpleName»)'''
			case type.array : '''java.util.Arrays.deepToString(«simpleName»)'''
			default : simpleName
		}
	}

	private def static getFields(MutableTypeDeclaration type, List<String> exclude) {
		type.declaredFields.filter[!static && !exclude.contains(simpleName)]
	}
}
