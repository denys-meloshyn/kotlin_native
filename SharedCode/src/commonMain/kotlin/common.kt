package org.kotlin.mpp.mobile

expect fun platformName(): String

fun createApplicationScreenMessage() : String {
    return "Kotlin Rocks on ${platformName()}"
}

interface LoaderI {
    fun get(url: String, completion: (String) -> Unit)
    fun get(url: String, headers: HashMap<String, String>, completion: (String) -> Unit)
}

interface ManagerI {
    fun loadData(completion: (String) -> Unit)
}

data class Credentials(val appId: String, val accessId: String)

data class Currency(val name: String, val code: String, val isoNumber: String, val selfId: String)

class Manager(private val loader: LoaderI, private val credentials: Credentials): ManagerI {
    override fun loadData(completion: (String) -> Unit) {
        loader.get("https://api.github.com/users/defunkt", completion)
    }

    fun loadCurrencies(completion: (Array<Currency>) -> Unit) {
        val urlHeaders = hashMapOf("appId" to credentials.accessId,
            "accessId" to credentials.accessId,
            "Content-Type" to "application/json")

        loader.get("https://restapi.e-conomic.com/currencies", urlHeaders) {
        }
    }
}
