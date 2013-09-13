package com.github.xtension.annotations.logging.jcl

import com.github.xtension.annotations.logging.internal.JCLLogProcessor
import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.Active

/**
 * Adds a logger field of type {@link org.apache.commons.logging.Log}.
 */
@Target(ElementType::TYPE)
@Active(typeof(JCLLogProcessor))
annotation Log {
}