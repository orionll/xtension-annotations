package com.github.xtension.annotations.logging.internal

import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration

abstract class LogProcessor extends AbstractClassProcessor {
	override doTransform(MutableClassDeclaration clazz, extension TransformationContext context) {
		addLogging(clazz, context, loggingSystem)
	}

	def addLogging(MutableClassDeclaration clazz, extension TransformationContext context, LoggingSystem loggingSystem) {
		if (loggingSystem.isAvailable(context)) {
			clazz.addField("log", [
					type = loggingSystem.fieldType(context)
					static = true
					final = true
					initializer = ['''«loggingSystem.initMethod»("«clazz.qualifiedName»")''']
				])
		} else {
			context.addError(clazz, loggingSystem.loggingName + " is not on the build path. ")
		}
	}

	def LoggingSystem loggingSystem()
}

class JULLogProcessor extends LogProcessor {
	override loggingSystem() { new JUL() }
}

class Log4jLogProcessor extends LogProcessor {
	override loggingSystem() { new Log4j() }
}
class Slf4jLogProcessor extends LogProcessor {
	override loggingSystem() { new Slf4j() }
}
