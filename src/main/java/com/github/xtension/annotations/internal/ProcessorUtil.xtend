package com.github.xtension.annotations.internal

import java.util.List
import org.eclipse.xtend.lib.macro.declaration.TypeReference

package class ProcessorUtil {
	private static val PRIMITIVE_ARRAYS = #{'int[]', 'byte[]', 'char[]', 'boolean[]', 'float[]', 'double[]', 'long[]', 'short[]'}

	private new() {
	}

	def static <T> List<T> toList(Object obj) {
		switch (obj) {
			case null : #[]
			List<T> : obj
			default : #[obj as T]
		}
	}

	def static boolean isPrimitiveArray(TypeReference type) {
		PRIMITIVE_ARRAYS.contains(type.simpleName)
	}
}