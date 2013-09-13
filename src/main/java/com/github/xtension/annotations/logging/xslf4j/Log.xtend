package com.github.xtension.annotations.logging.xslf4j

import com.github.xtension.annotations.logging.internal.XSlf4jLogProcessor
import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.Active

/**
 * Adds a logger field of type {@link org.slf4j.ext.XLogger}.
 */
@Target(ElementType::TYPE)
@Active(typeof(XSlf4jLogProcessor))
annotation Log {
}