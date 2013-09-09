package com.github.xtension.annotations.internal

import java.util.List

package class ProcessorUtil {
	private new() {
	}

	def static <T> List<T> toList(Object obj) {
		switch (obj) {
			case null : #[]
			List<T> : obj
			default : #[obj as T]
		}
	}
}