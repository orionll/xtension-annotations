package com.github.xtension.annotations.logging.log4j

import com.github.xtension.annotations.logging.internal.Log4jLogProcessor
import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.Active

/**
 * Adds a logger field of type {@link org.apache.log4j.Logger}.
 */
@Target(ElementType::TYPE)
@Active(typeof(Log4jLogProcessor))
annotation Log {
}