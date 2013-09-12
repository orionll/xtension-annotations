package com.github.xtension.annotations.logging.internal

import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.TypeReference

package abstract class LoggingSystem {
	def String loggingName()

	def String initMethod()

	def TypeReference fieldType(TransformationContext context)

	def boolean isAvailable(TransformationContext context)
}

package class JUL extends LoggingSystem {

	override loggingName() { "java-util-logging" }

	override fieldType(extension TransformationContext context) { typeof(java.util.logging.Logger).newTypeReference }

	override isAvailable(TransformationContext context) { true }

	override initMethod() { "Logger.getLogger" }
}

package abstract class ExternalLogging extends LoggingSystem {

	def String className()

	override fieldType(extension TransformationContext context) { findTypeGlobally(className).newTypeReference }

	override isAvailable(extension TransformationContext context) { findTypeGlobally(className) !== null }
}

package class Log4j extends ExternalLogging {

	override className() { "org.apache.log4j.Logger" }

	override loggingName() { "log4j" }

	override initMethod() { "Logger.getLogger" }
}

package class Slf4j extends ExternalLogging {

	override className() { "org.slf4j.Logger" }

	override loggingName() { "slf4j" }

	override initMethod() { "org.slf4j.LoggerFactory.getLogger" }
}