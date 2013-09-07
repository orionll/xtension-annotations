package com.github.xtension.annotations

import com.github.xtension.annotations.internal.PackageSetterProcessor
import com.github.xtension.annotations.internal.PrivateSetterProcessor
import com.github.xtension.annotations.internal.ProtectedSetterProcessor
import com.github.xtension.annotations.internal.SetterProcessor
import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.Active

/**
 * Adds a public getter.
 */
@Target(ElementType::FIELD)
@Active(typeof(SetterProcessor))
annotation Setter {
}

/**
 * Adds a private getter.
 */
@Target(ElementType::FIELD)
@Active(typeof(PrivateSetterProcessor))
annotation PrivateSetter {
}

/**
 * Adds a protected getter.
 */
@Target(ElementType::FIELD)
@Active(typeof(ProtectedSetterProcessor))
annotation ProtectedSetter {
}

/**
 * Adds a getter with default (package) visibility.
 */
@Target(ElementType::FIELD)
@Active(typeof(PackageSetterProcessor))
annotation PackageSetter {
}