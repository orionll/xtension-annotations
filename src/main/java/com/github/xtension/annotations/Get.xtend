package com.github.xtension.annotations

import com.github.xtension.annotations.internal.GetProcessor
import com.github.xtension.annotations.internal.PackageGetProcessor
import com.github.xtension.annotations.internal.PrivateGetProcessor
import com.github.xtension.annotations.internal.ProtectedGetProcessor
import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.Active

/**
 * Adds a public getter.
 */
@Target(ElementType::FIELD)
@Active(typeof(GetProcessor))
annotation Get {
	boolean lazy = false
}

/**
 * Adds a private getter.
 */
@Target(ElementType::FIELD)
@Active(typeof(PrivateGetProcessor))
annotation PrivateGet {
	boolean lazy = false
}

/**
 * Adds a protected getter.
 */
@Target(ElementType::FIELD)
@Active(typeof(ProtectedGetProcessor))
annotation ProtectedGet {
	boolean lazy = false
}

/**
 * Adds a getter with default (package) visibility.
 */
@Target(ElementType::FIELD)
@Active(typeof(PackageGetProcessor))
annotation PackageGet {
	boolean lazy = false
}