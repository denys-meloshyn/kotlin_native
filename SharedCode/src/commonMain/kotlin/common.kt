package org.kotlin.mpp.mobile

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

class AccountingYear {
    var fromDate: CommonDate? = null
    var toDate: CommonDate? = null
    var year: Int? = null
    var periods: String? = null
    var entries: String? = null
    var totals: String? = null
    var vouchers: String? = null
    var selfLink: String? = null
}

class Git(val login: String)

class Manager(
    private val loader: LoaderI,
    private val json: IJson,
    private val foundation: ICommonTypes
) {
    fun loadData(completion: (Git) -> Unit) {
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
