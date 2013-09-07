package com.github.xtension.annotations

import com.github.xtension.annotations.internal.GetterProcessor
import com.github.xtension.annotations.internal.PackageGetterProcessor
import com.github.xtension.annotations.internal.PrivateGetterProcessor
import com.github.xtension.annotations.internal.ProtectedGetterProcessor
import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.Active

/**
 * Adds a public getter.
 */
@Target(ElementType::FIELD)
@Active(typeof(GetterProcessor))
annotation Getter {
	boolean lazy = false
}

/**
 * Adds a private getter.
 */
@Target(ElementType::FIELD)
@Active(typeof(PrivateGetterProcessor))
annotation PrivateGetter {
	boolean lazy = false
}

/**
 * Adds a protected getter.
 */
@Target(ElementType::FIELD)
@Active(typeof(ProtectedGetterProcessor))
annotation ProtectedGetter {
	boolean lazy = false
}

/**
 * Adds a getter with default (package) visibility.
 */
@Target(ElementType::FIELD)
@Active(typeof(PackageGetterProcessor))
annotation PackageGetter {
	boolean lazy = false
}