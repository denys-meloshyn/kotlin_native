package org.kotlin.mpp.mobile

expect fun platformName(): String

fun createApplicationScreenMessage() : String {
    return "Kotlin Rocks on ${platformName()}"
}

interface LoaderI {
    fun get(url: String, completion: (String) -> Unit)
}

interface IJson {
    fun serialize(data: String): HashMap<String, Any>
}

class Git(val login: String)

class Manager(private val loader: LoaderI, private val json: IJson) {
    fun loadData(completion: (Git) -> Unit) {
        loader.get("https://api.github.com/users/defunkt") {
            val data = json.serialize(it)
            val git = Git(login = data["login"] as String)

            completion(git)
        }
    }
}
