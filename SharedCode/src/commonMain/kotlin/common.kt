package org.kotlin.mpp.mobile

expect fun platformName(): String

fun createApplicationScreenMessage() : String {
    return "Kotlin Rocks on ${platformName()}"
}

interface LoaderI {
    fun get(url: String, completion: (String) -> Unit)
}

class Manager(private val loader: LoaderI) {
    fun loadData(completion: (String) -> Unit) {
        loader.get("https://api.github.com/users/defunkt", completion)
    }
}
