package com.github.xtension.annotations.internal

import com.github.xtension.annotations.ToString
import java.util.ArrayList
import java.util.LinkedHashMap
import java.util.Map
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import java.util.List

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
		valuesMap.entrySet.forEach[
			if (!values.empty) {
				values.add('builder.append(", ");')
			}
			if (includeFieldNames) {
				values.add('''builder.append("«key»=").append(«value»);''')
			} else {
				values.add('''builder.append(«value»);''')
			}
		]

		type.addMethod('toString') [
			returnType = typeof(String).newTypeReference
			body = ['''
				final StringBuilder builder = new StringBuilder();
				builder.append("«type.simpleName»");
				«IF includeHashCode»
					builder.append("@").append(hashCode());
				«ENDIF»
				«IF includeIdentityHashCode»
					builder.append("#").append(System.identityHashCode(this));
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

	private def static Map<String, String> getValuesMap(MutableClassDeclaration type, boolean callSuper, List<String> of, List<String> exclude) {
		val values = new LinkedHashMap

		if (!of.empty) {
			of.forEach[values.put(it, it)]
		} else {
			type.getFields(exclude).forEach[values.put(simpleName, simpleName)]
		}

		if (callSuper) {
			values.put('super', 'super.toString()')
		}

		values
	}

	private def static getFields(MutableClassDeclaration type, List<String> exclude) {
		type.declaredFields.filter[!static && !exclude.contains(simpleName)]
	}
}
