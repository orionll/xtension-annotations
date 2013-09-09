package com.github.xtension.annotations

import com.github.xtension.annotations.internal.ToStringProcessor
import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.Active

/**
 * Adds an implementation of toString().
 */
@Target(ElementType::TYPE)
@Active(typeof(ToStringProcessor))
annotation ToString {
	boolean includeFieldNames = true

	String[] of = #[]

	String[] exclude = #[]

	boolean callSuper = false

	boolean hashcode = false

	boolean identityHashcode = false
}