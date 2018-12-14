package org.kotlin.mpp.mobile

import com.soywiz.klock.DateTime
import kotlinx.serialization.Optional
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JSON
import kotlinx.serialization.list

@Serializable
data class Data(val a: Int, @Optional val b: String = "42")

expect fun platformName(): String

fun createApplicationScreenMessage(): String {
    return "Kotlin Rocks on ${platformName()}"
}

interface LoaderI {
    fun get(url: String, completion: (String) -> Unit)
    fun get(url: String, headers: HashMap<String, String>, completion: (String) -> Unit)
}

interface IJson {
    fun serialize(data: String): HashMap<String, Any>
}

class CommonDate(year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?)

interface ICommonTypes {
    fun dateFrom(string: String): CommonDate?
}

@Serializable
data class AccountingYear (
    var fromDate: CommonDate?,
    var toDate: CommonDate?,
    var year: Int?,
    var periods: String?,
    var entries: String?,
    var totals: String?,
    var vouchers: String?,
    var selfLink: String?
)

class Git(val login: String)

class Manager(
    private val loader: LoaderI,
    private val json: IJson,
    private val foundation: ICommonTypes
) {
    fun loadData(completion: (Git) -> Unit) {
        val now = DateTime.now()

        // serializing objects
        val jsonData = JSON.stringify(Data.serializer(), Data(42))
        // serializing lists
        val jsonList = JSON.stringify(Data.serializer().list, listOf(Data(42)))

        loader.get("https://api.github.com/users/defunkt") {
            val data = json.serialize(it)
            val git = Git(login = data["login"] as String)

            completion(git)
        }
    }

    fun loadAccountingYears(completion: (List<AccountingYear>) -> Unit) {
        loader.get("https://restapi.e-conomic.com/accounting-years") { response ->
            val json = json.serialize(response)
            val collection = json["collection"] as? List<HashMap<String, String>>
//            val r = collection?.map {
//                val accountingYear = AccountingYear()
//                accountingYear.fromDate = foundation.dateFrom(it["fromDate"] ?: "")
//
//                return accountingYear
//            }
        }
    }

}
