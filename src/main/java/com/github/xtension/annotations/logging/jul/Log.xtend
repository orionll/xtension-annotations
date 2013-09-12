package com.github.xtension.annotations.logging.jul

import com.github.xtension.annotations.logging.internal.JULLogProcessor
import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.Active

/**
 * Adds a logger field of type {@link java.util.logging.Logger}.
 */
@Target(ElementType::TYPE)
@Active(typeof(JULLogProcessor))
annotation Log {
}