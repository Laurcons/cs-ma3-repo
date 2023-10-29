package com.bubu.uionly

import java.io.Serializable

class TripLeg(
    val trainNum: String,
    val depStation: String,
    var arrStation: String,
    val depTime: String,
    val arrTime: String,
    val observations: String,
): Serializable {
    class ValidationResult(val ok: Boolean, val message: String? = null) {}

    private var id: Int = -1;

    fun setId(id: Int) {
        this.id = id;
    }

    fun getId(): Int {
        return id;
    }

    public fun validate(): ValidationResult {
        val timeRegex = """^[0-9]{2}:[0-9]{2}$""".toRegex()
        if (!timeRegex.matches(depTime) || !timeRegex.matches(arrTime))
            return ValidationResult(false, "Times need to look like 14:34")
        return ValidationResult(true)
    }
}