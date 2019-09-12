package utm.scala

import scala.annotation.tailrec
import scala.language.implicitConversions

/**
  * Implementation of Universal Turing Machine in Scala that can simulate an arbitrary
  * Turing machine on arbitrary input
  *
  * @author Abdulla Abdurakhmanov (https://github.com/abdmob/utms)
  */
class UniversalTuringMachine[S](val rules: List[UTMRule[S]],
                                val initialState: S,
                                val finalStates: Set[S],
                                val blankSymbol: String,
                                val inputTapeVals: Seq[String],
                                printEveryIter: Int = 1) {

	private val initialTape = UTMTape(inputTapeVals, 0, blankSymbol)

	@tailrec
	private def iterate(state: S, curIteration: Int, tape: UTMTape): UTMTape = {
		val needToBePrinted = curIteration % printEveryIter == 0

		if (needToBePrinted) {
			print(s"${curIteration}: ${state}: ")
			tape.printTape()
		}

		if (finalStates.contains(state)) {
			println(s"Finished in the final state: ${state}")
			tape.printTape()
			tape
		}
		else {
			rules.find(rule => rule.state == state && rule.fromSymbol == tape.current()) match {
				case Some(rule) => {
					val updatedTape = tape.updated(
						rule.toSymbol,
						rule.action
					)

					iterate(
						rule.toState,
						curIteration + 1,
						updatedTape
					)
				}
				case _ => {
					println(s"Finished: no suitable rules found for ${state}/${tape.current()}")
					tape.printTape()
					tape
				}
			}
		}
	}

	def run(): UTMTape = iterate(state = initialState, curIteration = 0, tape = initialTape)

}

/**
  * Universal Turing Machine actions
  */
sealed trait UTMAction
case class UTMLeft() extends UTMAction
case class UTMRight() extends UTMAction
case class UTMStay() extends UTMAction

/**
  * Universal Turing Machine rule definition
  */
case class UTMRule[S](state: S,
                      fromSymbol: String,
                      toSymbol: String,
                      action: UTMAction,
                      toState: S)

/**
  * Universal Turing Machine Tape
  */
case class UTMTape(content: Seq[String], position: Int, blankSymbol: String) {

	private def updateContentAtPos(symbol: String) = {
		if (position >= content.length) {
			content :+ symbol
		}
		else if (position < 0) {
			symbol +: content
		}
		else
			content.updated(position, symbol)
	}

	private[scala] def updated(symbol: String, action: UTMAction): UTMTape = {
		val updatedTape =
			this.copy(
				content = updateContentAtPos(symbol),
				position = action match {
					case UTMLeft() => position - 1
					case UTMRight() => position + 1
					case UTMStay() => position
				}
			)

		if (updatedTape.position < 0) {
			updatedTape.copy(
				content = blankSymbol +: updatedTape.content,
				position = 0
			)
		}
		else if (updatedTape.position >= updatedTape.content.length) {
			updatedTape.copy(
				content = updatedTape.content :+ blankSymbol
			)
		}
		else
			updatedTape
	}


	private[scala] def current(): String = {
		if (content.isDefinedAt(position))
			content(position)
		else
			blankSymbol
	}

	def printTape(): Unit = {
		print("[")
		if (position < 0)
			print("˅")
		content.zipWithIndex.foreach { case (symbol, index) =>
			if (position == index)
				print("˅")
			else
				print(" ")
			print(s"$symbol")
		}
		if (position >= content.length)
			print("˅")
		println("]")
	}

}

object UniversalTuringMachine extends App {

	object dsl {

		final val right = UTMRight()
		final val left = UTMLeft()
		final val stay = UTMStay()

		implicit def tupleToUTMLRule[S](tuple: (S, String, String, UTMAction, S)): UTMRule[S] =
			UTMRule[S](tuple._1, tuple._2, tuple._3, tuple._4, tuple._5)
	}

        main()

	def main(): Unit = {
		import dsl._

		def createIncrementMachine() = {

			sealed trait IncrementStates
			case class q0() extends IncrementStates
			case class qf() extends IncrementStates

			new UniversalTuringMachine[IncrementStates](
				rules = List(
					(q0(), "1", "1", right, q0()),
					(q0(), "B", "1", stay, qf())
				),
				initialState = q0(),
				finalStates = Set(qf()),
				blankSymbol = "B",
				inputTapeVals = Seq("1", "1", "1")
			).run()

		}

		def createThreeStateBusyBeaver() = {

			sealed trait ThreeStateBusyStates
			case class a() extends ThreeStateBusyStates
			case class b() extends ThreeStateBusyStates
			case class c() extends ThreeStateBusyStates
			case class halt() extends ThreeStateBusyStates

			new UniversalTuringMachine[ThreeStateBusyStates](
				rules = List(
					(a(), "0", "1", right, b()),
					(a(), "1", "1", left, c()),
					(b(), "0", "1", left, a()),
					(b(), "1", "1", right, b()),
					(c(), "0", "1", left, b()),
					(c(), "1", "1", stay, halt())
				),
				initialState = a(),
				finalStates = Set(halt()),
				blankSymbol = "0",
				inputTapeVals = Seq()
			).run()

		}

		def createFiveState2SymBusyBeaverMachine() = {
			sealed trait FiveBeaverStates
			case class FA() extends FiveBeaverStates
			case class FB() extends FiveBeaverStates
			case class FC() extends FiveBeaverStates
			case class FD() extends FiveBeaverStates
			case class FE() extends FiveBeaverStates
			case class FH() extends FiveBeaverStates

			new UniversalTuringMachine[FiveBeaverStates](
				rules = List(
					(FA(), "0", "1", right, FB()),
					(FA(), "1", "1", left, FC()),
					(FB(), "0", "1", right, FC()),
					(FB(), "1", "1", right, FB()),
					(FC(), "0", "1", right, FD()),
					(FC(), "1", "0", left, FE()),
					(FD(), "0", "1", left, FA()),
					(FD(), "1", "1", left, FD()),
					(FE(), "0", "1", stay, FH()),
					(FE(), "1", "0", left, FA())
				),
				initialState = FA(),
				finalStates = Set(FH()),
				blankSymbol = "0",
				inputTapeVals = Seq(),
				printEveryIter = 100000
			).run()
		}

		createIncrementMachine()
		createThreeStateBusyBeaver()

		// careful here, 47 mln iterations,
		// so this is commented to save our nature (I checked it for you anyway):
		// createFiveState2SymBusyBeaverMachine()
	}
}
