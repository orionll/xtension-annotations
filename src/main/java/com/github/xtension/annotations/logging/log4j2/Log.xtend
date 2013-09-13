package com.github.xtension.annotations.logging.log4j2

import com.github.xtension.annotations.logging.internal.Log4j2LogProcessor
import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.Active

/**
 * Adds a logger field of type {@link org.apache.logging.log4j.Logger}.
 */
@Target(ElementType::TYPE)
@Active(typeof(Log4j2LogProcessor))
annotation Log {
}