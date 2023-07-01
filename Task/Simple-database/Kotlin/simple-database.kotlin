// version 1.2.31

import java.text.SimpleDateFormat
import java.util.Date
import java.io.File
import java.io.IOException

val file = File("simdb.csv")

class Item(
    val name: String,
    val date: String,
    val category: String
) : Comparable<Item> {

    override fun compareTo(other: Item) = date.compareTo(other.date)

    override fun toString() = "$name, $date, $category"
}

fun addItem(input: Array<String>) {
    if (input.size < 2) {
        printUsage()
        return
    }
    val sdf = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
    val date = sdf.format(Date())
    val cat = if (input.size == 3) input[2] else "none"
    store(Item(input[1], date, cat))
}

fun printLatest(a: Array<String>) {
    val db = load()
    if (db.isEmpty()) {
        println("No entries in database.")
        return
    }
    // no need to sort db as items are added chronologically
    if (a.size == 2) {
        var found = false
        for (item in db.reversed()) {
            if (item.category == a[1]) {
                println(item)
                found = true
                break
            }
        }
        if (!found) println("There are no items for category '${a[1]}'")
    }
    else println(db[db.lastIndex])
}

fun printAll() {
    val db = load()
    if (db.isEmpty()) {
        println("No entries in database.")
        return
    }
    // no need to sort db as items are added chronologically
    for (item in db) println(item)
}

fun load(): MutableList<Item> {
    val db = mutableListOf<Item>()
    try {
        file.forEachLine { line ->
            val item = line.split(", ")
            db.add(Item(item[0], item[1], item[2]))
        }
    }
    catch (e: IOException) {
        println(e)
        System.exit(1)
    }
    return db
}

fun store(item: Item) {
    try {
        file.appendText("$item\n")
    }
    catch (e: IOException) {
        println(e)
    }
}

fun printUsage() {
    println("""
        |Usage:
        |  simdb cmd [categoryName]
        |  add     add item, followed by optional category
        |  latest  print last added item(s), followed by optional category
        |  all     print all
        |  For instance: add "some item name" "some category name"
    """.trimMargin())
}

fun main(args: Array<String>) {
    if (args.size !in 1..3) {
        printUsage()
        return
    }
    file.createNewFile()  // create file if it doesn't already exist
    when (args[0].toLowerCase()) {
        "add"    -> addItem(args)
        "latest" -> printLatest(args)
        "all"    -> printAll()
        else     -> printUsage()
    }
}
